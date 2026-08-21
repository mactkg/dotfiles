#!/usr/bin/env bash
#
# claude-plugin-refresh.sh — Inspect and update SHA-pinned inline marketplaces in ~/.claude/settings.json
#
# ~/.claude/settings.json can register inline marketplaces (`"source": "settings"`) whose plugins
# are SHA-pinned via github / git-subdir sources. This tool compares each pinned SHA against the
# current HEAD of the upstream default branch (or the user-supplied ref) and, on request, rewrites
# the pin in place. Human review of the resulting diff is always required before committing.
#
# Usage:
#   claude-plugin-refresh.sh                             # list all pinned plugins: pinned vs upstream HEAD
#   claude-plugin-refresh.sh <marketplace>               # limit to one marketplace key
#   claude-plugin-refresh.sh --write <marketplace>       # rewrite settings.json for that marketplace, then show git diff
#   claude-plugin-refresh.sh --ref <ref> <marketplace>   # compare against a specific ref (branch/tag/sha) instead of default HEAD
#
# Requirements: jq, gh (authenticated).
#
set -euo pipefail

SETTINGS="${CLAUDE_SETTINGS:-$HOME/.claude/settings.json}"

usage() { sed -n '2,/^set -/ p' "$0" | sed 's/^# \?//' | head -n -2; exit "${1:-1}"; }

WRITE=0
REF=""
MARKETPLACE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --write) WRITE=1; shift ;;
    --ref) REF="$2"; shift 2 ;;
    -h|--help) usage 0 ;;
    -*) echo "unknown flag: $1" >&2; usage ;;
    *) MARKETPLACE="$1"; shift ;;
  esac
done

command -v jq >/dev/null || { echo "jq required" >&2; exit 2; }
command -v gh >/dev/null || { echo "gh required" >&2; exit 2; }
[ -f "$SETTINGS" ] || { echo "settings.json not found: $SETTINGS" >&2; exit 2; }

# Emit one line per pinned plugin, `|`-separated (tab-IFS in bash collapses empty adjacent fields).
# Fields: <mp>|<plugin>|<repo>|<subpath>|<pinned_sha>
list_pins() {
  jq -r --arg only "$MARKETPLACE" '
    .extraKnownMarketplaces // {} | to_entries[]
    | select($only == "" or .key == $only)
    | select(.value.source.source == "settings")
    | .key as $mp
    | .value.source.plugins[]?
    | select(.source.sha)
    | [
        $mp,
        .name,
        (.source.repo // .source.url // ""),
        (.source.path // ""),
        .source.sha
      ] | join("|")
  ' "$SETTINGS"
}

# Normalize "owner/repo", "https://github.com/owner/repo(.git)", "git@github.com:owner/repo(.git)" → owner/repo
normalize_repo() {
  local r="$1"
  r="${r%.git}"
  case "$r" in
    https://github.com/*) r="${r#https://github.com/}" ;;
    git@github.com:*)     r="${r#git@github.com:}" ;;
  esac
  printf '%s' "$r"
}

any=0
declare -a updates=()

while IFS='|' read -r mp plugin repo subpath pinned; do
  any=1
  norm=$(normalize_repo "$repo")
  ref="${REF:-HEAD}"
  upstream=$(gh api "repos/$norm/commits/$ref" --jq '.sha' 2>/dev/null || echo "?")
  if [ "$pinned" = "$upstream" ]; then
    status="up-to-date"
  elif [ "$upstream" = "?" ]; then
    status="lookup-failed"
  else
    status="behind"
    updates+=("$mp|$plugin|$pinned|$upstream")
  fi
  printf '%-24s %-24s %s  %s → %s%s\n' \
    "$mp" "$plugin" "$status" "${pinned:0:12}" "${upstream:0:12}" \
    "${subpath:+ [$subpath]}"
done < <(list_pins)

if [ "$any" = 0 ]; then
  echo "no SHA-pinned inline marketplaces found${MARKETPLACE:+ for '$MARKETPLACE'}" >&2
  exit 0
fi

if [ "$WRITE" = 0 ]; then
  [ "${#updates[@]}" -gt 0 ] && echo && echo "Run with --write <marketplace> to update."
  exit 0
fi

if [ -z "$MARKETPLACE" ]; then
  echo "--write requires a specific marketplace argument" >&2
  exit 1
fi
if [ "${#updates[@]}" = 0 ]; then
  echo "nothing to update for '$MARKETPLACE'"
  exit 0
fi

tmp=$(mktemp)
cp "$SETTINGS" "$tmp"
for entry in "${updates[@]}"; do
  IFS='|' read -r mp plugin old new <<<"$entry"
  jq --arg mp "$mp" --arg pl "$plugin" --arg sha "$new" '
    .extraKnownMarketplaces[$mp].source.plugins |=
      map(if .name == $pl then .source.sha = $sha else . end)
  ' "$tmp" > "$tmp.new"
  mv "$tmp.new" "$tmp"
  echo "queued: $mp/$plugin  ${old:0:12} → ${new:0:12}"
done

# Resolve symlink so diff works against the real file location, and to keep tools happy
real=$(readlink -f "$SETTINGS" 2>/dev/null || realpath "$SETTINGS")
mv "$tmp" "$real"
echo
echo "written to $real"
echo
if git -C "$(dirname "$real")" rev-parse --show-toplevel >/dev/null 2>&1; then
  git -C "$(dirname "$real")" --no-pager diff -- "$(basename "$real")" || true
  echo
  echo "Review the diff above. Commit only after checking upstream changes: gh browse -R <repo>"
fi

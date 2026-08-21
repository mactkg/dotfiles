#!/bin/bash
set -euo pipefail

input=$(cat)
hook_event=$(printf '%s' "$input" | jq -r '.hook_event_name')

case "$hook_event" in
WorktreeCreate)
    wt_name=$(printf '%s' "$input" | jq -r '.name')
    git gtr new "$wt_name" --from-current --yes >&2
    wt_abs_path=$(git gtr go "$wt_name" 2>/dev/null)
    cd "$wt_abs_path" >&2
    # Fallback for projects without gtr.hook.postcreate configured.
    # Project-specific extras (e.g. `direnv allow apps/webapp`) belong in the
    # project's own `git config --add gtr.hook.postcreate '...'`.
    direnv allow . >&2 || true
    echo "$wt_abs_path"
    ;;
WorktreeRemove)
    wt_path=$(printf '%s' "$input" | jq -r '.worktree_path')
    branch=$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null)
    git gtr rm "$branch" --delete-branch --yes >&2 || true
    ;;
esac

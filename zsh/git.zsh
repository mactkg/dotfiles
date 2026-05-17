alias g='git'
function cb() {
  local branch=$(git branch | peco | sed -e "s/\* //g" | awk "{print \$1}" )
  git checkout $branch
}

_gtr_init="${XDG_CACHE_HOME:-$HOME/.cache}/gtr/init-gtr.zsh"
[[ -f "$_gtr_init" ]] || eval "$(git gtr init zsh)" || true
source "$_gtr_init" 2>/dev/null || true; unset _gtr_init

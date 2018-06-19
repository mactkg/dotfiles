alias g='git'
function cb() {
  local branch=$(git branch | peco | sed -e "s/\* //g" | awk "{print \$1}" )
  git checkout $branch
}

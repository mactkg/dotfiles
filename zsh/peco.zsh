# Usage
# peco-history-selection(^R): History
# peco-find(^F): Find file
# peco-src(^]): Move to local repository which managed with GHQ
# peco-pr(^g^p): list pr and checkout selected one
# peco-man(N/A): Find man file

function peco-history-selection() {
  BUFFER=`history -n 1 | /usr/bin/tail -r  | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000
setopt hist_ignore_dups
zle -N peco-history-selection
bindkey '^R' peco-history-selection


function peco-find() {
  local current_buffer=$BUFFER
  local search_root=""
  local file_path=""

  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    search_root=`git rev-parse --show-toplevel`
  else
    search_root=`pwd`
  fi
  file_path="$(find ${search_root} -maxdepth 5 | peco)"
  BUFFER="${current_buffer} ${file_path}"
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-find
bindkey '^f' peco-find


function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src


function __peco-man-list-all() {
    local parent dir file
    local paths=("${(s/:/)$(man -aw)}")
    for parent in $paths; do
        for dir in $(/bin/ls -1 $parent); do
            local p="${parent}/${dir}"
            if [ -d "$p" ]; then
                IFS=$'\n' local lines=($(/bin/ls -1 "$p"))
                for file in $lines; do
                    echo "${p}/${file}"
                done
            fi
        done
    done
}

function peco-man() {
    local selected=$(__peco-man-list-all | peco --prompt 'man >')
    if [[ "$selected" != "" ]]; then
        man "$selected"
    fi
}

function peco-checkout-pull-request () {
    local selected_pr_id=$(gh pr list | peco | awk '{ print $1 }')
    if [ -n "$selected_pr_id" ]; then
        BUFFER="gh pr checkout ${selected_pr_id}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-checkout-pull-request
bindkey '^g^p' peco-checkout-pull-request 

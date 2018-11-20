. $HOME/.secrets

export SHELL=/usr/local/bin/zsh
export GREP_OPTIONS='--color=auto'
export EDITOR=nvim
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
export GHQ_ROOT=$HOME/local/src
export DYLIB_DYLOAD=/usr/local/lib:$DYLIB_DYLOAD

typeset -U path cdpath fpath manpath

typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({/usr/local,/usr,}/sbin(N-/))
export PATH=/usr/local/bin:/usr/local/share:$PATH
export PATH=/sbin:/usr/sbin:$HOME/local/bin:/usr/local/sbin:$PATH
export PATH="/usr/local/anaconda3/bin:$PATH"
export PATH="$HOME/.yarn/bin:`yarn global bin`:$PATH"
export PATH="$PATH":"~/.pub-cache/bin"

fpath=(~/.zsh/completion $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)
fpath=($(/usr/local/bin/brew --prefix)/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit -Cu


# aliases
alias c='cd'
alias l='ls'
alias t='tmux'
alias v='vim'

alias ls='gls -G --color=auto'
alias la='gls -GFa --color=auto'
alias ll='gls -GFl --color=auto'

alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'

alias up='cd ../'

alias diff='colordiff'
alias less='less -R'

alias vi='nvim'
alias vim='nvim'
alias ce='carton exec --'
alias be='bundle exec'
alias d-c='docker-compose'

### thefuck
alias fuck='$(thefuck $(fc -ln -1))'
alias linehack='SHELL=/bin/bash mosh linehack'

# direnv
eval "$(direnv hook zsh)"

function dirresolve() {
  cd `pwd -P`
}

# notify end of long command
function preexec () {
  _prev_cmd_start_time=$SECONDS
  _cmd_is_running=true
}

function precmd () {
  if $_cmd_is_running ; then
    _prev_cmd_exec_time=$((SECONDS - _prev_cmd_start_time))
    if ((_prev_cmd_exec_time > 5)); then
      # terminal-notifier -message "Command execution finished" -activate com.apple.Terminal -timeout 3 > /dev/null 2>&1 &
    fi
  fi
  _cmd_is_running=false

}

function new () {
  REPO="$GHQ_ROOT/github.com/mactkg/$1"
  mkdir -p $REPO
  cd $REPO
  git init
}

function new-rails () {
  REPO="$GHQ_ROOT/github.com/mactkg/$1"
  mkdir -p $REPO
  cd $REPO
  bundle init
  echo "gem 'rails'" >> Gemfile
  bundle -j8
  bundle exec rails new . -f --skip-coffee --skip-bundle
  bundle -j8
}


# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# gcloud / kubectl
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

function kubectl() {
  if ! type __start_kubectl >/dev/null 2>&1; then
    source <(command kubectl completion zsh)
  fi

  command kubectl "$@"
}

function __loadzsh {
  . ${ZDOTDIR}/$1
}

__loadzsh zsh.zsh
__loadzsh anyenv.zsh
__loadzsh git.zsh
__loadzsh go.zsh
__loadzsh peco.zsh
__loadzsh node.zsh
__loadzsh android.zsh
__loadzsh flutter.zsh

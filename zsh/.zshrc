. $HOME/.secrets

# remove overlapping
typeset -U path cdpath fpath manpath

# set sudo path
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({/usr/local,/usr,}/sbin(N-/))

# homebrew setting
if [ -d /usr/local/bin ]; then
  eval $(/usr/local/bin/brew shellenv)
else
  eval $(/opt/homebrew/bin/brew shellenv)
fi
export PATH=/sbin:/usr/sbin:$HOME/local/bin:$PATH

fpath=(~/.zsh/completion $fpath)
fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit -Cu

export SHELL=`which zsh`
export GREP_OPTIONS='--color=auto'
export EDITOR=nvim
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
export GHQ_ROOT=$HOME/local/src
export DYLIB_DYLOAD=$HOMEBREW_PREFIX/lib:$DYLIB_DYLOAD

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

function _new () {
  REPO="$GHQ_ROOT/github.com/$1/$2"
  mkdir -p $REPO
  cd $REPO
  git init
}

function new() {
  _new mactkg $1
}

function new-pg () {
  _new mactkg-playground $1
}

function new-rails () {
  new $1
  bundle init
  echo "gem 'rails'" >> Gemfile
  bundle -j8
  bundle exec rails new . -f --skip-coffee --skip-bundle
  bundle -j8
}


# autojump
[ -f $HOMEBREW_PREFIX/etc/profile.d/autojump.sh ] && . $HOMEBREW_PREFIX/etc/profile.d/autojump.sh

# gcloud / kubectl
if [ -d "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk" ]; then
  source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

if [ -d "$HOME/local/opt/google-cloud-sdk" ]; then
  source "$HOME/local/opt/google-cloud-sdk/path.zsh.inc"
  source "$HOME/local/opt/google-cloud-sdk/completion.zsh.inc"
fi

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
__loadzsh asdf.zsh
__loadzsh git.zsh
__loadzsh go.zsh
__loadzsh peco.zsh
__loadzsh node.zsh
__loadzsh android.zsh
__loadzsh flutter.zsh

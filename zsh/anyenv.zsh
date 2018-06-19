if [ `hostname -s` = "mactkg" ]; then
  export RBENV_ROOT=/usr/local/var/rbenv
  export PYENV_ROOT=/usr/local/opt/pyenv
  eval "$(rbenv init - zsh)"
  eval "$(plenv init -)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
else
  export PATH="$HOME/.anyenv/bin:$PATH"
  export PATH=$HOME/.anyenv/envs/ndenv/shims:$PATH
  eval "$(anyenv init - zsh)"
fi

export PATH=$RBENV_ROOT/shims:$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

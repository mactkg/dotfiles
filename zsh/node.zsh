if [ `hostname -s` = "mactkg" ]; then
  eval "$(ndenv init -)"
  export PATH=$HOME/.ndenv/bin:$PATH
fi

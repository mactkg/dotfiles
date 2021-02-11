if [ -d $HOME/.anyenv ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    export PATH=$HOME/.anyenv/envs/nodenv/shims:$PATH
    eval "$(anyenv init - zsh)"
fi
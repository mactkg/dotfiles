autoload -U colors: colors
setopt correct
setopt auto_pushd
setopt auto_param_slash
setopt auto_menu
setopt pushd_ignore_dups
setopt list_packed
setopt prompt_subst
setopt auto_cd
setopt share_history
function chpwd() { gls -G --color=auto }


# Prompt
ARCH=`uname -m`
PROMPT="
[%n] %{${fg[yellow]}%}%~%{${reset_color}%}
%(?.%{$fg[green]%}.%{$fg[blue]%})%(?!(*'-') <!(*;-;%)? <)%{${reset_color}%} "
RPROMPT="[${ARCH}]"
PROMPT2='[%n]> '

SPROMPT="%{$fg[red]%}%{$suggest%}(*'~'%)? < もしかして %B%r%b %{$fg[red]%}かな? [そう!(y), 違う!(n),a,e]:${reset_color} " 

source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval $(gdircolors $HOME/.zsh/colors/dircolors-solarized/dircolors.ansi-universal)

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"
source $ZSH/oh-my-zsh.sh
ZSH_THEME="blinks"

plugins=(git)

setopt  autocd autopushd

bindkey -v
bindkey kj vi-cmd-mode 

alias ll="ls -al"
alias vi="vim"
alias com="git add .;  git commit -v"

if type nvim > /dev/null 2>&1; then
  alias vim="nvim"
  export EDITOR="nvim"
fi

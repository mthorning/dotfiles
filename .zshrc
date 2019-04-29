export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="blinks"

plugins=(git)

source $ZSH/oh-my-zsh.sh
export EDITOR='vim'
bindkey -v

alias ll="ls -al"
alias vi="vim"
alias gc="git add . && git commit -v"
 

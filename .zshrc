export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="blinks"

plugins=(git)

source $ZSH/oh-my-zsh.sh
export EDITOR="vim"
bindkey -v

alias ll="ls -al"
alias vi="vim"
alias com="git add .;  git commit -v"
if type nvim > /dev/null 2>&1; then
  alias vim="nvim"
  export EDITOR="nvim"
fi

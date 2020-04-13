#              _              
#      _______| |__  _ __ ___ 
#     |_  / __| '_ \| '__/ __|
#    _ / /\__ \ | | | | | (__ 
#   (_)___|___/_| |_|_|  \___|
#                             
plugins=(nvm git vi-mode npm npx cargo rust tmux)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
export RPS1="%{$reset_color%}"

setopt  autocd autopushd

bindkey -v
bindkey kj vi-cmd-mode

alias g="git"
alias ll="exa -alg"
alias com="git add .;  git commit -v"
alias glog="git log --oneline"
alias se=sudoedit

function chpwd() {
    emulate -L zsh
    exa -alg
}

export VISUAL="vim"
export EDITOR="vim"
if type nvim > /dev/null 2>&1; then
    alias vi="nvim"
    alias vim="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
fi

if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi


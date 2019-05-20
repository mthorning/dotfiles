#              _              
#      _______| |__  _ __ ___ 
#     |_  / __| '_ \| '__/ __|
#    _ / /\__ \ | | | | | (__ 
#   (_)___|___/_| |_|_|  \___|
#                             
export ZSH="$HOME/.oh-my-zsh"
export RPS1="%{$reset_color%}"
export EDITOR="vim"

ZSH_THEME="spaceship"

plugins=(git vi-mode)

setopt  autocd autopushd
source $ZSH/oh-my-zsh.sh

bindkey -v
bindkey kj vi-cmd-mode 

alias ll="ls -al"
alias vi="vim"
alias com="git add .;  git commit -v"

function chpwd() {
    emulate -L zsh
    ls -al
}

if type nvim > /dev/null 2>&1; then
  alias vim="nvim"
  export EDITOR="nvim"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if [ "$TMUX" = "" ]; then tmux; fi


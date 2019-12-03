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

alias ll="ls -al"
alias com="git add .;  git commit -v"
alias glog="git log --oneline --graph"

function chpwd() {
    emulate -L zsh
    ls -al
}

alias vi="vim"
export VISUAL="vim"
export EDITOR="vim"
if type nvim > /dev/null 2>&1; then
    alias vi="nvim"
    alias vim="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi

alias less='less -m -g -i -J --underline-special --SILENT'
export TERM=xterm


if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

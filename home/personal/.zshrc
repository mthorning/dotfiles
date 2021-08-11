plugins=(nvm git vi-mode npm npx cargo rust tmux)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
export RPS1="%{$reset_color%}"
fpath=($fpath "/home/mthorning/.zfunctions")

eval "$(starship init zsh)"

setopt  autocd autopushd

bindkey -v
bindkey kj vi-cmd-mode

alias g="git"
alias com="git add .;  git commit -v"
alias glog="git log --oneline"
alias se=sudoedit
alias lg="lazygit"
alias ll="ls -al"

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

export PATH="$PATH:/home/mthorning/.cargo/bin"
export PATH="$PATH:/home/mthorning/.local/bin"

export GOPATH=/home/mthorning/golibs
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

export GOPATH=$GOPATH:/home/mthorning/code/go

SAVEHIST=100000

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.fzf.zsh

INITIAL_QUERY=""
export RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
export FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' fzf --bind 'change:reload:$RG_PREFIX {q} || true' --ansi --disabled --query '$INITIAL_QUERY' --height=50% --layout=reverse"

####################
# Functions:

sshadd() {
    eval $(ssh-agent)
    ssh-add ~/.ssh/$1
}

gitrecover() {
  find .git/objects/ -type f -empty | xargs rm
  git fetch -p
  git fsck --full
}

displays() {
  xrandr | grep " connected" | cut -f1 -d " "	
}

acer() {
  xrandr --auto
  xrandr --output DP-1-1 --primary --left-of eDP-1
}

# restart pulseaudio when it hurts my ears
pak() { 
  pulseaudio -k
  pactl set-default-sink alsa_output.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock_1__sink
}


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
fpath=($fpath "/home/mthorning/.zfunctions")

eval "$(starship init zsh)"

setopt  autocd autopushd

bindkey -v
bindkey kj vi-cmd-mode

alias g="git"
alias ll="exa -alg"
alias com="git add .;  git commit -v"
alias glog="git log --oneline"
alias se=sudoedit
alias lastvim='nvim -S ~/current-session.vim'

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


sshadd() {
    eval $(ssh-agent)
    ssh-add ~/.ssh/$1
}

gitrecover() {
  find .git/objects/ -type f -empty | xargs rm
  git fetch -p
  git fsck --full
}

export PATH="$PATH:/home/mthorning/.cargo/bin"

# set DISPLAY variable to the IP automatically assigned to WSL2
# for running cypress GUI
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
sudo /etc/init.d/dbus start &> /dev/null

export GOPATH=/home/mthorning/golibs
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

export GOPATH=$GOPATH:/home/mthorning/code/go


plugins=(docker docker-compose nvm git vi-mode npm rust tmux zsh-autosuggestions)

export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"
source $ZSH/oh-my-zsh.sh
export RPS1="%{$reset_color%}"
fpath=($fpath "$HOME/.zfunctions")

eval "$(starship init zsh)"

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

setopt  autocd autopushd

bindkey -v
bindkey kj vi-cmd-mode

alias g="git"
alias m="git machete"
alias com="git add .;  git commit -v"
alias glog="git log --oneline"
alias se=sudoedit
alias lg="lazygit"
alias ll="ls -al"
alias ts="$HOME/.local/bin/tmux-sessioniser"
alias vi="nvim"
alias vim="nvim"
alias weather="curl -s wttr.in | grep -v @igor_chubin"
alias truro="curl -s wttr.in/truro | grep -v @igor_chubin"
alias maria="mysql -h 192.168.1.166 -u root -p"

export EDITOR="nvim"
export VISUAL="nvim"

if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/opt/homebrew/opt/mysql-client/bin"
export PATH="$PATH:$HOME/flutter/bin"

# export GOPATH=$HOME/golibs
# export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

# export GOPATH=$GOPATH:$HOME/code/go

SAVEHIST=100000

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

INITIAL_QUERY=""
export RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
export FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' fzf --bind 'change:reload:$RG_PREFIX {q} || true' --ansi --disabled --query '$INITIAL_QUERY' --height=50% --layout=reverse"

# if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
#   export VISUAL="nvr -cc tabedit --remote-wait +'set bufhidden=wipe'"
# else
  export VISUAL="nvim"
# fi
alias v="$VISUAL"

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

snap() {
  npm test -- -u && git commit -am "updated snapshot"
}

hgrep() { 
  awk 'NR==1 {print; next} /'"$1"'/ {print}'
}

kubedesc() {
  RESOURCE_TYPE=$1
  shift
  RESOURCE=$(kubectl get "${RESOURCE_TYPE}" "$@" -o custom-columns=":metadata.name,:metadata.namespace" | fzf)
  NAME=$(echo "$RESOURCE" | awk '{print $1}')
  NAMESPACE=$(echo "$RESOURCE" | awk '{print $2}')
  if [ -z "$NAME" ]; then
    return
  fi
  kubectl describe "$RESOURCE_TYPE" -n "$NAMESPACE" "$NAME" | less
}

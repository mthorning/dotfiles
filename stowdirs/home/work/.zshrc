source ~/dotfiles/.zshrc

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h    

source <(kubectl completion zsh)

source $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

export PATH="${PATH}:/Users/matthewthorning/server/apps/ometria.tools/bin"
source ~/server/apps/ometria.tools/shellrc.sh

alias ompsql=~/server/apps/ometria.developer_environment/tools/docker-psql

export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"

eval "$(pyenv init -)"

export WORKON_HOME=$HOME/.virtualenvs

export PROJECT_HOME=/Volumes/work/server/apps

dev() {
    	nodemon  --verbose --watch ./src --exec "npm run build"
}

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


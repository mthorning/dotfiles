source ~/dotfiles/.zshrc

export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h    

source <(kubectl completion zsh)

source $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

export PATH="${PATH}:/Users/matthewthorning/server/apps/ometria.tools/bin"
source ~/server/apps/ometria.tools/shellrc.sh

alias ompsql="psql ometria_core -h localhost -p 5432 -U ometria"

export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
export PATH="/Users/matthewthorning/Library/Python/3.9/bin:$PATH"


eval "$(pyenv init -)"

export WORKON_HOME=$HOME/.virtualenvs
source /opt/homebrew/bin/virtualenvwrapper.sh

export PROJECT_HOME=/Volumes/work/server/apps

dev() {
    	nodemon  --verbose --watch ./src --exec "npm run build"
}

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

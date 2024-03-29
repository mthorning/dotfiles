source ~/dotfiles/.zshrc
plugins=(docker docker-compose nvm git vi-mode npm rust tmux zsh-autosuggestions asdf)

export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h    
export DOCKER_DEFAULT_PLATFORM=linux/amd64

source <(kubectl completion zsh)

source $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

source ~/server/apps/ometria.tools/shellrc.sh

alias ompsql="psql ometria_core -h localhost -p 5432 -U ometria"
alias omcomposer="docker exec -it -w /server/apps/ometria.console2/composer ometriaconsole2_console2_1  php composer.phar install"
alias tc="npm run type-check"

eval "$(pyenv init -)"

# export WORKON_HOME=$HOME/.virtualenvs
# source /opt/homebrew/bin/virtualenvwrapper.sh
# export VIRTUALENVWRAPPER_PYTHON=$(which python3)

export PROJECT_HOME=/Volumes/work/server/apps

dev() {
    	nodemon  --verbose --watch ./src --exec "npm run build"
}


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export PATH="${PATH}:/Users/matthewthorning/server/apps/ometria.tools/bin"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
# export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
# export PATH="/Users/matthewthorning/Library/Python/3.9/bin:$PATH"



export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

omconnect() {
  bw login --apikey
  export  BW_SESSION=$(bw unlock --raw --passwordfile ~/.local/.bw)
  bw get totp omaws | pbcopy
  omctl -c $1
}

npmpublish() {
  bw login --apikey
  export  BW_SESSION=$(bw unlock --raw --passwordfile ~/.local/.bw)
  bw get totp omnpm | pbcopy
  npm publish
}

# bun completions
[ -s "/Users/matthewthorning/.bun/_bun" ] && source "/Users/matthewthorning/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

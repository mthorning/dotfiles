source ~/dotfiles/home/base/.zshrc

export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h    

source $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

export PATH="${PATH}:/Users/matthewthorning/server/apps/ometria.tools/bin"
source ~/server/apps/ometria.tools/shellrc.sh

alias psql=~/server/apps/ometria.developer_environment/tools/docker-psql

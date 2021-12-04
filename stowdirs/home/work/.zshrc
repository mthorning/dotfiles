source ~/dotfiles/.zshrc

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
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

alias prod='aws-vault exec prod -- aws eks update-kubeconfig --name ew1-prod --alias ew1-prod && kubectl config use-context ew1-prod && aws-vault exec prod -- $SHELL -l'
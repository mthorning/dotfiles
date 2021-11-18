source ~/dotfiles/home/base/.zshrc

export AWS_ASSUME_ROLE_TTL=1h
export AWS_SESSION_TTL=12h    

. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

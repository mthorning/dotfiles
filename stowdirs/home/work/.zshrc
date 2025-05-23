# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mthorning/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mthorning/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mthorning/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mthorning/google-cloud-sdk/completion.zsh.inc'; fi

# eval "$(direnv hook zsh)"

alias irmdb="kubectl exec -it mysql-0 -n devenv -- mysql --user=user --password=pass --database=grafana_incident"
alias irmreset="make down && make cluster/down && make clean-dist && make cluster/up && make irm-local/up"
alias cc="git add . && claude \"commit code\""

source ~/dotfiles/.zshrc

alias cloud_sso="~/grafana/deployment_tools/scripts/sso/gcloud.sh && AWS_PROFILE=workloads-ops ~/grafana/deployment_tools/scripts/sso/aws.sh && ~/grafana/deployment_tools/scripts/sso/az.sh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

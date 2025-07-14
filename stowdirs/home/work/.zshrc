# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

export PATH=$HOME/development/flutter/bin:$PATH

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH

  #For compilers to find ruby:
  export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
fi

export PATH=$HOME/.gem/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$HOME/android_sdk/cmdline-tools/latest/bin"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME="$HOME/android_sdk"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

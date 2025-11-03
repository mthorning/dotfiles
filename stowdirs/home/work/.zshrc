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
alias fltt="pnpm format && pnpm lint && pnpm type-check && pnpm test:ci"

# Source main dotfiles config (contains all the core setup)
source ~/dotfiles/.zshrc

# Work-specific aliases
alias cloud_sso="~/grafana/deployment_tools/scripts/sso/gcloud.sh && AWS_PROFILE=workloads-ops ~/grafana/deployment_tools/scripts/sso/aws.sh && ~/grafana/deployment_tools/scripts/sso/az.sh"

reviews() {
    { printf "%-7s %-45s %-20s %s\n" "ID" "TITLE" "REPO" "AUTHOR"
      printf "%s\n\n" "$(printf '─%.0s' {1..85})"
      gh search prs --review-requested=@me --repo=grafana/irm --repo=grafana/oncall-mobile-app --repo=grafana/oncall --repo=grafana/gops-labels --state=open --json number,title,url,author,repository --jq '.[] | [.number, .title, .url, .author.login, .repository.name] | @tsv' | while IFS=$'\t' read -r num title url author repo; do
          # Truncate title if longer than 42 characters (leaving room for "...")
          if [ ${#title} -gt 42 ]; then
              title="${title:0:42}..."
          fi
          printf "\033]8;;%s\033\\#%s\033]8;;\033\\%-$((7-${#num}))s %-45s %-20s %s\n\n" "$url" "$num" "" "$title" "$repo" "$author"
      done
    }
}

cg() {
  # If an argument is provided, try to cd directly to it first
  if [[ -n "$1" ]] && [[ -d ~/grafana/"$1" ]]; then
    cd ~/grafana/"$1"
    return 0
  fi

  # Open fzf, optionally with the argument as initial query
  DIR=$(find ~/grafana -maxdepth 1 -type d | sed "s|$HOME/grafana/||" | fzf --query="$1" --preview "ls -la ~/grafana/{}")

  if [[ -z "$DIR" ]]; then
    return 0
  fi

  cd ~/grafana/"$DIR"
}

# Work-specific development paths
# Flutter and Dart
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$HOME/flutter/flutter/bin:$PATH" # Keep both for compatibility
export PATH="$HOME/.pub-cache/bin:$PATH"

# Ruby (if available)
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  export PATH="$(gem environment gemdir)/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
fi

# Java and Android SDK
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export ANDROID_HOME="$HOME/android_sdk"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_AVD_HOME="$HOME/.android/avd"

# Consolidated Android/Java PATH (avoid duplicates)
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_SDK_ROOT/build-tools/35.0.0:$PATH"

# Work-specific completions (lightweight additions only)
# Dart CLI completions
[[ -f /Users/mthorning/.config/.dart-cli-completion/zsh-config.zsh ]] && . /Users/mthorning/.config/.dart-cli-completion/zsh-config.zsh || true

# Docker completions (add to fpath, compinit already handled by main config)
fpath=(/Users/mthorning/.docker/completions $fpath)

# Override NVM lazy loading for work if you need immediate access
# Uncomment the following lines if you need Node.js available immediately:
# unset -f nvm node npm npx
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


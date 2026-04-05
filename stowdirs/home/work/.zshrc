# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mthorning/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mthorning/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mthorning/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mthorning/google-cloud-sdk/completion.zsh.inc'; fi

# eval "$(direnv hook zsh)"

alias irmdb="kubectl exec -it mysql-0 -n devenv -- mysql --user=user --password=pass --database=grafana_incident"
alias irmreset="make down && make cluster/down && make clean-dist && make cluster/up && make irm-local/up"
alias fltt="pnpm format && pnpm lint && pnpm type-check && pnpm test:ci"
alias nats="nats --server=nats.devenv.svc.cluster.local:4222 --user=nats-token"
alias tc="pnpm run type-check"
alias grass="grafana-assistant"
alias create-pr="ai \"Create a PR using the JJ skill\""
alias ai="pi"

# Source main dotfiles config (contains all the core setup)
source ~/dotfiles/.zshrc

# Work-specific aliases
alias cloud_sso="~/grafana/deployment_tools/scripts/sso/gcloud.sh && AWS_PROFILE=workloads-ops ~/grafana/deployment_tools/scripts/sso/aws.sh && ~/grafana/deployment_tools/scripts/sso/az.sh"

reviews() {
    { printf "%-8s %-7s %-45s %-20s %s\n" "ID" "DRAFT" "TITLE" "REPO" "AUTHOR"
      printf "%s\n\n" "$(printf '─%.0s' {1..100})"
      gh search prs --review-requested=@me --repo=grafana/irm --repo=grafana/oncall-mobile-app --repo=grafana/oncall --repo=grafana/gops-labels --state=open --json number,title,url,author,repository,isDraft --jq '.[] | [.number, .title, .url, .author.login, .repository.name, .isDraft] | @tsv' | while IFS=$'\t' read -r num title url author repo draft; do
          if [ ${#title} -gt 42 ]; then
              title="${title:0:42}..."
          fi
          draft_str=$([ "$draft" = "true" ] && echo "Yes" || echo "No")
          id_link=$(printf "\033]8;;%s\033\\#%s\033]8;;\033\\" "$url" "$num")
          padding=$(printf "%$((8 - ${#num} - 1))s" "")
          printf "%s%s %-7s %-45s %-20s %s\n\n" "$id_link" "$padding" "$draft_str" "$title" "$repo" "$author"
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

# Daily notes directory for Obsidian
export DAILY_NOTES_DIR="$HOME/Documents/Notes/Daily"

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
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

playwright-report() {
  local zip_file="${1:-$(ls -t ~/Downloads/playwright-report*.zip 2>/dev/null | head -1)}"

  if [[ -z "$zip_file" ]]; then
    echo "Usage: playwright-report <trace.zip>"
    return 1
  fi

  if [[ ! -f "$zip_file" ]]; then
    echo "File not found: $zip_file"
    return 1
  fi

  local base="$HOME/Downloads/playwright"
  local target="$base"
  local i=2
  while [[ -d "$target" ]]; do
    target="${base}${i}"
    ((i++))
  done

  mkdir -p "$target"
  unzip -q "$zip_file" -d "$target"
  npx --yes playwright show-report "$target"
}


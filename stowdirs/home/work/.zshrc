source ~/dotfiles/.zshrc
plugins=(docker docker-compose nvm git vi-mode npm rust tmux zsh-autosuggestions)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mthorning/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mthorning/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mthorning/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mthorning/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="$PATH:/Users/mthorning/go/bin"

# pnpm
export PNPM_HOME="/Users/mthorning/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export XDG_CONFIG_HOME="$HOME/.config"

# Load pnpm completion (keep this as it's lightweight)
source ~/completion-for-pnpm.zsh

# Defer compinit until after zinit plugins are loaded
# This will be called later in the config

alias m="git machete"
alias lg="lazygit"
alias ls="lsd"
alias ll="ls -al"
alias ts="$HOME/.local/bin/tmux-sessioniser"
alias weather="curl -s wttr.in/truro | grep -v @igor_chubin"
alias rcat="cat"
alias cat="bat"
alias v="nvim"
alias prc="gh pr checkout"
alias c="claude"
alias ta="tmux attach"

export EDITOR="nvim"
export VISUAL="nvim"

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"
. "$HOME/.deno/env"


HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt autopushd

bindkey '^@' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

eval "$(fzf --zsh)"

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

####################
# Functions:

gitrecover() {
  find .git/objects/ -type f -empty | xargs rm
  git fetch -p
  git fsck --full
}

# pnpm
export PNPM_HOME="/Users/mthorning/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

source <(COMPLETE=zsh jj)


autoload -Uz compinit
# Check if we need to regenerate completions (once per day)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

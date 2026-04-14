autoload -Uz compinit
# Check if we need to regenerate completions (once per day)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

export XDG_CONFIG_HOME="$HOME/.config"

# Load pnpm completion (keep this as it's lightweight)
source ~/completion-for-pnpm.zsh

# Defer compinit until after zinit plugins are loaded
# This will be called later in the config

alias src="source ~/.zshrc"
alias m="git machete"
alias lg="lazygit"
alias ls="lsd"
alias ll="ls -al"
alias weather="curl -s wttr.in/truro | grep -v @igor_chubin"
alias cat="bat"
alias v="nvim"

alias p="pnpm"
alias pr="pnpm run"
alias pin="pnpm install"
alias pls="pnpm ls"

alias g="git"
alias gl="git pull"
alias gco="git checkout"
alias gst="git status"
alias prc="gh pr checkout"

alias jjwatch="watch --color jj --ignore-working-copy log --color=always"
alias stl="jj workspace update-stale"

alias ts="$HOME/.local/bin/tmux-sessioniser 2> /dev/null"
alias ta="tmux attach"
alias qf="sed 's/$/:1:1:modified/' | nvim -q -"

alias cleanup_tm_snaps="sudo tmutil listlocalsnapshots / | grep 'com.apple.TimeMachine' | awk -F. '{print \$NF}' | xargs -I {} sudo tmutil deletelocalsnapshots {}"

# ── Sandboxed agent wrappers ──────────────────────────────────────────────────
# Default pi now runs in a safer nono profile without injected GitHub credentials.
# One-time setup for elevated GitHub profiles:
#   security add-generic-password -U -s "nono" -a "github_token" -w "$(gh auth token)"
# Requires a nono credential named `github_token`.
alias claude="nono run --allow-cwd --profile claude-code-custom -- claude --dangerously-skip-permissions"
alias pi="nono run --profile pi-safe --allow-cwd -- pi"
alias pi-review="nono run --profile pi-review --allow-cwd --env-credential-map github_token GH_TOKEN -- pi"
alias pi-pr="nono run --profile pi-pr --allow-cwd --env-credential-map github_token GH_TOKEN -- pi"
alias pi-grafana="nono run --profile pi-grafana --allow-cwd -- pi"
alias pi-playwright="nono run --profile pi-playwright --allow-cwd -- pi"
alias pi-unsafe="pi"
alias cursor="nono run --profile cursor --allow-cwd -- cursor"


# Widget to insert jj bookmark at cursor
function jjb-widget() {
  local bookmark=$(jj bookmark list --template '
    if(!self.remote(),
      separate(" | ",
        name,
        self.normal_target().description().first_line(),
        if(self.synced(), "[in-sync]", "[out-of-sync]")
      ) ++ "\n"
    )
  ' | fzf --height 40% --reverse --header "Select Bookmark" | awk -F' | ' '{print $1}')

  if [[ -n "$bookmark" ]]; then
    LBUFFER="${LBUFFER}${bookmark}"
  fi
  zle reset-prompt
}
zle -N jjb-widget

export EDITOR="nvim"
export VISUAL="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"



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

bindkey -e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^x^e' edit-command-line
bindkey -M emacs '^[e' edit-command-line
bindkey '^@' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -r '^[h'
bindkey -r '^['

eval "$(fzf --zsh)"

# Bind jjb-widget after fzf init to avoid conflicts
bindkey '^b' jjb-widget

####################
# Functions:

# Will leave you in yazi dir with `q` or previous
# location with `Q`
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}


source <(COMPLETE=zsh jj)

# Sync pi theme with macOS appearance (on startup + watch for changes)
~/dotfiles/bin/pi-sync-theme 2>/dev/null
if command -v dark-notify &>/dev/null && ! pgrep -f 'dark-notify.*pi-sync-theme' &>/dev/null; then
    dark-notify -o -c ~/dotfiles/bin/pi-sync-theme &>/dev/null &
    disown
fi

# Initialize starship prompt
eval "$(starship init zsh)"

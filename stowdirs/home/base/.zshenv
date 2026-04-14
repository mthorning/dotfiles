# Minimal environment for all zsh invocations (interactive and non-interactive)
# Keep this file lightweight so tools like Pi get the same PATH as your shell.

[[ -f "$HOME/.config/zsh/zshenv" ]] && source "$HOME/.config/zsh/zshenv"
[[ -f "$HOME/.zshenv_vars" ]] && source "$HOME/.zshenv_vars"

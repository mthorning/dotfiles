# AGENTS.md - Dotfiles Guide

Personal dotfiles managed with **GNU Stow** for profile-based configuration (personal/work/shared).

## Repository Structure

```
stowdirs/home/
  base/       # Shared configs across ALL profiles
  personal/   # Personal machine overrides
  work/       # Work machine overrides

# Config directories (symlinked to stowdirs/home/base/.config/):
nvim/         # Neovim config
zed/          # Zed editor config
tmux/         # Tmux config
yazi/         # Yazi file manager
lazygit/      # Lazygit config
ghostty/      # Ghostty terminal

# Other:
Brewfile      # Homebrew packages
Makefile      # Stow commands
skills/       # Custom skills/scripts
```

## How Stow Works

Stow creates symlinks from `stowdirs/home/{profile}/` to `$HOME`. Files in `stowdirs/home/base/.config/zed/keymap.json` → `$HOME/.config/zed/keymap.json`.

**Profile layers**: `base/` (universal shared config) + `personal/` or `work/` (machine-specific overrides). The `--override=".zshrc"` flag allows profile-specific files to replace base files.

## Key Commands

```bash
make stow-personal    # Install base + personal overrides
make stow-work        # Install base + work overrides
make unstow-all       # Remove all symlinks

make brew             # Install Brewfile packages
make all              # Install brew, nvm, node, pnpm, zinit
```

## Critical Rules for Agents

1. **Always edit files in `stowdirs/home/{profile}/`**, never in `$HOME` directly
2. **Use `base/` for shared config** (used on all machines), `personal/`/`work/` only for machine-specific overrides
3. **Config directories at root** (`nvim/`, `zed/`, etc.) are symlinked from `stowdirs/home/base/.config/`
4. **After editing**, changes reflect immediately via symlinks—just commit to git
5. **Tool stack**: neovim, zed, tmux, yazi, lazygit, starship, jj (jujutsu), fzf, ripgrep

## Common Tasks

**Add new config file (shared across all machines):**
```bash
mkdir -p stowdirs/home/base/.config/myapp
mv ~/.config/myapp/config.yml stowdirs/home/base/.config/myapp/
```

**Create machine-specific override:**
```bash
# For work-only configuration
mkdir -p stowdirs/home/work/.config/myapp
cp stowdirs/home/base/.config/myapp/config.yml stowdirs/home/work/.config/myapp/
# Edit work version to differ from base
```

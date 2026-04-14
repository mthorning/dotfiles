# AGENTS.md - Dotfiles Guide

Personal dotfiles managed with **GNU Stow** for profile-based configuration (personal/work/shared). The coding agent is **pi** running inside **nono** (capability-based sandbox) for safe, controlled file/network access.

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

# Pi agent config:
.pi/agent/pi-permissions.jsonc  # Tool/bash permission rules (pi-level)

# Nono sandbox config (work profile):
stowdirs/home/work/.config/nono/profiles/pi.json  # Nono sandbox profile for pi

# Other:
Brewfile      # Homebrew packages
Makefile      # Stow commands
skills/       # Pi skills (see below)
```

## Nono Sandbox

Pi runs inside **nono** (`nono run --profile pi -- pi`), which provides OS-level sandboxing:

- **Filesystem**: only the working directory (readwrite) and explicitly allowed paths (`$HOME/.pi`, nvm, nvim data) are accessible
- **Security groups**: `node_runtime`, `git_config`, `unlink_protection`, etc. grant common access patterns
- **Rollback**: nono can snapshot and restore file changes made during a session
- **Audit**: all sandboxed commands are logged for review (`nono audit`)

Nono enforces the outer security boundary (what the process *can* touch), while pi's own permissions in `.pi/agent/pi-permissions.jsonc` control what the agent *will* do (allow/ask/deny per tool and bash command).

### GitHub CLI auth inside pi

`gh` in the normal shell uses the macOS keychain (`gh auth status` shows `Logged in ... (keyring)`). Inside pi, direct keychain access may fail, so `gh` can return `401 Unauthorized` even when it works outside the sandbox.

This repo solves that by launching pi with a nono-injected credential:

```zsh
alias pi="nono run --profile pi --allow-cwd --env-credential-map github_token GH_TOKEN -- pi"
```

One-time setup to copy the existing `gh` token into nono's credential store:

```bash
security add-generic-password -U -s "nono" -a "github_token" -w "$(gh auth token)"
```

Useful checks:

```bash
gh auth token              # run outside pi to read token from gh's keyring auth
pi
gh auth status
gh pr status
```

If GitHub commands fail in pi with auth errors, first verify that the `github_token` nono credential exists and that the `pi` alias still includes `--env-credential-map github_token GH_TOKEN`.

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
6. **Two layers of permissions**: nono (OS-level sandbox in `nono/profiles/pi.json`) and pi (agent-level in `.pi/agent/pi-permissions.jsonc`)

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

## Skills

Pi skills live in `skills/` and provide task-specific instructions:

| Skill | Description |
|-------|-------------|
| `code-search` | Searching codebases effectively |
| `docs` | Documentation tasks |
| `grafana` | Grafana dashboard/config work |
| `jj` | Jujutsu VCS workflows |
| `notes` | Note-taking with Obsidian |
| `plans` | Write repo-local planning markdown files |
| `pr-review` | Review GitHub PR code changes |
| `pr-workflow` | Create, inspect, and update GitHub PRs |
| `skill-updating` | Creating/updating skills |
| `tmux-pane` | Tmux pane interaction |

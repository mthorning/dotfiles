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

### Pi profiles and GitHub CLI auth

Pi runs under multiple nono profiles with different privilege levels:

```zsh
alias pi="nono run --profile pi-safe --allow-cwd -- pi"                                              # safe default, no GitHub token
alias pi-review="nono run --profile pi-review --allow-cwd --env-credential-map github_token GH_TOKEN -- pi"  # PR review / inspection
alias pi-pr="nono run --profile pi-pr --allow-cwd --env-credential-map github_token GH_TOKEN -- pi"          # PR creation / push
alias pi-unsafe="command pi"                                                                                # escape hatch, no nono
```

Only `pi-review` and `pi-pr` inject `GH_TOKEN`. The default `pi` has no GitHub credentials.

One-time setup to copy the existing `gh` token into nono's credential store:

```bash
security add-generic-password -U -s "nono" -a "github_token" -w "$(gh auth token)"
```

Useful checks:

```bash
gh auth token              # run outside pi to read token from gh's keyring auth
pi-pr                      # launch with GitHub credentials
gh auth status
gh pr status
```

If GitHub commands fail in `pi-review` or `pi-pr` with auth errors, first verify that the `github_token` nono credential exists. See `nono/PI-GUARDRAILS.md` for the full operating model.

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

## Neovim–Pi Integration (pi_tmux)

A custom Neovim plugin at `nvim/lua/pi_tmux/` provides tight integration between Neovim and pi running in tmux panes. The plugin is loaded via `nvim/lua/plugins/pi.lua` (uses `dir = vim.fn.stdpath('config')`) and user commands are registered in `nvim/plugin/pi_tmux.lua`.

### Architecture

```
nvim/lua/pi_tmux/
  init.lua       # Main module: setup, dispatch logic, apply-via-RPC
  context.lua    # Builds context (cursor, selection, diff) for prompts
  tmux.lua       # Tmux pane management (create, find, send prompt)
nvim/plugin/pi_tmux.lua   # Registers user commands
bin/tmux-pi               # Shell wrapper that labels the tmux pane and exec's pi
```

### User Commands

| Command | Mode | Description |
|---------|------|-------------|
| `PiChatHere` | n | Chat with pi about the file at cursor position (reuses existing pi pane) |
| `PiChatSelection` | v | Chat with pi about visual selection |
| `PiApplySelection` | v | Send selection to pi via RPC for an inline edit (no tmux, uses `pi --mode rpc`) |
| `PiNewHere` | n | Like PiChatHere but always opens a fresh tmux pane |
| `PiNewPane` | v | Like PiChatSelection but in a fresh pane |
| `PiChatDiff` | n/v | Chat about a `jj://diff` buffer (reuses pane) |
| `PiChatDiffNew` | n/v | Chat about a `jj://diff` buffer (new pane) |

### Which-key bindings (leader A)

- `<leader>Ac` — chat (normal: cursor context, visual: selection, diff buffer: diff context)
- `<leader>An` — chat in new pane
- `<leader>Aa` — apply selection (visual only)

### Two dispatch modes

1. **Chat mode** — opens/reuses a tmux pane running pi, sends the composed prompt as text input. The helper `bin/tmux-pi` labels the pane title as "pi".
2. **Apply mode** — spawns `pi --mode rpc --no-session` as a subprocess, streams the prompt via stdin, monitors RPC events (thinking, tool execution, done), and shows a floating status window with a spinner. Detects file changes on disk to confirm the edit landed.

### Tmux integration (`tmux/.tmux.conf`)

- `bind i` splits a pane running `~/dotfiles/bin/tmux-pi` (33% width, inherits `pane_current_path`)

## JjDiff — Jujutsu Diff Viewer

The `:JjDiff` command (defined in `nvim/lua/config/autocmd.lua`) opens `jj diff` output in a scratch buffer with live-refresh.

### How it works

1. Runs `jj diff [args]` and loads output into a `jj://diff` buffer with `filetype=diff`
2. Sets up a `vim.uv.new_fs_event` watcher on CWD (recursive) — re-runs `jj diff` on any file change (200ms debounce), preserving cursor position
3. On buffer close (`q`), restores the previous buffer or quits if no other buffers exist
4. If launched with no changes (e.g. `nvim '+JjDiff'`), falls back to the alpha dashboard

### Shell helper

`stowdirs/home/base/.config/jj/scripts/jj-vd` — a script that opens `nvim '+JjDiff'` for use as a jj visual diff tool.

### Keybindings

- `<leader>jd` — diff current file (`JjDiff -- <file>`)
- `<leader>jD` — diff all files (`JjDiff`)
- `j` on alpha dashboard — `JjDiff`
- Pi keybindings are overridden in `jj://` buffers to use `PiChatDiff`/`PiChatDiffNew` instead of the normal chat commands

### Conflicts command

The `:Conflicts` command (also in `nvim/lua/config/autocmd.lua`) searches for `<<<<<<<` markers via rg/git-grep and loads results into the quickfix list. Available from the alpha dashboard (`c`) and `<leader>cf`.

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

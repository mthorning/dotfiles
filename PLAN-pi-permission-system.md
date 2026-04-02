# Pi Permission System Installation Plan

## Current Structure

```
stowdirs/home/base/.pi/
  agent/
    skills -> ../../../../../skills  (symlink to root skills/)
    themes/

stowdirs/home/work/.pi/
  agent/
    keybindings.json
```

## Goals

1. Move `.pi` config to repo root for easier editing
2. Install `pi-permission-system` extension
3. Mirror Claude Code permissions from `stowdirs/home/work/.claude/settings.json`

---

## Step 1: Move pi directory to root level

Move the `.pi` directory from `stowdirs/home/base/` to the repository root, then create a symlink in the original location pointing back to it.

### Commands:
```bash
# Move the base .pi directory to root
mv stowdirs/home/base/.pi .pi

# Create symlink in original location
ln -s ../../../.pi stowdirs/home/base/.pi

# Fix the skills symlink (path changed)
rm .pi/agent/skills
ln -s ../../skills .pi/agent/skills
```

### Result:
```
.pi/                              # Now at root level
  agent/
    skills -> ../../skills
    themes/

stowdirs/home/base/.pi -> ../../../.pi  (symlink)
```

---

## Step 2: Handle work-specific pi config

**Current:** `stowdirs/home/work/.pi/agent/keybindings.json` contains work-specific keybindings.

**Decision:** Keep separate. Work-specific files stay in `stowdirs/home/work/.pi/` and are symlinked to `~/.pi/` on work machines (via stow override). The base symlink points to shared config; work profile adds/overrides files.

No action needed for permissions — permissions will be in the shared `.pi/` at root.

---

## Step 3: Install pi-permission-system

### Option A: Install via pi CLI (recommended)
```bash
pi install npm:pi-permission-system
```

### Option B: Manual installation
```bash
cd .pi/agent/extensions
git clone https://github.com/MasuRii/pi-permission-system.git
cd pi-permission-system
npm install
```

---

## Step 4: Create permissions config

**Location:** `.pi/agent/pi-permissions.jsonc`

The formats are **not compatible** between Claude and Pi:
- **Claude:** `permissions.allow/deny/ask` arrays with patterns like `Bash(git status*)`
- **Pi:** Category-based objects with `"allow"/"deny"/"ask"` values

We need to **translate** the Claude rules to pi-permission-system format.

### Translation from Claude settings.json

Create `.pi/agent/pi-permissions.jsonc`:

```jsonc
{
  "$schema": "./extensions/pi-permission-system/schemas/permissions.schema.json",
  
  "defaultPolicy": {
    "tools": "ask",
    "bash": "ask",
    "mcp": "ask",
    "skills": "allow",
    "special": "ask"
  },

  "tools": {
    // ALLOW - read-only operations
    "read": "allow",
    "grep": "allow",
    "find": "allow",
    "ls": "allow",
    
    // ASK - write operations
    "write": "ask",
    "edit": "ask"
  },

  "bash": {
    // ==================== ALLOW - safe read operations ====================
    "find *": "allow",
    "gh pr diff*": "allow",
    "gh pr view*": "allow",
    "gh issue view*": "allow",
    "git show*": "allow",
    "go test*": "allow",
    "grep *": "allow",
    "jj diff*": "allow",
    "jj log*": "allow",
    "ls*": "allow",
    "obsidian read *": "allow",
    "perl*": "allow",
    "pnpm* install *": "allow",
    "pnpm* type*check": "allow",
    "pnpm* lint*": "allow",
    "pnpm* test*": "allow",
    "pnpm* generate-types": "allow",
    "playwright-cli *": "allow",
    "rg *": "allow",
    "tmux capture-pane*": "allow",
    "gh api *": "allow",
    "bash ~/dotfiles/skills/pr-review/scripts/update-pr.sh*": "allow",

    // ==================== DENY - destructive operations ====================
    // GH API write operations
    "gh api *--method DELETE*": "deny",
    "gh api *-X DELETE*": "deny",
    "gh repo delete *": "deny",
    "gh repo archive *": "deny",
    "gh secret set *": "deny",
    "gh secret delete *": "deny",
    "gh workflow run *": "deny",
    "gh workflow enable *": "deny",
    "gh workflow disable *": "deny",
    
    // Git destructive
    "git push *": "deny",
    "git reset *": "deny",
    "git clean *": "deny",
    "git branch -D *": "deny",
    "git tag -d *": "deny",
    "git rebase --skip *": "deny",
    "git filter-branch *": "deny",
    "git reflog delete *": "deny",
    
    // JJ destructive
    "jj git push --force *": "deny",
    "jj abandon *": "deny",
    "jj restore *": "deny",
    "jj bookmark delete *": "deny",
    "jj bookmark forget *": "deny",
    "jj tag forget *": "deny",
    "jj operation abandon *": "deny",
    
    // System commands
    "sudo *": "deny",
    "su *": "deny",
    "chmod +x *": "deny",
    "chown *": "deny",
    "shutdown *": "deny",
    "reboot *": "deny",
    "halt *": "deny",
    "init *": "deny",
    "systemctl *": "deny",
    "service *": "deny",
    "kill -9 *": "deny",
    "killall *": "deny",
    "pkill *": "deny",
    
    // Package publishing
    "npm publish *": "deny",
    "npm unpublish *": "deny",
    "yarn publish *": "deny",
    "pnpm publish *": "deny",
    "pnpm unpublish *": "deny",
    
    // Database destructive
    "*DROP TABLE *": "deny",
    "*DROP DATABASE *": "deny",
    "*DELETE FROM *": "deny",
    "*TRUNCATE *": "deny",
    "psql * DROP *": "deny",
    "mysql * DROP *": "deny",
    "mongosh * drop *": "deny",
    
    // Network attacks
    "nmap *": "deny",
    "nc -e *": "deny",
    "nc -c *": "deny",
    "netcat -e *": "deny",
    "tcpdump *": "deny",
    "wireshark *": "deny",
    
    // Disk/filesystem dangerous
    "dd *": "deny",
    "mkfs *": "deny",
    "fdisk *": "deny",
    "parted *": "deny",
    "mount *": "deny",
    "umount *": "deny",
    
    // Execution
    "eval *": "deny",
    "exec *": "deny",
    "source /dev *": "deny",
    ". /dev *": "deny",
    
    // Docker destructive
    "docker rm *": "deny",
    "docker rmi *": "deny",
    "docker system prune *": "deny",
    "docker-compose down *": "deny",
    "docker-compose rm *": "deny",
    
    // Kubernetes/Cloud
    "kubectl *": "deny",
    "helm *": "deny",
    "aws *": "deny",
    "gcloud *": "deny",
    "az *": "deny",
    "terraform *": "deny",
    
    // Deployment
    "*deploy*production *": "deny",
    "*prod*deploy *": "deny",
    "firebase deploy --only hosting:production *": "deny",
    
    // Secret file access via cat
    "cat .env *": "deny",
    "cat **/secrets/**": "deny",
    "git add .env *": "deny",
    "git add **/secrets/**": "deny",

    // ==================== ASK - moderate risk operations ====================
    // GH API write
    "gh api *--method POST*": "ask",
    "gh api *--method PUT*": "ask",
    "gh api *--method PATCH*": "ask",
    "gh api *-X POST*": "ask",
    "gh api *-X PUT*": "ask",
    "gh api *-X PATCH*": "ask",
    
    // Git write
    "git commit *": "ask",
    "git push": "ask",
    "git checkout *": "ask",
    "git merge *": "ask",
    "git rebase *": "ask",
    "git cherry-pick *": "ask",
    
    // JJ write
    "jj git push *": "ask",
    
    // File operations
    "mv *": "ask",
    "cp *": "ask",
    "rsync *": "ask",
    "rm *": "ask",
    
    // Package management
    "npm install *": "ask",
    "npm uninstall *": "ask",
    "npm ci *": "ask",
    "npm update *": "ask",
    "yarn add *": "ask",
    "yarn remove *": "ask",
    "yarn install *": "ask",
    "pnpm add *": "ask",
    "pnpm remove *": "ask",
    "pnpm install *": "ask",
    "pnpm update *": "ask",
    
    // GitHub CLI write
    "gh pr create *": "ask",
    "gh pr merge *": "ask",
    "gh pr close *": "ask",
    "gh issue create *": "ask",
    "gh issue close *": "ask",
    "gh release create *": "ask",
    
    // Curl write
    "curl *-X POST*": "ask",
    "curl *-X PUT*": "ask",
    "curl *-X PATCH*": "ask",
    "curl *-X DELETE*": "ask",
    "curl *--request POST*": "ask",
    "curl *--request PUT*": "ask",
    "curl *--request PATCH*": "ask",
    "curl *--request DELETE*": "ask",
    "curl *-d *": "ask",
    "curl *--data *": "ask",
    "curl *--data-raw *": "ask",
    "curl *--data-binary *": "ask",
    "curl *-F *": "ask",
    "curl *--form *": "ask",
    "curl *-T *": "ask",
    "curl *--upload-file *": "ask",
    
    // Destructive file ops
    "rmdir *": "ask"
  },

  "special": {
    "doom_loop": "deny",
    "external_directory": "ask"
  }
}
```

### Notes on translation:

1. **Read patterns**: Claude's `Read(*)` → Pi's `"read": "allow"` tool
2. **WebFetch**: Not directly mapped — Pi doesn't have a separate WebFetch tool
3. **Bash patterns**: Claude's `Bash(git status*)` → Pi's `"git status*": "allow"`
4. **Secret files**: Claude's `Read(.env)` deny → No direct equivalent for read tool file patterns. Could use `protected-paths.ts` extension separately.
5. **Hooks**: Claude's PreToolUse hooks (git→jj, no cd) would need a separate extension or skill instruction

### Limitations vs Claude:

| Feature | Claude | Pi Permission System |
|---------|--------|---------------------|
| Read file pattern deny | ✅ `Read(.env)` | ❌ Not supported |
| Tool-level allow/deny | ✅ | ✅ |
| Bash command patterns | ✅ | ✅ |
| PreToolUse hooks | ✅ | ❌ Need separate extension |
| Comments in config | ❌ JSON | ✅ JSONC |

---

## Step 5: Handle missing features

### Read file pattern denies

For denying read access to secret files (`.env`, `secrets/`, etc.), create a separate extension:

`.pi/agent/extensions/protected-paths.ts`:
```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const DENIED_PATTERNS = [
  /^\.env$/,
  /^\.env\..*/,
  /\/\.env$/,
  /\/\.env\..*/,
  /\/secrets\//,
  /secret/i,
  /password/i,
  /credential/i,
  /\.aws\/credentials$/,
  /\.ssh\/id_/,
  /\.gnupg\//,
];

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "read") return;
    
    const path = event.input.path as string;
    const isDenied = DENIED_PATTERNS.some(p => p.test(path));
    
    if (isDenied) {
      return { block: true, reason: `Blocked: ${path} matches protected file pattern` };
    }
  });
}
```

### Git→JJ enforcement and no-cd rule

These are handled by skill instructions in AGENTS.md / CLAUDE.md rather than hooks.
Alternatively, create an extension similar to Claude's PreToolUse hook.

---

## TODO Checklist

- [ ] Move `.pi` to root
- [ ] Create symlink in stowdirs/home/base
- [ ] Fix skills symlink path
- [ ] Install pi-permission-system (`pi install npm:pi-permission-system`)
- [ ] Create `.pi/agent/pi-permissions.jsonc` with translated rules
- [ ] Create `.pi/agent/extensions/protected-paths.ts` for secret file blocking
- [ ] Test permissions work correctly
- [ ] Commit changes

---

## Quick Reference

### Installation commands (after plan complete):
```bash
# Step 1: Move .pi to root
mv stowdirs/home/base/.pi .pi
ln -s ../../../.pi stowdirs/home/base/.pi
rm .pi/agent/skills
ln -s ../../skills .pi/agent/skills

# Step 3: Install extension
pi install npm:pi-permission-system

# Step 4-5: Create config files (manual)
# Edit .pi/agent/pi-permissions.jsonc
# Edit .pi/agent/extensions/protected-paths.ts
```

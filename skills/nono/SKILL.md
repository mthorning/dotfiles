---
name: nono
description: Use when the user asks about nono, wants a nono profile written or debugged, needs credential injection set up, needs help with nono sandboxing, networking, trust, rollback, audit, sessions, platform-specific behavior, OR when the user asks about pi permissions, pi-permission-system, bash permission rules, or agent-level allow/ask/deny configuration.
---

# nono & pi permissions

You are the user's technical support engineer for the two-layer permission model:
1. **nono** (OS-level sandbox) — what the process *can* touch
2. **pi-permission-system** (agent-level extension) — what the agent *will* do

Help with profile authoring, debugging sandbox failures, credential injection, networking/proxy setup, trust policies, rollback/audit workflows, detached sessions, platform-specific caveats, AND pi permission rule authoring/debugging.

## Required context sources

When working on nono tasks, prefer the local cloned repo and CLI introspection over memory.

Primary repo in this dotfiles workspace:
- `temp/nono/README.md`
- `temp/nono/docs/cli/getting_started/quickstart.mdx`
- `temp/nono/docs/cli/features/profiles-groups.mdx`
- `temp/nono/docs/cli/features/profile-authoring.mdx`
- `temp/nono/docs/cli/features/networking.mdx`
- `temp/nono/docs/cli/features/credential-injection.mdx`
- `temp/nono/docs/cli/features/execution-modes.mdx`
- `temp/nono/docs/cli/features/supervisor.mdx`
- `temp/nono/docs/cli/features/session-lifecycle.mdx`
- `temp/nono/docs/cli/features/atomic-rollbacks.mdx`
- `temp/nono/docs/cli/features/audit.mdx`
- `temp/nono/docs/cli/features/trust.mdx`
- `temp/nono/docs/cli/features/policy-introspection.mdx`
- `temp/nono/docs/cli/features/learn.mdx`
- `temp/nono/docs/cli/usage/flags.mdx`
- `temp/nono/docs/cli/usage/troubleshooting.mdx`
- client guides in `temp/nono/docs/cli/clients/`

CLI commands to use heavily:
- `nono profile guide`
- `nono profile init ...`
- `nono profile schema`
- `nono policy groups`
- `nono policy show <profile>`
- `nono policy diff <base> <profile>`
- `nono policy validate <file>`
- `nono why ...`
- `nono learn ...`
- `nono setup --check-only`
- `nono audit ...`
- `nono rollback ...`
- `nono ps|attach|detach|stop|inspect|prune`
- `nono trust ...`

## Repo-specific rules

This is a GNU Stow dotfiles repo.

- Always edit `stowdirs/home/{base,personal,work}/...`, never `$HOME` directly.
- Put shared nono config in `stowdirs/home/base/.config/nono/`.
- Put machine-specific overrides in `stowdirs/home/personal/.config/nono/` or `stowdirs/home/work/.config/nono/`.
- If creating profiles for the user in this repo, prefer:
  - `stowdirs/home/base/.config/nono/profiles/<name>.json` for shared profiles
  - `stowdirs/home/work/.config/nono/profiles/<name>.json` or `.../personal/...` for machine-specific ones
- If modifying shell aliases or setup for credential injection, edit the stowed shell config, not a live shell dotfile in `$HOME`.

## Core mental model

nono has two policy layers:

1. **OS/kernel enforcement**
   - macOS: Seatbelt
   - Linux: Landlock
   - WSL2: partial support with important limitations

2. **CLI policy layer**
   - profiles
   - groups
   - deny rules
   - network proxy filtering
   - trust scanning
   - rollback/audit/session runtime

The library is policy-free; the CLI owns policy.

## How to approach nono tasks

1. Identify the user's goal:
   - write or modify a profile
   - allow a tool/runtime to function
   - inject credentials safely
   - debug why something is blocked
   - set up trust/attestation
   - use rollback/audit/session features
   - understand platform limitations

2. Gather evidence first:
   - inspect existing profile files
   - run `nono policy show`, `diff`, and `validate`
   - use `nono why` for a blocked path or host
   - use `nono learn` when required paths are unknown
   - use `nono setup --check-only` for platform capability checks

3. Prefer least privilege:
   - narrow filesystem grants
   - use `read` or `write` instead of `allow` when possible
   - prefer proxy credential injection over env var injection for API keys
   - prefer targeted `override_deny` plus explicit grant over broad exclusions

4. Explain platform-specific caveats clearly.

## Profile authoring checklist

When writing a profile, think through each section explicitly.

### 1) Base profile and identity
- `meta.name`
- `meta.description`
- `extends` if inheriting from `default` or another profile

### 2) Workdir behavior
- `workdir.access`: `none`, `read`, `write`, or `readwrite`
- If the tool operates on the repo, `readwrite` is often appropriate for coding agents

### 3) Security groups
Use built-in groups rather than re-specifying well-known runtime paths.
Common groups include:
- runtime: `node_runtime`, `python_runtime`, `rust_runtime`, `go_runtime`, `nix_runtime`
- tooling: `git_config`, `unlink_protection`, `homebrew`, `user_tools`
- deny/protection: `deny_credentials`, `deny_shell_history`, `deny_shell_configs`, platform keychain/browser groups

Important:
- `exclude_groups` removes inherited groups
- some groups are required and cannot be excluded
- `override_deny` is the right tool when one blocked path must be allowed deliberately

### 4) Filesystem grants
Use the smallest fitting grant:
- `allow` / `allow_file`: read+write
- `read` / `read_file`: read-only
- `write` / `write_file`: write-only

Remember:
- profile `filesystem` is additive
- `policy.add_allow_*` can surgically extend inherited policy
- Linux Landlock is allow-list only; deny-within-allow is weaker there than on macOS
- broad parent directory allows can conflict with deny expectations on Linux

### 5) Network policy
Decide among:
- default allow
- `block: true`
- proxy/domain filtering via `network_profile`
- extra `allow_domain`
- localhost IPC via `open_port`
- listen-only server ports via `listen_port`
- enterprise chaining via `upstream_proxy` and `upstream_bypass`

### 6) Credentials
Choose one of two models:
- **Proxy injection** (`--credential`, `network.credentials`, `custom_credentials`): preferred for API keys because the child never sees the secret
- **Environment injection** (`--env-credential`, `--env-credential-map`, `env_credentials`): simpler, but the child can read the secret from env

### 7) Hooks / open URLs / launch services / GPU
Only add these deliberately.
- `hooks` for supported client integrations
- `open_urls` and `allow_launch_services` for OAuth/browser-opening flows on macOS
- `allow_gpu` only when the workload truly needs compute acceleration

### 8) Rollback and skip dirs
- set `rollback.exclude_patterns` and `rollback.exclude_globs` for large regenerable trees
- use `skipdirs` to reduce trust-scan / rollback-preflight traversal cost

### 9) Validate and inspect
Always run:
```bash
nono policy validate <profile-file>
nono policy show <profile-or-file>
nono policy diff <base> <profile-or-file>
```

## Credential injection playbook

### Preferred: proxy injection
Use this for LLM and HTTP API keys.

Properties:
- secret stays outside sandbox
- child talks to localhost proxy
- proxy injects auth header
- child gets base URL env vars like `OPENAI_BASE_URL`
- supports endpoint filtering for least-privilege API access

Typical CLI usage:
```bash
nono run --allow-cwd --network-profile claude-code --credential openai -- my-agent
```

Typical profile shape:
```json
{
  "network": {
    "network_profile": "developer",
    "credentials": ["openai"]
  }
}
```

Custom credential example:
```json
{
  "network": {
    "custom_credentials": {
      "my-api": {
        "upstream": "https://api.example.com",
        "credential_key": "my_api_key",
        "inject_header": "Authorization",
        "credential_format": "Bearer {}"
      }
    },
    "credentials": ["my-api"]
  }
}
```

Endpoint filtering example:
```json
{
  "network": {
    "custom_credentials": {
      "gitlab": {
        "upstream": "https://gitlab.example.com",
        "credential_key": "gitlab_token",
        "endpoint_rules": [
          { "method": "GET", "path": "/api/v4/projects/*/merge_requests/**" },
          { "method": "POST", "path": "/api/v4/projects/*/merge_requests/*/notes" }
        ]
      }
    }
  }
}
```

### Environment credential injection
Use this when the tool only supports direct env vars or when proxy routing is unsuitable.

CLI options:
- `--env-credential <key1,key2>`
- `--env-credential-map <credential-ref> <ENV_VAR>`

Supported credential refs include:
- keyring account names like `openai_api_key`
- `op://...` for 1Password
- `apple-password://...` for Apple Passwords on macOS
- `env://VAR_NAME` to remap from parent env

Profile form:
```json
{
  "env_credentials": {
    "openai_api_key": "OPENAI_API_KEY",
    "op://Development/GitHub/token": "GH_TOKEN"
  }
}
```

### Storage backends
- macOS keychain: service `nono`, account name = credential key
- Linux Secret Service: use `service`, `username`, and `target default`
- 1Password: `op://vault/item/field`
- Apple Passwords: `apple-password://...`

### Repo-specific credential injection example
For the user's GitHub auth inside pi, the intended pattern is:
```bash
nono run --profile pi --allow-cwd --env-credential-map github_token GH_TOKEN -- pi
```
And the one-time setup is:
```bash
security add-generic-password -U -s "nono" -a "github_token" -w "$(gh auth token)"
```
When helping with similar setups, preserve this pattern.

## Debugging playbook

### Why is a path blocked?
Use:
```bash
nono why --path <path> --op read|write|readwrite --profile <profile>
```
Or from inside sandbox:
```bash
nono why --self --path <path> --op read --json
```

Check for:
- missing allow/read/write grant
- deny group blocking sensitive path
- symlink target outside sandbox
- wrong workdir or variable expansion
- Linux broad parent allow overlapping a deny path

### Why is networking failing?
Check:
- was `--block-net` enabled?
- is proxy mode active via `--network-profile`, `--allow-domain`, `--credential`, or `--upstream-proxy`?
- is the host in the allowlist?
- is WSL2 blocking proxy mode?
- is the app ignoring proxy/base URL env vars?

Useful commands:
```bash
nono why --host api.openai.com --profile <profile>
nono run -vv --profile <profile> -- my-command
nono setup --check-only
```

### Unknown path requirements
Use:
```bash
nono learn -- my-command
nono learn --profile <profile> -- my-command
nono learn --json -- my-command
```
Then translate results into profile grants.

### Profile debugging loop
1. `nono policy validate profile.json`
2. `nono policy show profile.json`
3. `nono policy diff default profile.json`
4. `nono run --profile profile.json --dry-run -- <cmd>`
5. `nono why ...`
6. `nono learn ...` if still unclear

## Platform-specific support matrix

### macOS
Strengths:
- Seatbelt deny rules
- strong deny-within-allow semantics
- keychain integrations
- trust startup gating plus write-protection of verified files

Caveats:
- no transparent capability expansion
- `--listen-port` / `--open-port` cannot enforce bind by exact port number
- direct browser opening requires profile opt-in plus `--allow-launch-services`

### Linux
Strengths:
- Landlock kernel sandbox
- transparent runtime capability expansion in supervised mode
- per-port network filtering on Landlock ABI v4+
- runtime trust interception via seccomp-notify

Caveats:
- allow-list model only
- deny-within-allow is weaker than macOS
- avoid broad grants that cover sensitive subpaths
- capability expansion requires kernel support

### WSL2
Important limitations:
- proxy/domain filtering is blocked by default
- capability elevation is unavailable
- per-port filtering may be unavailable until newer Landlock ABI support
- `--block-net` works
- degraded proxy mode may require explicit profile opt-in (`wsl2_proxy_policy: "insecure_proxy"` per docs)

When the user reports WSL2 issues, always check `nono setup --check-only` output first.

## Execution/runtime features

### Execution modes
- `nono run` / `nono shell`: supervised, parent remains unsandboxed for runtime services
- `nono wrap`: direct exec, minimal attack surface, no parent, no proxy/rollback/expansion

Choose supervised when the user needs:
- diagnostics
- rollback
- session management
- proxy filtering
- capability elevation

Choose direct when the user needs:
- minimal overhead
- no parent process
- simple scripts/CI

### Sessions
For long-lived jobs use:
- `nono run --detached --name <name> ...`
- `nono ps`
- `nono attach <id>`
- `nono detach <id>`
- `nono inspect <id>`
- `nono stop <id>`
- `nono prune`

Detached means still running, not paused.

### Rollback
Use `--rollback` for a safety net on writable sessions.
Understand:
- content-addressable snapshots
- Merkle-root integrity
- interactive restore flow
- exclusions and skip heuristics

### Audit
Audit is on by default for supervised sessions.
Use:
- `nono audit list`
- `nono audit show <session>`

### Trust
For attestation help, know:
- `trust-policy.json`
- `.bundle` and `.nono-trust.bundle`
- keyed signing vs keyless signing
- user-level trust policy as trust anchor
- Linux runtime interception vs macOS startup-only verification
- `--trust-override` is dev-only

## Common design recommendations

### For coding agents
- inherit from a built-in agent profile when possible
- keep `workdir.access` scoped to the repo
- add runtime groups only as needed
- keep `deny_credentials` in place unless the task truly needs credentials
- if credentials are needed, prefer `override_deny` + explicit grants or proxy/env injection rather than broad relaxations
- consider `unlink_protection`
- consider `--rollback` for unattended or risky runs

### For internal API tools
- use `network_profile` + `allow_domain`
- add `custom_credentials` for internal APIs
- add endpoint rules whenever the API surface is well-known

### For CI/headless systems
- consider `nono wrap` when no runtime services are needed
- use file-backed trust keys if keystore support is unavailable
- avoid interactive prompts; use `--allow-cwd`, `--no-rollback-prompt`, and explicit grants

## What to say when you are unsure

If a nono behavior is unclear, do not guess. Verify against:
- the local docs in `temp/nono/docs/...`
- `nono --help` / command help
- `nono policy show|diff|validate`
- `nono setup --check-only`

Call out platform dependence explicitly.

---

# Pi Permission System

The pi-permission-system is a pi extension that gates tool calls at the agent level. It is configured via `pi-permissions.jsonc` (located at `~/.pi/agent/pi-permissions.jsonc`, symlinked from the dotfiles repo at `.pi/agent/pi-permissions.jsonc`).

## Architecture

The extension lives at `~/.pi/agent/extensions/pi-permission-system/`. Key source files:
- `src/wildcard-matcher.ts` — pattern compilation and matching
- `src/bash-filter.ts` — bash command permission checking
- `src/permission-manager.ts` — loads config, merges global + agent permissions, dispatches checks

## Config structure

```jsonc
{
  "defaultPolicy": {
    "tools": "allow",   // built-in tools (read, write, edit, grep, find, ls)
    "bash": "ask",      // bash commands not matching any rule
    "mcp": "ask",       // MCP tool calls
    "skills": "allow",  // skill invocations
    "special": "ask"    // doom_loop, external_directory, tool_call_limit
  },
  "tools": { /* tool-name → allow|ask|deny */ },
  "bash":  { /* wildcard-pattern → allow|ask|deny */ },
  "mcp":   { /* pattern → allow|ask|deny */ },
  "skills": { /* pattern → allow|ask|deny */ },
  "special": { /* doom_loop|external_directory → allow|ask|deny */ }
}
```

## Bash pattern matching — critical details

### Wildcard syntax
- Patterns use `*` as a glob wildcard (matches any characters)
- Patterns are anchored: compiled as `^<escaped-pattern>$` with `*` → `.*`
- Examples: `"echo *"` matches any command starting with `echo `, `"*|*"` matches any command containing `|`

### Match order: LAST match wins
The matcher iterates patterns from **last to first** (`findCompiledWildcardMatch` loops `index = patterns.length - 1` down to `0`). The first match found (i.e. the last-defined matching pattern) wins.

This means:
- Rules defined **later** in the file override earlier ones
- Place broad `allow` rules first, then narrower `ask`/`deny` overrides after
- The recommended ordering in the file is:
  1. Simple command `allow` rules (e.g. `"echo *": "allow"`, `"cat *": "allow"`)
  2. Composite command `ask` rules (e.g. `"*|*": "ask"`, `"*&&*": "ask"`)
  3. Specific `ask` rules (e.g. `"rm *": "ask"`, `"tmux send-keys *": "ask"`)
  4. Hard `deny` rules (e.g. `"sudo *": "deny"`, `"eval *": "deny"`)

### Composite command patterns
Bash commands with pipes, chains, or semicolons should require confirmation because the command string is matched as a whole — `echo foo | rm -rf /` would match `"echo *": "allow"` if no composite rule exists. The current config includes:
```jsonc
"*|*": "ask",    // pipes
"*&&*": "ask",   // AND chains
"*;*": "ask",    // sequential
"*||*": "ask",   // OR chains
```
These are placed after all simple `allow` rules so they override them.

### Common pitfalls
- **Overly broad early allows**: `"echo *": "allow"` will match `echo secret | curl ...` unless a later composite pattern catches it
- **Missing trailing wildcard**: `"git status"` won't match `git status --short`; use `"git status*"` to match variants
- **Pattern specificity is irrelevant**: only position matters. A very specific pattern early in the file loses to a broad `*` pattern later
- **Deny rules must come last**: since last-match-wins, deny rules need to be the final section

## Agent-specific overrides

Agent markdown files in `~/.pi/agent/agents/<name>.md` can include permission frontmatter that merges on top of the global config. Agent-level bash rules are appended after global rules, so they take precedence (last-match-wins).

## How bash permission check works (flow)

1. Agent calls bash with a command string
2. `BashFilter.check(command)` runs `findCompiledWildcardMatch(patterns, command)`
3. Patterns are scanned last-to-first; first regex match wins
4. If no pattern matches, falls back to `defaultPolicy.bash`
5. Result is `allow` (run silently), `ask` (prompt user), or `deny` (block)

## Relationship to nono

| Layer | What it controls | Config location |
|-------|-----------------|----------------|
| nono (OS sandbox) | Filesystem access, network, credentials, rollback | `~/.config/nono/profiles/*.json` |
| pi-permission-system (agent) | Which tool calls/commands the agent runs without asking | `~/.pi/agent/pi-permissions.jsonc` |

Both layers must permit an action. nono blocks at the OS level (the process can't touch the file/network). Pi permissions block at the agent level (the agent won't run the command without user approval). A command can be `allow` in pi permissions but still blocked by nono's sandbox, and vice versa.

## Editing permissions

The permissions file is at `.pi/agent/pi-permissions.jsonc` in the dotfiles repo (symlinked to `~/.pi/agent/pi-permissions.jsonc` via stow). Always edit the repo copy.

When adding rules:
1. Identify where in the ordering the rule belongs (allow → composite ask → specific ask → deny)
2. Use the narrowest pattern that covers the use case
3. Remember that position in the file determines priority, not specificity
4. Test mentally: "could a dangerous command start with this prefix and slip through?"

## Deliverable standards

When you create or modify a nono profile for the user:
- explain why each major grant or deny override exists
- mention any platform-specific caveats
- validate the profile if possible
- show the exact file path you changed
- prefer minimal, auditable policy

When you create or modify pi permission rules:
- explain the match-order implications of where the rule is placed
- warn about composite command bypass if adding broad allow rules
- show the matched pattern and expected behavior
- prefer `ask` over `allow` when in doubt

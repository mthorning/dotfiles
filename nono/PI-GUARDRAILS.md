# Pi guardrails operating model

## Default alias

- `pi` → safe default profile (`pi-safe`)
  - no injected `GH_TOKEN`
  - intended for local editing, search, tests, notes work, and tmux pane inspection

## Elevated aliases

- `pi-review` → PR review / GitHub inspection profile
- `pi-pr` → PR creation/update profile with GitHub token injection
- `pi-grafana` → Grafana / observability profile
- `pi-playwright` → local-only Playwright profile targeting system Chrome
- `pi-unsafe` → runs `pi` directly without nono

## Convenience wrappers

- `create-pr` → runs `pi-pr "Create a PR using the JJ skill"`
- `review-pr <github-pr-url>` → runs `pi-review` with the PR review skill

## Capability matrix

| Alias/profile | Intended use | Credentials | Network | Notable guardrails |
|---|---|---|---|---|
| `pi` / `pi-safe` | local coding, editing, search, notes, tmux pane inspection | none injected | general outbound for now | no default GitHub token; tmux control stays ask-gated |
| `pi-review` | PR review / GitHub inspection | `GH_TOKEN` via env injection | proxy/domain-filtered GitHub/docs profile | intended for read-oriented GitHub workflows |
| `pi-pr` | PR creation/update and approved SSH push workflows | `GH_TOKEN` via env injection | general outbound | raw SSH enabled via targeted SSH config / known_hosts / agent socket exceptions |
| `pi-grafana` | Grafana workflows | none injected by alias today | developer-profile outbound | kept separate from PR mutation workflows |
| `pi-playwright` | local browser automation | none injected | localhost-only design target | system Chrome focused; still needs end-to-end validation |
| `pi-unsafe` | explicit escape hatch | inherited from your shell env | unrestricted | bypasses nono entirely |

## Pi permission policy

- file tools remain allowed
- bash now defaults to `ask`
- read-only tmux inspection:
  - `tmux list-panes` — allowed
  - `tmux capture-pane` — ask-gated (may expose sensitive content from other sessions)
- tmux control commands stay ask-gated:
  - `tmux send-keys`
  - `tmux respawn-pane`
  - `tmux run-shell`
  - `tmux pipe-pane`
- remote-mutating commands stay ask-gated:
  - `jj git push`
  - `gh pr create`
  - `gh pr edit`
  - `git push`

## Notes sync

`skills/notes/scripts/sync-notes.sh` is now local-only:

- commits notes locally
- updates local `main`
- does not push remotely

## SSH support in `pi-pr`

The minimum SSH-related access proven necessary so far for GitHub SSH auth is:

- `~/.ssh/config`
- `~/.ssh/known_hosts`
- `~/.orbstack/ssh/config`
- `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`

`pi-pr` now uses targeted `policy.override_deny` entries for:

- `~/.ssh/config`
- `~/.ssh/known_hosts`
- `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`

And explicit read grants for those exact paths.

Observed result:

- direct `ssh -T git@github.com` inside `pi-pr` authenticates successfully
- `jj git push --bookmark main --dry-run` runs successfully inside `pi-pr`

Because SSH requires raw outbound access to `github.com:22`, `pi-pr` no longer uses proxy-mode network filtering and instead uses general outbound networking.

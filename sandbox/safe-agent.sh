#!/usr/bin/env bash
# safe-agent.sh — Launch an agent inside the custom macOS sandbox profile.
#
# Usage:
#   safe-agent.sh [--profile /path/to/profile.sb] <command> [args...]
#
# The wrapper:
#   1. Resolves the current directory with `pwd -P` (symlink-free absolute path).
#   2. Emits ancestor file-read-metadata literals for every path component,
#      mirroring emit_path_ancestor_literals() in agent-safehouse's render.sh.
#   3. Appends a file-read*/file-write* (subpath WORKDIR) rule so the agent
#      can freely read/write the directory it was launched from.
#   4. Writes the combined policy to a temp file and execs sandbox-exec.
#
# The base profile already grants ~/dotfiles and ~/grafana RW, so appended
# workdir rules are a no-op when you launch from those trees.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BASE_PROFILE="${SCRIPT_DIR}/agent-sandbox.sb"
AGENT_CMD="claude"

if [[ "${1:-}" == "--profile" ]]; then
    BASE_PROFILE="$2"
    shift 2
fi

if [[ $# -gt 0 ]]; then
    AGENT_CMD="$1"
    shift
fi

if [[ ! -f "$BASE_PROFILE" ]]; then
    printf 'error: sandbox profile not found: %s\n' "$BASE_PROFILE" >&2
    exit 1
fi

WORKDIR="$(pwd -P)"

# Emit (literal "…") lines for every path component above WORKDIR.
# Mirrors emit_path_ancestor_literals() from agent-safehouse/bin/lib/policy/render.sh.
emit_ancestors() {
    local path="$1"
    local current
    current="$(dirname "$path")"
    while [[ "$current" != "/" && "$current" != "." ]]; do
        printf '    (literal "%s")\n' "$current"
        current="$(dirname "$current")"
    done
}

# Verify sandbox-exec is functional. The test profile must explicitly allow
# process-exec and file-read* for the binary, otherwise deny-default blocks it.
if ! sandbox-exec -p '(version 1)(allow default)' /usr/bin/true 2>/dev/null; then
    printf 'error: sandbox-exec is not functional on this system (Darwin %s)\n' "$(uname -r)" >&2
    exit 1
fi

# BSD mktemp requires X's at the end of the template — no suffix allowed.
# sandbox-exec does not require a .sb extension.
TMPFILE="$(mktemp /tmp/agent-sandbox-XXXXXX)"
trap 'rm -f "$TMPFILE"' EXIT

cat "$BASE_PROFILE" > "$TMPFILE"

{
    printf '\n;; ── runtime workdir (appended by safe-agent.sh) ────────────────────────────\n'
    printf ';; workdir: %s\n' "$WORKDIR"
    printf '(allow file-read-metadata\n'
    emit_ancestors "$WORKDIR"
    printf '    (literal "%s"))\n\n' "$WORKDIR"
    printf '(allow file-read* file-write*\n'
    printf '    (subpath "%s"))\n' "$WORKDIR"
} >> "$TMPFILE"

exec sandbox-exec -f "$TMPFILE" "$AGENT_CMD" "$@"

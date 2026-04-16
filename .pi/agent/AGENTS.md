# Global Agent Guidelines

## Avoid `cd` in command chains

Do NOT use `cd /path && command` chains in bash. Instead:

- Use tool-specific flags to specify the working directory:
  - `jj --repository /path/to/repo` (or `jj -R /path/to/repo`)
  - `git -C /path/to/repo`
- Pass absolute paths directly to commands when possible
- If you must change directory, use a subshell: `(cd /path && command)` — but prefer flags first

Chaining with `cd` causes permission prompts and can interfere with jj workspace state.

# Plans
- Make the plan extremely concise, sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

# Code
- Do not add comments to lines unless asked to.
- Don't add trailing spaces or spaces to empty lines.

# Git
- I use Jujutsu (jj-vcs).
- Branch/bookmark names should be prefixed with `mt/` and followed by an issue number if we have one ie. `mt/7446/fix-bugs`.
- Don't add "Generated with Claude" or "Co-Authored-By Claude" to commit messages.

# TypeScript
- Do not use `any`. 
- Prefer using `as` assertions in test files if it avoids the need to add a lot of unnecessary properties, but we cannot use `as any`.

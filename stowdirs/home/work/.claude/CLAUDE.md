# Plans
- Make the plan extremely concise, sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

# Code
- Comments should only be added to the code if they explain _why_ something was added, never how/what. We should not need to add comments very often.
- Do not add trailing spaces, or spaces to the beginning of empty lines.

# Git
- I use Jujutsu (jj-vcs) for managing my Git repos.
- Branch/bookmark names should be prefixed with `mt/` and followed by an issue number if we have one ie. `mt/7446/fix-bugs`.
- Don't add "Generated with Claude" or "Co-Authored-By Claude" to commit messages.

# TypeScript
- Do not use `any`. 
- Prefer using `as` assertions in test files if it avoids the need to add a lot of unnecessary properties, but we cannot use `as any`. `@ts-expect-error` is also acceptable in test but we need to append a comment for the linter not to error.

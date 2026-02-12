# Important
- Do not change the working directory before running commands unless absolutely necessary. I work in Jujutsu workspaces, if we change directory then we write to the incorrect revision.
- Where possible, we should use `pnpm --filter` to run npm scripts in packages instead of using `cd`.

# Plans
- Make the plan extremely concise, sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

# Code
- Comments should only be added to the code if they explain _why_ something was added, never how/what. We should not need to add comments very often.
- Do not add trailing spaces, or spaces to the beginning of empty lines.

# Git
- I use Jujutsu (jj-vcs) for managing my Git repos, use context7 for up-to-date info on its API.
- Branch/bookmark names should be prefixed with `mt/` and followed by an issue number if we have one ie. `mt/7446/fix-bugs`.
- Don't add "Generated with Claude" or "Co-Authored-By Claude" to commit messages.
- I use Jujutsu workspaces, if the cwd is in a directory prefixed with `workspace-` then only files under this directory should be edited; files in the root will be on a different Jujutsu revision and _should not be edited_.

# TypeScript
- Do not use `any`. 
- Prefer using `as` assertions in test files if it avoids the need to add a lot of unnecessary properties, but we cannot use `as any`. `@ts-expect-error` is also acceptable in test but we need to append a comment for the linter not to error.

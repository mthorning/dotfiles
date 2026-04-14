---
name: jj
description: Commit and push changes using Jujutsu (jj-vcs). Use when the user asks to commit changes, push code, save work, or sync changes to remote. Handles the full workflow of committing, setting bookmarks, and pushing.
---

# Jujutsu Commit and Push

Commit and push workflow for Jujutsu version control.

## Workflow

When user requests to commit and push:

1. Review changes with `jj status` and `jj diff`
2. Draft one-sentence commit message describing changes
3. Use AskUserQuestion to confirm commit message
4. Get current bookmark with `bash ~/dotfiles/skills/jj/scripts/get-bookmark.sh`
5. Run `bash ~/dotfiles/skills/jj/scripts/commit-and-push.sh "<message>" "<bookmark>"`
6. Script will commit, set bookmark on @-, and keep the remote push as a separate explicit boundary (prompt by default, or `--no-push` if you only want local prep)

## Scripts

### get-bookmark.sh

Find bookmark on current or parent revisions.

```bash
bash ~/dotfiles/skills/jj/scripts/get-bookmark.sh
```

Returns bookmark name or exits with error if none found.

### commit-and-push.sh

Commit, set bookmark, and optionally push.

```bash
bash ~/dotfiles/skills/jj/scripts/commit-and-push.sh "commit message" "bookmark-name"
```

Optional local-only prep:
```bash
bash ~/dotfiles/skills/jj/scripts/commit-and-push.sh "commit message" "bookmark-name" --no-push
```

Workflow:
1. Commits with provided message
2. Sets bookmark to @- (parent revision)
3. Keeps remote push as an explicit approval boundary
4. Pushes bookmark to remote only if confirmed (or if `--yes` is passed)

## Notes

Per user preferences:
- Bookmark names prefix with `mt/`
- Include issue number if available: `mt/7446/fix-bugs`
- Do not add "Generated with Claude" or "Co-Authored-By Claude" to commits

---
name: pr-review
description: View the PR associated with the current Jujutsu branch/bookmark, including its diff, changes, and any review comments. Use when the user asks to see the PR, check changes, view the diff, or see review feedback for their current branch. Can also accept a GitHub PR URL to view any PR from any repository.
---

# PR Review

View review comments and details for pull requests. Can view either the PR associated with the current Jujutsu bookmark or any PR from a GitHub URL.

## Usage

View PR from current bookmark:
```bash
bash scripts/get_pr_reviews.sh
```

View PR from GitHub URL:
```bash
bash scripts/get_pr_reviews.sh "https://github.com/owner/repo/pull/123"
```

### Local Bookmark Mode (no arguments)
The script will:
1. Find the bookmark on current revision, or traverse parent revisions if needed
2. Search for a PR matching that bookmark/branch name
3. Display the PR details including review comments using `gh pr view`

### GitHub URL Mode (with URL argument)
The script will:
1. Parse the GitHub PR URL to extract the repository and PR number
2. Check if a local copy exists in `~/grafana/` directory
3. Use `gh pr view` with the appropriate repository context

## How It Works

The script uses:
- `jj log` to find bookmarks on current (@), parent (@-), or grandparent (@--) revisions
- `gh pr list` to find the PR number for the branch
- `gh pr view` to display full PR details with reviews and comments

## Manual Alternative

If needed, you can manually find the bookmark and query GitHub:

```bash
# Find bookmark on current or parent revisions
jj log -r '@|@-|@--' -T 'bookmarks'

# List recent PRs to find the one for your branch
gh pr list --state all --limit 10

# View specific PR (local repo)
gh pr view <pr-number>

# View specific PR from another repo
gh pr view <pr-number> --repo owner/repo
```

## Troubleshooting

- **No bookmark found** (local mode): The current and parent revisions don't have bookmarks. Use `jj bookmark list` and `jj bookmark create` to add one.
- **No PR found** (local mode): No PR exists for the branch name. Check if the PR uses a different branch name or hasn't been created yet.
- **Invalid URL format** (URL mode): Ensure the URL follows the format `https://github.com/owner/repo/pull/123`.
- **Repository not found** (URL mode): The repository may not exist in `~/grafana/`. The script will use `--repo` flag to query GitHub directly.

---
name: pr-review
description: Create, view, or update PRs associated with the current Jujutsu branch/bookmark. Use when the user asks to create a PR, see the PR, check changes, view the diff, see review feedback, or update the PR description. Can also accept a GitHub PR URL to work with any PR from any repository.
---

# PR Creation, Review & Update

Create new PRs, view PR details, review comments, and update PR descriptions. Works with either the current Jujutsu bookmark or any GitHub PR URL.

## Usage

### Viewing a PR

View PR from current bookmark:
```bash
bash scripts/get_pr_reviews.sh
```

View PR from GitHub URL:
```bash
bash scripts/get_pr_reviews.sh "https://github.com/owner/repo/pull/123"
```

**Local Bookmark Mode (no arguments)**
The script will:
1. Find the bookmark on current revision, or traverse parent revisions if needed
2. Search for a PR matching that bookmark/branch name
3. Display the PR details including review comments using `gh pr view`

**GitHub URL Mode (with URL argument)**
The script will:
1. Parse the GitHub PR URL to extract the repository and PR number
2. Check if a local copy exists in `~/grafana/` directory
3. Use `gh pr view` with the appropriate repository context

### Updating a PR

Update PR from current bookmark:
```bash
bash scripts/update-pr.sh
```

Update specific PR by URL:
```bash
bash scripts/update-pr.sh "https://github.com/owner/repo/pull/123"
```

Create new PR:
```bash
bash scripts/update-pr.sh --create
```

**Workflow for updating PR descriptions:**
1. Find the PR (from current bookmark or provided URL)
2. Show current PR description if exists
3. Gather context from commits using `jj log` and `jj diff`
4. Use AskUserQuestion to gather:
   - **Why**: The reason for the change
   - **Issue reference**: Related issue number (optional)
   - **What**: What was changed
5. If issue number provided, fetch issue details using `gh issue view <issue-number>` for additional context
6. Format description with Why/What sections:
   ## What
   [Description of what was changed]
   ```markdown
   ## Why
   [Explanation of the reason for the change]

   Relates to #[issue-number]
   ```
7. Update using `bash scripts/update-pr.sh` (reads from stdin)

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

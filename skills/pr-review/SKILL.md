---
name: pr-review
description: Create, view, or update PRs associated with the current Jujutsu branch/bookmark. Use when the user asks to create a PR, see the PR, check changes, view the diff, see review feedback, or update the PR description. Can also accept a GitHub PR URL to work with any PR from any repository.
---

# PR Creation, Review & Update

Create new PRs, view PR details, review comments, and update PR descriptions. Works with either the current Jujutsu bookmark or any GitHub PR URL.

## Important Rules

- **All PRs must be created in draft mode.** Always pass `--draft` to `gh pr create`, with no exceptions — even if the skill scripts cannot be found and you fall back to calling `gh` directly.
- Scripts must be run using their absolute path: `~/dotfiles/skills/pr-review/scripts/<script-name>`

## Usage

### Viewing a PR

View PR from current bookmark:
```bash
bash ~/dotfiles/skills/pr-review/scripts/get_pr_reviews.sh
```

View PR from GitHub URL:
```bash
bash ~/dotfiles/skills/pr-review/scripts/get_pr_reviews.sh "https://github.com/owner/repo/pull/123"
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
bash ~/dotfiles/skills/pr-review/scripts/update-pr.sh
```

Update specific PR by URL:
```bash
bash ~/dotfiles/skills/pr-review/scripts/update-pr.sh "https://github.com/owner/repo/pull/123"
```

Create new PR (always in draft mode):
```bash
echo "<body>" | bash ~/dotfiles/skills/pr-review/scripts/update-pr.sh --create --title "type(scope): short description"
```

The script automatically pushes the bookmark to remote before calling `gh pr create`.

**Workflow for creating or updating PR descriptions:**
1. Find the PR (from current bookmark or provided URL)
2. Show current PR description if exists
3. Gather context from commits using `jj log` and `jj diff`
4. Use AskUserQuestion to gather:
   - **Why**: The reason for the change
   - **Issue reference**: Related issue number (optional)
   - **Type**: Conventional commit type (feat, fix, docs, refactor, test, chore, perf, ci, build, style, revert)
   - **Scope**: Optional scope (e.g. component or area affected)
5. If issue number provided, fetch issue details using `gh issue view <issue-number>` for additional context
6. Format the PR title using conventional commits: `type(scope): short description` (omit scope if not applicable)
7. Check the current revision description: `jj log -r @ -T 'description'`.
   - If empty: run `jj describe -m "type(scope): short description"`
   - If not empty: compare it to the title you would set. If they are broadly consistent (same intent, minor wording differences), keep the existing description as-is. If they differ meaningfully, use AskUserQuestion to show both the existing description and the proposed one, and ask the user whether to update it.
8. Format PR body using the template below. Always include **What?**, **Why?**, and **How to test**. Include optional sections only when they add value — omit them entirely rather than leaving them empty.
   ```markdown
   ## What?
   [What is being changed, from the user's perspective — behavior, not implementation. 1-2 paragraphs or bullets.]

   ## Why?
   [Reason for the change. Link issues or feature requests where applicable.]

   Relates to #[issue-number]

   ## How to test
   [Brief summary of test coverage. Bullet any manual steps to exercise the functionality.]

   ## Key decisions
   *Optional — omit for simple PRs.*
   [Choices where there were meaningful alternatives: "we chose A over B because C." Only forks in the road a reviewer might question.]

   ## Notes to reviewers
   *Optional — omit if nothing stands out.*
   [Things reviewers should scrutinize: deployment ordering, large-table migrations, feature flags, backward compatibility, prod-vs-dev differences.]

   ## Background info
   *Optional — omit for simple or self-contained changes.*
   [Context about the code and system this change interacts with, for reviewers unfamiliar with the area. 1-2 paragraphs or bullets.]
   ```

   **Intellectual honesty — don't overstate what you know:**
   - Flag operational concerns (migrations, performance, scale) — don't reassure.
   - Don't claim a migration is safe or fast; state what it does and flag it for the reviewer.
   - If you haven't profiled performance, don't say "this should be fast" — state what changed.

   **Tone — blameless language:**
   - Never judge prior code: no "over-engineered", "hacky", "bad", "messy", "broken".
   - Describe what changed and why neutrally: "Simplify X to align with Y", "Consolidate X into Y".
   - Focus on outcomes, not corrections of mistakes.

9. For **create**: pipe body to script with `--title` flag:
   ```bash
   echo "<body>" | bash ~/dotfiles/skills/pr-review/scripts/update-pr.sh --create --title "<title>"
   ```
   For **update**: pipe body to script:
   ```bash
   echo "<body>" | bash ~/dotfiles/skills/pr-review/scripts/update-pr.sh
   ```

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

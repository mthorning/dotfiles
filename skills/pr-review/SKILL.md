---
name: pr-review
description: Perform an independent code review of a GitHub PR using `gh`. Use when the user provides a PR number or URL and asks for a review of the code changes, risks, or missing tests.
---

# GitHub PR Code Review

Use this skill when the user wants a fresh review of the code changes in a GitHub pull request.

This skill is for **reviewing the code itself**. It is not for creating PRs or editing PR descriptions.

## Inputs

Prefer one of these inputs:
- PR number in the current repository, e.g. `9467`
- Full GitHub PR URL, e.g. `https://github.com/owner/repo/pull/9467`

If the user only provides a PR number, assume the current repository unless they specify another repo.

## Review Workflow

1. Identify the PR context.
   - If given a PR URL, extract `owner/repo` and the PR number.
   - If given only a PR number, use the current repo.
2. Fetch PR metadata with `gh pr view`.
   - Title, body, author, base branch, head branch, changed files, commit count.
3. Fetch the code changes with `gh pr diff`.
   - If the PR is large, first inspect the changed file list and focus on the highest-risk files.
   - For very large diffs, review file-by-file rather than dumping the entire patch at once.
4. **Do not inspect local repository files to understand the PR.** Assume the local checkout may be on a different branch or otherwise not match the PR.
   - Base the review on GitHub data for that PR, not the local working tree.
   - If you need more context than `gh pr diff` provides, fetch it from GitHub for the PR's repo/branches rather than reading local files.
5. Produce a code review focused on correctness, regressions, edge cases, security, performance, and test coverage.
6. Do **not** modify the PR, post GitHub review comments, or approve/request changes unless the user explicitly asks.

## Commands

Current repo by PR number:
```bash
gh pr view 9467
gh pr diff 9467
```

Specific repo by URL or explicit repo:
```bash
gh pr view 9467 --repo owner/repo
gh pr diff 9467 --repo owner/repo
```

Useful structured metadata:
```bash
gh pr view 9467 --json title,body,author,baseRefName,headRefName,files,commits
```

## Review Output

Lead with findings, not a summary.

For each finding, include:
- severity when clear (`high`, `medium`, `low`)
- the affected file/function/behavior
- why it is a problem
- a concrete suggestion or follow-up question

Then include:
- open questions / assumptions
- testing gaps
- brief overall assessment

If you do not find any substantive issues, say so clearly and mention what you checked.

## Review Heuristics

Prioritize:
- behavior changes on hot paths
- error handling and nil/null cases
- backward compatibility
- auth/authz and data exposure
- migrations, deletions, and irreversible changes
- concurrency / async ordering issues
- missing validation
- missing or weak tests for changed behavior

Be precise and evidence-based:
- cite specific files, functions, or diff hunks
- avoid speculative claims unless you label them as risks or questions
- distinguish definite bugs from design concerns

## Notes

- Treat the local checkout as untrusted for PR review context unless the user explicitly tells you it matches the PR branch.
- Do not read local files as evidence for the review; use `gh pr view`, `gh pr diff`, and GitHub-fetched file contents/metadata instead.
- If the PR number alone is ambiguous because you are not in the target repository, ask for the repo or PR URL.
- If `gh pr diff` output is too large, narrow the review to the most important files first and tell the user that the review is partial if needed.

#!/bin/bash
# Script to update or create PR description with structured Why/What format
# Usage:
#   ./update-pr.sh                                              # Use current bookmark
#   ./update-pr.sh "https://github.com/owner/repo/pull/123"    # Use specific PR URL
#   ./update-pr.sh --create --title "feat: my change"          # Create new PR (body via stdin)
#   ./update-pr.sh --create --title "feat: my change" --base develop

set -e

# Parse GitHub PR URL to extract repo and PR number
parse_github_url() {
    local url="$1"

    if [[ "$url" =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
        local owner="${BASH_REMATCH[1]}"
        local repo="${BASH_REMATCH[2]}"
        local pr_num="${BASH_REMATCH[3]}"
        echo "$owner/$repo $pr_num"
        return 0
    fi

    return 1
}

# Find the bookmark associated with current or parent revisions
find_bookmark() {
    local bookmark=$(jj log -r @ -T 'bookmarks' --no-graph 2>/dev/null | grep -v '^$' | grep -v '^~$' || true)

    if [ -n "$bookmark" ]; then
        echo "$bookmark"
        return 0
    fi

    bookmark=$(jj log -r '@-' -T 'bookmarks' --no-graph 2>/dev/null | grep -v '^$' | grep -v '^~$' || true)

    if [ -n "$bookmark" ]; then
        echo "$bookmark"
        return 0
    fi

    bookmark=$(jj log -r '@--' -T 'bookmarks' --no-graph 2>/dev/null | grep -v '^$' | grep -v '^~$' || true)

    if [ -n "$bookmark" ]; then
        echo "$bookmark"
        return 0
    fi

    return 1
}

# Determine the repository default branch, prompting if auto-detection fails
get_default_branch() {
    local repo="$1"
    local default_branch=""

    if [ -n "$repo" ]; then
        default_branch=$(gh repo view "$repo" --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null || true)
    else
        default_branch=$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null || true)
    fi

    if [ -n "$default_branch" ]; then
        echo "$default_branch"
        return 0
    fi

    echo "Could not determine the repository default branch automatically." >&2
    read -p "Enter the base branch for this PR: " default_branch >&2

    if [ -z "$default_branch" ]; then
        echo "Error: Base branch is required to create a PR" >&2
        return 1
    fi

    echo "$default_branch"
}

# Main execution
create_mode=false
pr_url=""
repo=""
pr_number=""
title=""
base_branch=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --create) create_mode=true; shift ;;
        --title) title="$2"; shift 2 ;;
        --base) base_branch="$2"; shift 2 ;;
        *) pr_url="$1"; shift ;;
    esac
done

# Determine PR context
if [ -n "$pr_url" ]; then
    # GitHub URL provided
    parsed=$(parse_github_url "$pr_url")

    if [ -z "$parsed" ]; then
        echo "Error: Invalid GitHub PR URL format" >&2
        echo "Expected format: https://github.com/owner/repo/pull/123" >&2
        exit 1
    fi

    repo=$(echo "$parsed" | cut -d' ' -f1)
    pr_number=$(echo "$parsed" | cut -d' ' -f2)

    echo "Using PR #$pr_number from $repo" >&2
else
    # Use local bookmark
    bookmark=$(find_bookmark)

    if [ -z "$bookmark" ]; then
        echo "Error: Could not find a bookmark on current or parent revisions" >&2
        echo "Run 'jj bookmark list' to see available bookmarks" >&2
        exit 1
    fi

    echo "Found bookmark: $bookmark" >&2

    # Try to find existing PR
    pr_number=$(gh pr list --state all --json number,headRefName --jq ".[] | select(.headRefName == \"$bookmark\") | .number" | head -1 || true)

    if [ -z "$pr_number" ]; then
        if [ "$create_mode" = false ]; then
            echo "" >&2
            echo "No PR found for branch '$bookmark'" >&2
            read -p "Create new PR? [y/N] " -n 1 -r >&2
            echo "" >&2
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Cancelled" >&2
                exit 1
            fi
            create_mode=true
        fi
    fi
fi

# Show current PR description if exists
if [ -n "$pr_number" ]; then
    echo "" >&2
    echo "Current PR description:" >&2
    echo "======================" >&2
    if [ -n "$repo" ]; then
        gh pr view "$pr_number" --repo "$repo" --json body --jq .body >&2 || echo "(empty)" >&2
    else
        gh pr view "$pr_number" --json body --jq .body >&2 || echo "(empty)" >&2
    fi
    echo "" >&2
    echo "======================" >&2
    echo "" >&2
fi

# Read new description from stdin
description=$(cat)

if [ -z "$description" ]; then
    echo "Error: No description provided via stdin" >&2
    exit 1
fi

# Create or update PR
if [ "$create_mode" = true ]; then
    if [ -z "$title" ]; then
        echo "Error: --title is required when creating a PR" >&2
        exit 1
    fi

    if [ -z "$base_branch" ]; then
        base_branch=$(get_default_branch "$repo")
    fi

    echo "Pushing bookmark '$bookmark' to remote..." >&2
    jj git push --bookmark "$bookmark" >&2

    echo "Creating new PR against '$base_branch'..." >&2
    gh pr create --title "$title" --body "$description" --draft --head "$bookmark" --base "$base_branch"
    echo "" >&2
    echo "PR created successfully!" >&2
else
    echo "Updating PR description..." >&2
    if [ -n "$repo" ]; then
        echo "$description" | gh pr edit "$pr_number" --repo "$repo" --body-file -
    else
        echo "$description" | gh pr edit "$pr_number" --body-file -
    fi
    echo "" >&2
    echo "PR description updated successfully!" >&2
fi

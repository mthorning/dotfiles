#!/bin/bash
# Script to find PR for current or parent jj bookmark and display review comments
# Can also accept a GitHub PR URL to view any PR

set -e

# Parse GitHub PR URL to extract repo and PR number
parse_github_url() {
    local url="$1"

    # Support formats:
    # https://github.com/owner/repo/pull/123
    # github.com/owner/repo/pull/123
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
    # Try current revision first
    local bookmark=$(jj log -r @ -T 'bookmarks' --no-graph 2>/dev/null | grep -v '^$' | grep -v '^~$')

    if [ -n "$bookmark" ]; then
        echo "$bookmark"
        return 0
    fi

    # Try parent revisions
    bookmark=$(jj log -r '@-' -T 'bookmarks' --no-graph 2>/dev/null | grep -v '^$' | grep -v '^~$')

    if [ -n "$bookmark" ]; then
        echo "$bookmark"
        return 0
    fi

    # Try grandparent
    bookmark=$(jj log -r '@--' -T 'bookmarks' --no-graph 2>/dev/null | grep -v '^$' | grep -v '^~$')

    if [ -n "$bookmark" ]; then
        echo "$bookmark"
        return 0
    fi

    return 1
}

# Main execution
if [ -n "$1" ]; then
    # GitHub URL provided
    parsed=$(parse_github_url "$1")

    if [ -z "$parsed" ]; then
        echo "Error: Invalid GitHub PR URL format" >&2
        echo "Expected format: https://github.com/owner/repo/pull/123" >&2
        exit 1
    fi

    repo=$(echo "$parsed" | cut -d' ' -f1)
    pr_number=$(echo "$parsed" | cut -d' ' -f2)

    echo "Viewing PR #$pr_number from $repo" >&2
    echo "==================" >&2
    echo "" >&2

    # Try to cd to local repo if it's in ~/grafana
    repo_name=$(echo "$repo" | cut -d'/' -f2)
    local_path="$HOME/grafana/$repo_name"

    if [ -d "$local_path" ]; then
        cd "$local_path"
        gh pr view "$pr_number"
    else
        gh pr view "$pr_number" --repo "$repo"
    fi
else
    # No URL provided, use local bookmark
    bookmark=$(find_bookmark)

    if [ -z "$bookmark" ]; then
        echo "Error: Could not find a bookmark on current or parent revisions" >&2
        echo "Run 'jj bookmark list' to see available bookmarks" >&2
        exit 1
    fi

    echo "Found bookmark: $bookmark" >&2
    echo "" >&2

    # Try to find PR by branch name
    pr_number=$(gh pr list --state all --json number,headRefName --jq ".[] | select(.headRefName == \"$bookmark\") | .number" | head -1)

    if [ -z "$pr_number" ]; then
        echo "Error: No PR found for branch '$bookmark'" >&2
        exit 1
    fi

    echo "Found PR #$pr_number" >&2
    echo "==================" >&2
    echo "" >&2

    # Display PR details with review comments
    gh pr view "$pr_number"
fi

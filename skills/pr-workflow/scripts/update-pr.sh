#!/bin/bash
# Script to update or create PR description with structured Why/What format
# Usage:
#   ./update-pr.sh                                              # Update PR for current bookmark
#   ./update-pr.sh "https://github.com/owner/repo/pull/123"    # Update specific PR by URL
#   ./update-pr.sh --create --title "feat: my change"          # Create new PR (body via stdin)
#   ./update-pr.sh --create --title "feat: my change" --base develop
#   ./update-pr.sh --create --title "feat: my change" --no-push

set -euo pipefail

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

find_bookmark() {
    local bookmark

    bookmark=$(jj log -r @ -T 'bookmarks' --no-graph 2>/dev/null | grep -v '^$' | grep -v '^~$' || true)
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

    echo "Error: Could not determine the repository default branch automatically." >&2
    echo "Pass --base <branch> explicitly when creating the PR." >&2
    return 1
}

create_mode=false
pr_url=""
repo=""
pr_number=""
title=""
base_branch=""
bookmark=""
push_mode="push"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --create) create_mode=true; shift ;;
        --title)
            [ $# -ge 2 ] || { echo "Error: --title requires a value" >&2; exit 1; }
            title="$2"
            shift 2
            ;;
        --base)
            [ $# -ge 2 ] || { echo "Error: --base requires a value" >&2; exit 1; }
            base_branch="$2"
            shift 2
            ;;
        --no-push)
            push_mode="skip"
            shift
            ;;
        --push)
            push_mode="push"
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            exit 1
            ;;
        *)
            if [ -n "$pr_url" ]; then
                echo "Error: Unexpected extra argument: $1" >&2
                exit 1
            fi
            pr_url="$1"
            shift
            ;;
    esac
done

if [ -n "$pr_url" ]; then
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
    bookmark=$(find_bookmark)

    if [ -z "$bookmark" ]; then
        echo "Error: Could not find a bookmark on current or parent revisions" >&2
        echo "Run 'jj bookmark list' to see available bookmarks" >&2
        exit 1
    fi

    echo "Found bookmark: $bookmark" >&2

    pr_number=$(gh pr list --state all --json number,headRefName --jq ".[] | select(.headRefName == \"$bookmark\") | .number" | head -1 || true)

    if [ -z "$pr_number" ] && [ "$create_mode" = false ]; then
        echo "Error: No PR found for branch '$bookmark'." >&2
        echo "Re-run with --create to create a new draft PR." >&2
        exit 1
    fi
fi

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

description=$(cat)

if [ -z "$description" ]; then
    echo "Error: No description provided via stdin" >&2
    exit 1
fi

if [ "$create_mode" = true ]; then
    if [ -z "$bookmark" ]; then
        echo "Error: PR creation requires a local bookmark context." >&2
        exit 1
    fi

    if [ -z "$title" ]; then
        echo "Error: --title is required when creating a PR" >&2
        exit 1
    fi

    if [ -z "$base_branch" ]; then
        base_branch=$(get_default_branch "$repo")
    fi

    if [ "$push_mode" = "push" ]; then
        echo "Pushing bookmark '$bookmark' to remote..." >&2
        jj git push --bookmark "$bookmark" >&2
    else
        echo "Skipping push because --no-push was specified." >&2
        echo "Ensure branch '$bookmark' already exists on the remote before creating the PR." >&2
    fi

    echo "Creating new draft PR against '$base_branch'..." >&2
    gh pr create --title "$title" --body "$description" --draft --head "$bookmark" --base "$base_branch"
    echo "" >&2
    echo "Draft PR created successfully!" >&2
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

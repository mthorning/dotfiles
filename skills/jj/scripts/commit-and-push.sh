#!/bin/bash
# Script to commit, set bookmark, and optionally push using Jujutsu
# Usage: ./commit-and-push.sh "commit message" "bookmark-name" [--no-push] [--yes]

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Error: Please provide a commit message" >&2
  echo "Usage: $0 \"commit message\" \"bookmark-name\" [--no-push] [--yes]" >&2
  exit 1
fi

if [ -z "${2:-}" ]; then
  echo "Error: Please provide a bookmark name" >&2
  echo "Usage: $0 \"commit message\" \"bookmark-name\" [--no-push] [--yes]" >&2
  exit 1
fi

commit_message="$1"
bookmark="$2"
shift 2

push_mode="prompt"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-push) push_mode="skip"; shift ;;
    --yes) push_mode="push"; shift ;;
    *)
      echo "Error: Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

jj commit -m "$commit_message"
jj bookmark set "$bookmark" -r @-

echo ""
echo "Bookmark set to: $bookmark"

case "$push_mode" in
  skip)
    echo "Skipping remote push. Run this when ready:" >&2
    echo "jj git push --bookmark \"$bookmark\"" >&2
    exit 0
    ;;
  push)
    ;;
  prompt)
    read -p "Push to remote? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Push cancelled"
      exit 0
    fi
    ;;
esac

jj git push --bookmark "$bookmark"

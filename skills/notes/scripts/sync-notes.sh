#!/bin/bash

# Script to commit notes changes locally using Jujutsu.
# Usage: ./sync-notes.sh "commit description"

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Error: Please provide a commit description" >&2
  echo "Usage: $0 \"commit description\"" >&2
  exit 1
fi

cd /Users/mthorning/Documents/Notes || exit 1

jj commit -m "$1"
jj bookmark set main -r @-

echo "Committed notes locally and updated the local main bookmark." >&2
echo "Remote push intentionally skipped; use an elevated workflow if you want to sync notes remotely." >&2

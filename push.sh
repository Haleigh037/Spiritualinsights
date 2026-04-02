#!/bin/bash
# push.sh - Pushes all staged changes to the current branch with a commit message

if [ -z "$1" ]; then
  echo "Usage: $0 <commit-message>"
  exit 1
fi

git add .
git commit -m "$1"
git push

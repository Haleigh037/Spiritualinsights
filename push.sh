#!/usr/bin/env bash
set -euo pipefail

branch="${1:-$(git rev-parse --abbrev-ref HEAD)}"

# Ensure we're in a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

echo "Repository: $(git config --get remote.origin.url || echo '(no remote configured)')"
echo "Branch to push: $branch"

# Warn about uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Warning: there are uncommitted changes. Please commit them before pushing, or run this script with a message: ./push.sh \"Commit message\"" >&2
  echo
fi

# Try pushing with git; provide guidance on failure
if git push origin "$branch"; then
  echo "Push succeeded. If GitHub Pages is configured, deploy will start automatically.";
  exit 0
else
  echo "\nPush failed. Common causes: authentication or remote configuration." >&2
  echo "Helpful steps to resolve:" >&2
  echo "  1) Authenticate with GitHub CLI (recommended):" >&2
  echo "       gh auth login" >&2
  echo "  2) Use a Personal Access Token (one-time):" >&2
  echo "       git push https://<PAT>@github.com/Haleigh037/Spiritualinsights.git $branch" >&2
  echo "  3) If you prefer SSH, configure SSH keys and set origin to SSH URL:" >&2
  echo "       git remote set-url origin git@github.com:Haleigh037/Spiritualinsights.git" >&2
  echo "       git push origin $branch" >&2
  exit 1
fi

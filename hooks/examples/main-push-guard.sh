#!/usr/bin/env bash
# Main Push Guard — Blocks direct pushes to protected branches.
#
# Protected branches: main, master, production
#
# Why: In AI-assisted development, the AI might try to push directly
# to main for convenience. This guard enforces the branch workflow:
#   feature-branch → develop → PR → main
#
# Usage: Called by the pre-bash dispatcher. Reads command from stdin.
# Exit 0 = allow, Exit 2 = block.

COMMAND=$(cat)

if ! echo "$COMMAND" | grep -qE 'git\s+push'; then
  exit 0
fi

PROTECTED_BRANCHES="main master production"

for branch in $PROTECTED_BRANCHES; do
  if echo "$COMMAND" | grep -qE "git\s+push\s+\S+\s+($branch\b|HEAD:$branch\b|.*:$branch\b)"; then
    echo "Push to '$branch' blocked. Use a PR workflow instead:"
    echo "  1. Push to your feature branch"
    echo "  2. Create a PR: gh pr create --base $branch"
    echo "  3. Merge after review"
    exit 2
  fi

  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
  if [[ "$CURRENT_BRANCH" == "$branch" ]]; then
    if echo "$COMMAND" | grep -qE 'git\s+push\s*$|git\s+push\s+origin\s*$'; then
      echo "Push from '$branch' blocked. Switch to a feature branch first:"
      echo "  git checkout -b feat/your-feature"
      exit 2
    fi
  fi
done

exit 0

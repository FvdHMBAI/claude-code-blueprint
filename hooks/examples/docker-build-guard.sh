#!/usr/bin/env bash
# Docker Build Guard — Prevents building from a dirty git working tree.
#
# Why: Building Docker images from uncommitted code means the image
# doesn't match any git commit. If something breaks in production,
# you can't reproduce the build.
#
# Usage: Called by the pre-bash dispatcher. Reads command from stdin.
# Exit 0 = allow, Exit 2 = block.

COMMAND=$(cat)

if ! echo "$COMMAND" | grep -qE '(docker\s+build|docker\s+compose\s+build)'; then
  exit 0
fi

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  exit 0
fi

DIRTY=$(git status --porcelain 2>/dev/null | head -1)
if [[ -n "$DIRTY" ]]; then
  echo "Docker build blocked: working tree is dirty. Commit or stash changes first."
  echo "  Dirty files: $(git status --porcelain | wc -l)"
  echo "  Tip: 'git stash' to save changes temporarily"
  exit 2
fi

exit 0

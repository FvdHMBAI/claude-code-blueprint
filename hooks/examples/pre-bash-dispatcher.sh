#!/usr/bin/env bash
# Pre-Bash Dispatcher — Single entry point that fans out to guard scripts.
#
# Configure as a Claude Code hook (settings.json):
#   "hooks": { "PreToolUse": [{ "matcher": "Bash", "command": "bash hooks/pre-bash-dispatcher.sh" }] }
#
# How it works:
#   1. Reads the command from stdin (JSON with "input.command")
#   2. Scans the guards/ directory for executable .sh files
#   3. Each guard checks the command and exits 2 to BLOCK, 0 to ALLOW
#   4. If ANY guard blocks, the command is rejected with its error message
#
# Why a dispatcher?
#   - Adding a new guard = dropping a .sh file in the directory
#   - No need to edit settings.json for each new rule
#   - Guards are independent — easy to test, enable, disable

set -euo pipefail

GUARD_DIR="$(dirname "$0")/../guards"
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.input.command // empty' 2>/dev/null)

if [[ -z "$COMMAND" ]]; then
  exit 0
fi

if [[ ! -d "$GUARD_DIR" ]]; then
  exit 0
fi

for guard in "$GUARD_DIR"/*.sh; do
  [[ -x "$guard" ]] || continue

  RESULT=$(echo "$COMMAND" | bash "$guard" 2>&1) || EXIT_CODE=$?
  EXIT_CODE=${EXIT_CODE:-0}

  if [[ $EXIT_CODE -eq 2 ]]; then
    echo "BLOCKED by $(basename "$guard"): $RESULT" >&2
    exit 2
  fi
done

exit 0

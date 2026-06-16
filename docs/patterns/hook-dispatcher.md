# Pattern: Hook Dispatcher

## Problem

Claude Code hooks are configured in `settings.json`. Each hook is a separate entry. With 20+ guards, the config becomes unmanageable. Adding a new guard requires editing settings.json, which is error-prone and hard to review in PRs.

## Solution

Use a single dispatcher script as the hook entry point. The dispatcher reads individual guard files from a directory and runs each one. Adding a new guard = adding a `.sh` file. No config changes.

## Architecture

```
settings.json
  └── PreToolUse: Bash → pre-bash-dispatcher.sh
                              │
                              ├── guards/docker-build-guard.sh
                              ├── guards/main-push-guard.sh
                              ├── guards/secret-output-guard.sh
                              ├── guards/env-file-guard.sh
                              └── guards/... (add more here)
```

## Setup

### 1. Configure the dispatcher in settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/pre-bash-dispatcher.sh"
          }
        ]
      }
    ]
  }
}
```

### 2. Create the dispatcher

See `hooks/examples/pre-bash-dispatcher.sh` for the full implementation.

The key logic:
1. Read the command from stdin (JSON format)
2. Loop through every `.sh` file in the `guards/` directory
3. Run each guard with the command as `$1`
4. If any guard exits non-zero, output a block response

### 3. Write guard files

Each guard is a standalone script that:
- Receives the command as `$1`
- Exits 0 to allow
- Exits non-zero to block (stdout = reason shown to the AI)

```bash
#!/usr/bin/env bash
# my-guard.sh — Describe what this prevents
COMMAND="$1"

if echo "$COMMAND" | grep -qE 'dangerous-pattern'; then
  echo "Blocked: reason why this is dangerous"
  exit 1
fi

exit 0
```

## Multiple Dispatchers

You can have separate dispatchers for different events:

| Event | Dispatcher | Guards |
|-------|-----------|--------|
| `PreToolUse` (Bash) | `pre-bash-dispatcher.sh` | Build guards, push guards, secret guards |
| `PostToolUse` (Bash) | `post-bash-dispatcher.sh` | Output scanners, audit loggers |
| `PostToolUse` (Edit) | `post-edit-dispatcher.sh` | Code style guards, security scanners |

## Design Principles

### Fail closed
If a guard can't determine whether the command is safe, it should block. False positives (blocking safe commands) are annoying but harmless. False negatives (allowing dangerous commands) can cause real damage.

### Independent guards
Each guard checks one thing. Don't combine "check for secrets" and "check for force push" in one file. Separation makes guards testable and composable.

### Fast execution
Guards run on every command. Keep them fast. Avoid network calls or heavy computation. A guard that takes 500ms makes every command feel sluggish.

### Clear error messages
When a guard blocks a command, explain why AND what to do instead. "Push to main blocked" is less helpful than "Push to main blocked. Use a feature branch and create a PR instead."

## Scaling

This pattern scales well:
- 10 guards: ~50ms total execution time
- 50 guards: ~200ms (still acceptable)
- 100+ guards: Consider categorizing into subdirectories and only running relevant categories

## Metrics

Track which guards fire and how often. This helps identify:
- Guards that never fire (consider removing)
- Guards that fire constantly (consider tightening the matcher)
- New patterns that need guards (gaps in coverage)

A simple approach: each guard appends to a log file when it blocks.

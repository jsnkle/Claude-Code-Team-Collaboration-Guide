#!/usr/bin/env bash
# lint-on-commit.sh — PreToolUse hook for Bash
# Blocks git commits if the linter fails. Passes all other commands through.

set -euo pipefail

# Read hook JSON from stdin and extract the command
COMMAND=$(jq -r '.tool_input.command // empty')

# Only gate git commit commands — let everything else through
if ! echo "$COMMAND" | grep -qE '^\s*git\s+commit\b'; then
  exit 0
fi

# Run the linter — if it fails, block the commit (exit 2)
if ! pnpm lint 2>&1; then
  echo "Lint failed — fix the errors above before committing." >&2
  exit 2
fi

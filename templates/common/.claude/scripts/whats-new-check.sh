#!/usr/bin/env bash
# whats-new-check.sh — SessionStart hook script
# Prints a one-liner if the developer hasn't seen the latest whats-new update.
# Runs silently on subsequent sessions until the version marker changes.
#
# Platform support: macOS, Linux, and Windows via WSL or Git Bash.
# Native Windows (PowerShell/CMD) is not yet supported — coming soon.

set -euo pipefail

COMMAND_FILE=".claude/commands/whats-new.md"
SEEN_FILE="$HOME/.claude/.whats-new-seen"

# Extract the version marker from the command file (e.g., "2025-02")
if [[ ! -f "$COMMAND_FILE" ]]; then
  exit 0
fi

# Extract version using bash builtins only (no sed/grep — works on macOS, Linux, Git Bash)
CURRENT_VERSION=""
while IFS= read -r line; do
  if [[ "$line" == *'<!-- Update: '*' -->'* ]]; then
    tmp="${line#*<!-- Update: }"
    CURRENT_VERSION="${tmp%% -->*}"
    break
  fi
done < "$COMMAND_FILE"

if [[ -z "$CURRENT_VERSION" ]]; then
  exit 0
fi

# Read the previously seen version
SEEN_VERSION=""
if [[ -f "$SEEN_FILE" ]]; then
  SEEN_VERSION=$(<"$SEEN_FILE")

# Compare and notify if different
if [[ "$CURRENT_VERSION" != "$SEEN_VERSION" ]]; then
  echo "New Claude Code features available — run /whats-new to see what's changed"
  mkdir -p "$(dirname "$SEEN_FILE")"
  echo "$CURRENT_VERSION" > "$SEEN_FILE"
fi

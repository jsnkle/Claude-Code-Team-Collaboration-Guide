#!/usr/bin/env bash
# format-on-save.sh — PostToolUse hook for Write|Edit
# Auto-formats files after Claude writes or edits them.
# Requires prettier. Exits silently if prettier isn't installed.

set -euo pipefail

# Read hook JSON from stdin and extract the file path
FILE_PATH=$(jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Only format if prettier is available
if ! command -v pnpm &>/dev/null || ! pnpm exec prettier --version &>/dev/null; then
  exit 0
fi

# Run prettier — it handles unsupported file types gracefully
pnpm exec prettier --write "$FILE_PATH" 2>/dev/null || true

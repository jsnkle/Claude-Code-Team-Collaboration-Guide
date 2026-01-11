# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A template repository providing ready-to-use Claude Code configurations for development teams. Contains composable templates (common + stack-specific) and comprehensive documentation.

**Compatible with Claude Code v2.1.4**

## Repository Structure

```
docs/              # 19-part reference guide (01-feature-overview.md through 19-resources.md)
templates/
  common/          # Universal best practices - always copy first
  react/           # React-specific - merges with common
.claude/
  commands/        # Project slash commands (e.g., /sync-upstream)
```

## Template Architecture

Templates are **composable** - `common/` provides universal rules/commands, stack templates add framework-specific configurations. When updating templates:

1. `common/.claude/` contains: CLAUDE.md template, settings.json, rules/, commands/, agents/, skills/
2. Stack templates (react/) contain only stack-specific additions that merge with common
3. Templates use `{{PLACEHOLDER}}` syntax for project-specific values

## Documentation Maintenance

Use `/sync-upstream` to check for Claude Code updates. This fetches the changelog from `https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md` and compares against our docs.

When updating documentation:
- Update version number in README.md and docs/01-feature-overview.md
- Reference official docs at `https://code.claude.com/docs/en/` (not docs.anthropic.com)

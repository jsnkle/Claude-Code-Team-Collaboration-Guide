# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A template repository and 19-part reference guide for standardizing Claude Code across development teams. Serves two audiences equally:

- **Team Plan** users — who have an admin layer (`managed-settings.json`) above project config
- **Individual Plan** users (Pro/Max) — where the `.claude/` directory committed to git is the only shared governance

Contains composable templates (common + stack-specific) and comprehensive documentation. The templates work identically for both audiences.

**Compatible with Claude Code v2.1.37**

## Terminology & Framing

- Use **"Admin"** (not "Enterprise") when referring to the top level of the config hierarchy (`managed-settings.json`). Anthropic's docs call this "Enterprise" but it's available on any Team Plan.
- When writing guidance that differs by plan type, address both scenarios (Team Plan and Individual Plans) rather than assuming one or the other.

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
- Update version number in README.md, CLAUDE.md, TODO.md, docs/01-feature-overview.md, and docs/19-resources.md
- Reference official docs at `https://code.claude.com/docs/en/` (not docs.anthropic.com)

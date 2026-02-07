# Part 1: Claude Code Feature Overview (v2.1.36)

## Core Features

| Feature | Purpose | Scope |
|---------|---------|-------|
| **CLAUDE.md** | Project context & instructions loaded at startup | Project/User/Admin |
| **Project Rules** | Modular, path-scoped instruction files in `.claude/rules/` | Project/User |
| **settings.json** | Permissions, environment variables, tool behavior | Project/User/Admin |
| **Slash Commands** | Reusable prompt templates triggered with `/` | Project/User |
| **Subagents** | Specialized AI assistants with isolated context | Project/User |
| **Skills** | Auto-loading procedural knowledge based on task context | Project/User |
| **Hooks** | Shell commands triggered at lifecycle events | Project/User |
| **Plugins** | Bundled packages of commands, agents, hooks | Marketplace/Custom |
| **MCP Servers** | External tool integrations (GitHub, Jira, etc.) | Project/User |
| **Checkpoints** | Automatic code state snapshots for `/rewind` recovery | Session |
| **Output Styles** | Modify Claude's behavior (Default, Explanatory, Learning) | Project/User |
| **Task Management** | Built-in task tracking with dependency support (v2.1.16+) | Session |
| **VS Code Extension** | Native IDE integration with inline diffs and plan mode | IDE |
| **LSP Code Intelligence** | Go-to-definition, find references, hover documentation | IDE |

## Key v2.0+ Features (Team-Relevant)

| Feature | Description | Team Relevance |
|---------|-------------|----------------|
| **Plan Mode** | Toggle with `Shift+Tab` or `/plan`. Claude creates a plan before executing, allowing review and feedback. | Encourages thoughtful changes |
| **Plugin System** | `/plugin install`, `/plugin marketplace` - Extend with custom commands, agents, hooks, MCP servers. | Distribute team plugins |
| **Sandbox Mode** | Bash sandboxing on Linux/Mac for safer command execution. | Configurable in project settings.json |
| **Output Styles** | Custom output styles can be distributed in `.claude/output-styles/`. | Team-wide behavior customization |
| **Checkpoints & /rewind** | Automatically saves code state before each edit. Developers can restore to any checkpoint. | Safety net for team members |

## Key v2.1+ Features

| Feature | Description | Team Relevance |
|---------|-------------|----------------|
| **Unified Commands & Skills** | Slash commands and skills now share a unified model. Both support `context: fork` for isolated execution. | Simpler mental model |
| **Skill Hot-Reload** | Skills in `~/.claude/skills` or `.claude/skills` automatically reload when files change. | Faster iteration on team skills |
| **Language Setting** | Configure Claude's response language via `language` setting (e.g., `"ja"` for Japanese). | Multilingual team support |
| **Wildcard Bash Permissions** | Support for patterns like `Bash(npm *)` for flexible command permissions. | Easier permission management |
| **Release Channels** | Toggle between `stable` and `latest` release channels in `/config`. | Control update timing |
| **Unreachable Rule Warnings** | Claude Code detects and warns about permission rules that can never be reached. | Catch config mistakes |
| **Task Management** | Built-in task tracking with dependency support via `TaskCreate`/`TaskUpdate` tools. | Structured work tracking |
| **Customizable Keybindings** | Remap keyboard shortcuts with chord sequence support via `/keybindings`. | Team-standard shortcuts |

## Key v2.1.16+ Features

| Feature | Description | Team Relevance |
|---------|-------------|----------------|
| **Agent Teams (Preview)** | Multi-agent collaboration with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. Includes `TeammateIdle` and `TaskCompleted` hook events. | Parallel agent workflows |
| **Agent Memory** | Automatic memory recording/recall with `user`, `project`, or `local` scope. Claude builds knowledge across sessions. | Persistent project context |
| **New Hook Events** | `Setup` event (via `--init`), `PreToolUse` returns `additionalContext`, `TeammateIdle`, `TaskCompleted`. | Richer automation triggers |
| **Indexed Command Arguments** | `$ARGUMENTS[0]` bracket syntax for positional arguments in slash commands. | More flexible team commands |
| **MCP Auto-Enable** | `auto:N` syntax for MCP tool search threshold (0-100%). Default 10%. | Smoother MCP tool adoption |
| **Plugin Pinning** | Pin plugins to specific git commit SHAs for reproducible setups. | Version-locked team plugins |
| **PR Session Linking** | `--from-pr` flag and auto-linking via `gh pr create`. PR review status in prompt footer. | PR-centric workflows |
| **Skills from --add-dir** | Skills and CLAUDE.md auto-load from `--add-dir` directories. | Shared skill libraries |

**Note:** Claude Code includes many individual productivity features (extended thinking, background commands, vim mode, etc.) documented in the [official docs](https://code.claude.com/docs). This guide focuses on team-configurable features.

## Memory & Configuration Hierarchy

Claude Code uses a hierarchical system where higher levels take precedence:

| Level | Memory Location | Settings Location | Shared With |
|-------|-----------------|-------------------|-------------|
| **1. Admin** | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | `managed-settings.json` | All org users |
| **2. User** | `~/.claude/CLAUDE.md` | `~/.claude/settings.json` | Just you (all projects) |
| **3. Project** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | `./.claude/settings.json` | Team via git |
| **4. Project Local** | `./CLAUDE.local.md` | `./.claude/settings.local.json` | Just you (this project) |

> **Which levels apply to you?**
>
> - **Team Plan** ($25–$125/seat, min 5) — All four levels. Admin deploys `managed-settings.json` at Level 1 to enforce org-wide policies.
> - **Individual Plans** (Pro $20/mo or Max $100–$200/mo each) — Levels 2–4 only. No Level 1. Project-level `.claude/` is the primary shared governance.

**Note:** Anthropic's docs refer to Level 1 as "Enterprise" but `managed-settings.json` is available on any Team Plan.

**Note:** Project rules (`.claude/rules/`) load with the same priority as `.claude/CLAUDE.md`.

---

[← Back to Guide](../README.md) | [Next: Project Rules →](02-project-rules.md)

# Part 1: Claude Code Feature Overview (v2.0.74)

## Core Features

| Feature | Purpose | Scope |
|---------|---------|-------|
| **CLAUDE.md** | Project context & instructions loaded at startup | Project/User/Enterprise |
| **Project Rules** | Modular, path-scoped instruction files in `.claude/rules/` | Project/User |
| **settings.json** | Permissions, environment variables, tool behavior | Project/User/Enterprise |
| **Slash Commands** | Reusable prompt templates triggered with `/` | Project/User |
| **Subagents** | Specialized AI assistants with isolated context | Project/User |
| **Skills** | Auto-loading procedural knowledge based on task context | Project/User |
| **Hooks** | Shell commands triggered at lifecycle events | Project/User |
| **Plugins** | Bundled packages of commands, agents, hooks | Marketplace/Custom |
| **MCP Servers** | External tool integrations (GitHub, Jira, etc.) | Project/User |
| **Checkpoints** | Automatic code state snapshots for `/rewind` recovery | Session |
| **Output Styles** | Modify Claude's behavior (Default, Explanatory, Learning) | Project/User |
| **VS Code Extension** | Native IDE integration with inline diffs and plan mode | IDE |
| **LSP Code Intelligence** | Go-to-definition, find references, hover documentation | IDE |

## Key v2.0+ Features (Team-Relevant)

| Feature | Description | Team Relevance |
|---------|-------------|----------------|
| **Plan Mode** | Toggle with `Shift+Tab`. Claude creates a plan before executing, allowing review and feedback. | Encourages thoughtful changes |
| **Plugin System** | `/plugin install`, `/plugin marketplace` - Extend with custom commands, agents, hooks, MCP servers. | Distribute team plugins |
| **Sandbox Mode** | Bash sandboxing on Linux/Mac for safer command execution. | Configurable in project settings.json |
| **Output Styles** | Custom output styles can be distributed in `.claude/output-styles/`. | Team-wide behavior customization |
| **Checkpoints & /rewind** | Automatically saves code state before each edit. Developers can restore to any checkpoint. | Safety net for team members |

**Note:** Claude Code includes many individual productivity features (extended thinking, background commands, vim mode, etc.) documented in the [official docs](https://code.claude.com/docs). This guide focuses on team-configurable features.

## Memory & Configuration Hierarchy

Claude Code uses a hierarchical system where higher levels take precedence:

| Level | Memory Location | Settings Location | Shared With |
|-------|-----------------|-------------------|-------------|
| **1. Enterprise** | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | `managed-settings.json` | All org users |
| **2. User** | `~/.claude/CLAUDE.md` | `~/.claude/settings.json` | Just you (all projects) |
| **3. Project** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | `./.claude/settings.json` | Team via git |
| **4. Project Local** | `./CLAUDE.local.md` | `./.claude/settings.local.json` | Just you (this project) |

**Note:** Project rules (`.claude/rules/`) load with the same priority as `.claude/CLAUDE.md`.

---

[← Back to Guide](../README.md) | [Next: Project Rules →](02-project-rules.md)

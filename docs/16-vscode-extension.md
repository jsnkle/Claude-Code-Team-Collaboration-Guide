# Part 14: VS Code Extension

The Claude Code VS Code extension provides a graphical interface alternative to the CLI.

## Key Features

- **LSP Code Intelligence**: Go-to-definition, find references, and hover documentation powered by Language Server Protocol
- Inline diffs and plan mode
- Native IDE integration

## Features Added Since v2.1.4

| Feature | Version | Description |
|---------|---------|-------------|
| **Native Plugin Management** | v2.1.16 | Browse, install, and manage plugins directly in VS Code |
| **OAuth Remote Sessions** | v2.1.16 | Browse and resume remote Claude sessions for OAuth users |
| **Session Forking & Rewind** | v2.1.19 | Fork conversations and rewind to checkpoints in the IDE |
| **Python Venv Auto-Activation** | v2.1.21 | Automatic Python virtual environment activation (configurable) |
| **Multiline Input** | v2.1.30 | Shift+Enter for multiline input in question dialogs |
| **Loading Spinner** | v2.1.32 | Loading spinner when browsing past conversations |
| **Remote Sessions for OAuth** | v2.1.33 | Remote session support for OAuth users |

## Team Relevance

Project `.claude/` configurations (rules, commands, agents, settings) work identically in both the CLI and extension. Teams can standardize on either interface - the configuration is shared.

For installation and feature details, see the [official VS Code extension documentation](https://code.claude.com/docs).

---

[← Previous: Output Styles](15-output-styles.md) | [Back to Guide](../README.md) | [Next: Additional Features →](17-additional-features.md)

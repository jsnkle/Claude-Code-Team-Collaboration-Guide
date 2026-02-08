# Part 12: Plugin System

Plugins are a lightweight way to package and share customizations: slash commands, subagents, skills, hooks, MCP servers, LSP servers, and output styles.

## Plugin Structure

```
my-plugin/
  .claude-plugin/
    plugin.json          # Manifest (only this goes inside .claude-plugin/)
  commands/              # Skills as Markdown files
  agents/                # Custom agent definitions
  skills/                # Agent Skills with SKILL.md files
  hooks/
    hooks.json           # Event handlers
  .mcp.json              # MCP server configurations
  .lsp.json              # LSP server configurations
```

### Plugin Manifest (`plugin.json`)

Only `name` is required (kebab-case, no spaces):

```json
{
  "name": "my-plugin",
  "description": "A description of what this plugin does",
  "version": "1.0.0",
  "author": { "name": "Your Name" }
}
```

## Installing Plugins

### CLI Commands

| Command | Description |
|---------|-------------|
| `claude plugin install <plugin> [-s scope]` | Install from marketplace |
| `claude plugin uninstall <plugin> [-s scope]` | Remove plugin |
| `claude plugin enable <plugin> [-s scope]` | Enable disabled plugin |
| `claude plugin disable <plugin> [-s scope]` | Disable without removing |
| `claude plugin update <plugin> [-s scope]` | Update to latest version |

### Interactive Commands

```bash
/plugin marketplace          # Browse available plugins
/plugin install <name>       # Install a plugin
/plugin enable <name>        # Enable a plugin
/plugin disable <name>       # Disable a plugin
/plugin list                 # Filterable search for installed plugins
/plugin validate .           # Validate plugin structure
```

### Installation Scopes

| Scope | Settings file | Use case |
|-------|--------------|----------|
| `user` | `~/.claude/settings.json` | Personal (default) |
| `project` | `.claude/settings.json` | Team (version control) |
| `local` | `.claude/settings.local.json` | Project-specific, gitignored |
| `managed` | `managed-settings.json` | Admin-managed (read-only, update only) |

## Plugin Configuration

In `settings.json`:

```json
{
  "enabledPlugins": {
    "formatter@company-tools": true,
    "deployer@company-tools": true,
    "analyzer@security-plugins": false
  },
  "extraKnownMarketplaces": {
    "company-tools": {
      "source": {
        "source": "github",
        "repo": "company/claude-plugins"
      }
    }
  }
}
```

## Team Plugin Distribution

Add `extraKnownMarketplaces` to your project's `.claude/settings.json` to ensure team members have access to required plugins:

```json
{
  "extraKnownMarketplaces": {
    "team-tools": {
      "source": {
        "source": "github",
        "repo": "your-org/claude-plugins"
      }
    }
  }
}
```

When team members trust the folder, they'll be prompted to install the marketplace and plugins.

### Marketplace Source Types

| Source | Example |
|--------|---------|
| GitHub | `{ "source": "github", "repo": "owner/repo", "ref": "main", "path": "dir" }` |
| Git | `{ "source": "git", "url": "https://...", "ref": "v3.1" }` |
| URL | `{ "source": "url", "url": "https://..." }` |
| NPM | `{ "source": "npm", "package": "@scope/name" }` |
| File | `{ "source": "file", "path": "/absolute/path/to/marketplace.json" }` |
| Directory | `{ "source": "directory", "path": "/absolute/path" }` |
| Host pattern | `{ "source": "hostPattern", "hostPattern": "^github\\.example\\.com$" }` |

### Admin Control

Restrict which marketplaces users can add via managed settings:

```json
{
  "strictKnownMarketplaces": [
    {
      "source": { "source": "github", "repo": "company/approved-plugins" }
    }
  ]
}
```

## Plugin Pinning (v2.1.14+)

Pin plugins to specific git commit SHAs for reproducible team setups:

```bash
/plugin install <plugin-name>@<commit-sha>
```

This ensures all team members use the exact same plugin version.

## LSP Code Intelligence

Plugins can include LSP (Language Server Protocol) servers for go-to-definition, find references, and hover documentation.

### Configuration (`.lsp.json`)

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": { ".go": "go" }
  }
}
```

### Required Fields

| Field | Description |
|-------|-------------|
| `command` | The LSP binary to execute |
| `extensionToLanguage` | Maps file extensions to language identifiers |

### Optional Fields

| Field | Description |
|-------|-------------|
| `args` | Command-line arguments |
| `transport` | `stdio` (default) or `socket` |
| `env` | Environment variables |
| `initializationOptions` | Server initialization options |
| `settings` | Settings via `workspace/didChangeConfiguration` |
| `restartOnCrash` | Auto-restart on crash |
| `maxRestarts` | Max restart attempts |

### Available LSP Plugins

| Plugin | Language server | Install command |
|--------|----------------|-----------------|
| `pyright-lsp` | Pyright (Python) | `pip install pyright` or `npm install -g pyright` |
| `typescript-lsp` | TypeScript Language Server | `npm install -g typescript-language-server typescript` |
| `rust-lsp` | rust-analyzer | See rust-analyzer docs |

## VS Code Plugin Management (v2.1.16+)

The VS Code extension provides native plugin management — browse, install, and manage plugins directly from the IDE without using CLI commands.

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `FORCE_AUTOUPDATE_PLUGINS` | Force plugins to auto-update |
| `DISABLE_AUTOUPDATER` | Disable auto-updates for plugins |
| `${CLAUDE_PLUGIN_ROOT}` | Absolute path to plugin directory (available in hooks, MCP servers, scripts) |

## Use Cases

- **Enforcing standards**: Ensure specific hooks run for code reviews
- **Supporting users**: Provide slash commands for common workflows
- **Sharing workflows**: Distribute debugging setups, deployment pipelines
- **Connecting tools**: Package MCP server configurations
- **Code intelligence**: Add LSP servers for language-specific features

---

[← Previous: Checkpoints](13-checkpoints.md) | [Back to Guide](../README.md) | [Next: Output Styles →](15-output-styles.md)

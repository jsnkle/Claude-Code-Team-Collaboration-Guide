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

Install from the official marketplace: `/plugin install <plugin-name>@claude-plugins-official`

| Plugin | Language | Binary Required |
|--------|----------|-----------------|
| `clangd-lsp` | C/C++ | `clangd` |
| `csharp-lsp` | C# | `csharp-ls` |
| `gopls-lsp` | Go | `gopls` |
| `jdtls-lsp` | Java | `jdtls` |
| `kotlin-lsp` | Kotlin | `kotlin-language-server` |
| `lua-lsp` | Lua | `lua-language-server` |
| `php-lsp` | PHP | `intelephense` |
| `pyright-lsp` | Python | `pyright-langserver` |
| `rust-analyzer-lsp` | Rust | `rust-analyzer` |
| `swift-lsp` | Swift | `sourcekit-lsp` |
| `typescript-lsp` | TypeScript | `typescript-language-server` |

**What code intelligence provides:**
- **Automatic diagnostics**: After every file edit, the language server reports errors/warnings automatically. Claude sees type errors, missing imports, and syntax issues without running a compiler.
- **Code navigation**: Jump to definitions, find references, get type info on hover, list symbols, find implementations, trace call hierarchies.

## External Integration Plugins (MCP Servers)

Pre-configured MCP server plugins available from the official marketplace:

| Category | Plugins |
|----------|---------|
| Source control | `github`, `gitlab` |
| Project management | `atlassian` (Jira/Confluence), `asana`, `linear`, `notion` |
| Design | `figma` |
| Infrastructure | `vercel`, `firebase`, `supabase` |
| Communication | `slack` |
| Monitoring | `sentry` |

## Development Workflow Plugins

| Plugin | Description |
|--------|-------------|
| `commit-commands` | Git commit workflows including commit, push, and PR creation |
| `pr-review-toolkit` | Specialized agents for reviewing pull requests |
| `agent-sdk-dev` | Tools for building with the Claude Agent SDK |
| `plugin-dev` | Toolkit for creating your own plugins |

## Output Style Plugins

| Plugin | Description |
|--------|-------------|
| `explanatory-output-style` | Educational insights about implementation choices |
| `learning-output-style` | Interactive learning mode for skill building |

## Creating a Marketplace

A marketplace is a catalog of plugins hosted as a git repository.

### Marketplace Schema (`marketplace.json`)

```json
{
  "name": "my-marketplace",
  "owner": { "name": "Your Name", "email": "you@example.com" },
  "metadata": {
    "description": "Team plugins for our org",
    "version": "1.0.0",
    "pluginRoot": "./plugins"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "What this plugin does",
      "version": "1.0.0",
      "category": "productivity",
      "tags": ["workflow", "automation"]
    }
  ]
}
```

### Required Fields

| Field | Description |
|-------|-------------|
| `name` | Marketplace identifier (kebab-case). Users see this when installing plugins |
| `owner.name` | Maintainer name |
| `plugins` | Array of plugin entries (each needs `name` and `source`) |

### Reserved Marketplace Names

These names are reserved for official Anthropic use: `claude-code-marketplace`, `claude-code-plugins`, `claude-plugins-official`, `anthropic-marketplace`, `anthropic-plugins`, `agent-skills`, `life-sciences`. Names that impersonate official marketplaces are also blocked.

### Plugin Entry Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Plugin identifier (kebab-case) |
| `source` | Yes | Where to fetch: relative path, GitHub `{source: "github", repo: "owner/repo"}`, or git URL |
| `description` | No | Brief plugin description |
| `version` | No | Plugin version |
| `category` | No | Category for organization |
| `tags` | No | Tags for searchability |
| `strict` | No | When `true` (default), marketplace fields merge with `plugin.json`. When `false`, marketplace entry defines the plugin entirely |
| `commands`, `agents`, `hooks`, `mcpServers`, `lspServers` | No | Custom component paths or inline configurations |

### Plugin Sources

| Source Type | Format |
|-------------|--------|
| Relative path | `"source": "./plugins/my-plugin"` |
| GitHub | `{"source": "github", "repo": "owner/repo", "ref": "v2.0", "sha": "abc123..."}` |
| Git URL | `{"source": "url", "url": "https://gitlab.com/team/plugin.git"}` |

### Private Repository Authentication

For manual installs, Claude Code uses existing git credential helpers. For background auto-updates:

| Provider | Environment Variable |
|----------|---------------------|
| GitHub | `GITHUB_TOKEN` or `GH_TOKEN` |
| GitLab | `GITLAB_TOKEN` or `GL_TOKEN` |
| Bitbucket | `BITBUCKET_TOKEN` |

### Adding Marketplaces

```bash
# GitHub repositories
/plugin marketplace add your-org/claude-plugins

# Git URLs (HTTPS or SSH)
/plugin marketplace add https://gitlab.com/company/plugins.git
/plugin marketplace add git@gitlab.com:company/plugins.git

# Specific branch/tag
/plugin marketplace add https://gitlab.com/company/plugins.git#v1.0.0

# Local paths
/plugin marketplace add ./my-marketplace

# Remote URLs
/plugin marketplace add https://example.com/marketplace.json
```

### Marketplace Management

| Command | Action |
|---------|--------|
| `/plugin marketplace list` | List configured marketplaces |
| `/plugin marketplace update <name>` | Refresh plugin listings |
| `/plugin marketplace remove <name>` | Remove marketplace (uninstalls its plugins) |

### Marketplace Validation

```bash
# From terminal
claude plugin validate .

# From within Claude Code
/plugin validate .
```

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

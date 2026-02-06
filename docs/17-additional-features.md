# Part 15: Additional Team-Configurable Features

## Sandbox Mode

Enable bash sandboxing for safer command execution in your project's `settings.json`:

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["git", "docker"],
    "network": {
      "allowLocalBinding": true
    }
  }
}
```

This provides an additional layer of security for team environments.

## Environment Variables

Set project-wide environment variables in `settings.json`:

```json
{
  "env": {
    "NODE_ENV": "development",
    "API_URL": "https://dev-api.example.com"
  }
}
```

## Model Override

Specify a default model for the project:

```json
{
  "model": "claude-sonnet-4-5-20250929"
}
```

## Language Setting (v2.1+)

Configure Claude's response language for multilingual teams:

```json
{
  "language": "ja"
}
```

Supported values include language codes like `"ja"` (Japanese), `"es"` (Spanish), `"de"` (German), etc.

## Release Channels (v2.1+)

Team members can toggle between `stable` and `latest` release channels via `/config`. This allows:
- **Stable**: Production-ready features
- **Latest**: Early access to new features

## New Settings (v2.1.7+)

| Setting | Purpose | Version |
|---------|---------|---------|
| `spinnerVerbs` | Customize spinner verb text displayed during processing | v2.1.23+ |
| `showTurnDuration` | Show or hide turn duration messages | v2.1.7+ |
| `plansDirectory` | Custom directory for plan file storage | v2.1.9+ |
| `reducedMotion` | Enable reduced motion mode for accessibility | v2.1.30+ |

## Config Backups (v2.1.20+)

Configuration files are automatically backed up with timestamps. The 5 most recent backups are rotated, preventing accidental configuration loss.

## Useful Environment Variables

| Variable | Purpose |
|----------|---------|
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Disable background task functionality (v2.1.4+) |
| `CLAUDE_CODE_TMPDIR` | Override temp directory location (v2.1.5+) |
| `CLAUDE_CODE_ENABLE_TASKS` | Set `false` to disable task management system (v2.1.19+) |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | Set `1` to load CLAUDE.md from `--add-dir` directories (v2.1.20+) |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Set `1` to enable agent teams research preview (v2.1.32+) |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` | Set `1` to disable experimental beta features (v2.1.25+) |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Limit file read output tokens (v2.1+) |
| `BASH_DEFAULT_TIMEOUT_MS` | Default bash command timeout |
| `BASH_MAX_TIMEOUT_MS` | Maximum bash command timeout |
| `MCP_TIMEOUT` | MCP server startup timeout |
| `MCP_TOOL_TIMEOUT` | MCP tool execution timeout |

**Note:** Claude Code includes many individual productivity features (background commands, vim mode, session management, etc.) documented in the [official docs](https://code.claude.com/docs).

---

[← Previous: VS Code Extension](16-vscode-extension.md) | [Back to Guide](../README.md) | [Next: Quick Reference →](18-quick-reference.md)

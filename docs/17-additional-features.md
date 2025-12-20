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

**Note:** Claude Code includes many individual productivity features (background commands, vim mode, session management, etc.) documented in the [official docs](https://code.claude.com/docs).

---

[← Previous: VS Code Extension](16-vscode-extension.md) | [Back to Guide](../README.md) | [Next: Quick Reference →](18-quick-reference.md)

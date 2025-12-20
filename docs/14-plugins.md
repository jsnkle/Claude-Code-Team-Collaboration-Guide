# Part 12: Plugin System

Plugins are a lightweight way to package and share customizations: slash commands, subagents, hooks, MCP servers, and output styles.

## Installing Plugins

```bash
# Browse available plugins
/plugin marketplace

# Install a plugin
/plugin install <plugin-name>

# Enable/disable plugins
/plugin enable <plugin-name>
/plugin disable <plugin-name>

# Validate plugin structure
/plugin validate
```

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
      "source": "github",
      "repo": "company/claude-plugins"
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

## Use Cases

- **Enforcing standards**: Ensure specific hooks run for code reviews
- **Supporting users**: Provide slash commands for common workflows
- **Sharing workflows**: Distribute debugging setups, deployment pipelines
- **Connecting tools**: Package MCP server configurations

---

[← Previous: Checkpoints](13-checkpoints.md) | [Back to Guide](../README.md) | [Next: Output Styles →](15-output-styles.md)

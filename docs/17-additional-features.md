# Part 15: Additional Team-Configurable Features

## Sandbox Mode

Native OS-level sandboxing provides filesystem and network isolation for Bash commands.

### OS-Level Enforcement

| Platform | Technology | Prerequisites |
|----------|-----------|---------------|
| macOS | Seatbelt | Works out of the box |
| Linux / WSL2 | bubblewrap | `sudo apt-get install bubblewrap socat` |

WSL1 is not supported.

### Sandbox Modes

| Mode | Behavior |
|------|----------|
| **Auto-allow** | Sandboxed bash commands auto-approved; non-sandboxable commands fall back to regular permission flow |
| **Regular permissions** | All bash commands go through standard permission flow even when sandboxed |

Enable sandboxing with `/sandbox` or via `settings.json`:

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["git", "docker"],
    "allowUnsandboxedCommands": true,
    "network": {
      "allowLocalBinding": true,
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

### Key Settings

| Key | Type | Description |
|-----|------|-------------|
| `enabled` | boolean | Enable bash sandboxing (default: false) |
| `autoAllowBashIfSandboxed` | boolean | Auto-approve sandboxed bash (default: true) |
| `excludedCommands` | array | Commands that run outside the sandbox |
| `allowUnsandboxedCommands` | boolean | Allow `dangerouslyDisableSandbox` escape hatch (default: true) |
| `network.allowedDomains` | array | Outbound domain allowlist (supports wildcards) |
| `network.allowLocalBinding` | boolean | Bind to localhost ports, macOS only (default: false) |
| `network.allowUnixSockets` | array | Accessible Unix socket paths |
| `enableWeakerNestedSandbox` | boolean | Weaker sandbox for unprivileged Docker (default: false) |

### Security Limitations

- Network filtering operates by domain restriction, does not inspect traffic
- Domain fronting may bypass filtering
- `allowUnixSockets` can grant access to Docker socket (privilege escalation risk)
- `enableWeakerNestedSandbox` considerably weakens security

### Open Source

The sandbox runtime is available as an npm package:

```bash
npx @anthropic-ai/sandbox-runtime <command-to-sandbox>
```

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
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Set `1` to enable agent teams research preview (v2.1.32+). See [Agent Teams](20-agent-teams.md). |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` | Set `1` to disable experimental beta features (v2.1.25+) |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Limit file read output tokens (v2.1+) |
| `BASH_DEFAULT_TIMEOUT_MS` | Default bash command timeout |
| `BASH_MAX_TIMEOUT_MS` | Maximum bash command timeout |
| `MCP_TIMEOUT` | MCP server startup timeout |
| `MCP_TOOL_TIMEOUT` | MCP tool execution timeout |

**Note:** Claude Code includes many individual productivity features (background commands, vim mode, session management, etc.) documented in the [official docs](https://code.claude.com/docs).

---

[← Previous: VS Code Extension](16-vscode-extension.md) | [Back to Guide](../README.md) | [Next: Quick Reference →](18-quick-reference.md)

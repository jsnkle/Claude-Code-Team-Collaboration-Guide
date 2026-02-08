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
| `network.allowAllUnixSockets` | boolean | Allow all Unix socket connections (default: false) |
| `network.httpProxyPort` | number | HTTP proxy port for custom proxy configuration |
| `network.socksProxyPort` | number | SOCKS5 proxy port for custom proxy configuration |
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

## Model Configuration

### Model Aliases

| Alias | Behavior |
|-------|----------|
| `default` | Recommended setting based on account type (Opus 4.6 for Max/Teams/Pro) |
| `sonnet` | Latest Sonnet (currently Sonnet 4.5) for daily coding |
| `opus` | Latest Opus (currently Opus 4.6) for complex reasoning |
| `haiku` | Fast, efficient Haiku for simple tasks |
| `sonnet[1m]` | Sonnet with 1M token context window for long sessions |
| `opusplan` | Uses Opus during plan mode, switches to Sonnet for execution |

Aliases always point to the latest version. Pin to a specific version with the full model name (e.g., `claude-opus-4-5-20251101`) or override via environment variables.

### Setting the Model

```json
{
  "model": "opus"
}
```

Override at startup with `claude --model <alias|name>`, mid-session with `/model <alias>`, or via `ANTHROPIC_MODEL` environment variable.

### Effort Levels

Effort levels control Opus 4.6's adaptive reasoning. Lower effort is faster and cheaper for straightforward tasks; higher effort enables deeper reasoning.

| Level | Behavior |
|-------|----------|
| `low` | Minimal reasoning, fast responses |
| `medium` | Balanced |
| `high` | Deep reasoning (default) |

Set via `/model` (use left/right arrows), `CLAUDE_CODE_EFFORT_LEVEL` env var, or `effortLevel` in settings.

### Model Environment Variables

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_MODEL` | Override the model alias or name |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Full model name for `opus` / `opusplan` plan mode |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Full model name for `sonnet` / `opusplan` execution |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Full model name for `haiku` and background tasks |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model override for subagents |
| `DISABLE_PROMPT_CACHING` | Set `1` to disable prompt caching globally |
| `DISABLE_PROMPT_CACHING_HAIKU` | Set `1` to disable caching for Haiku only |
| `DISABLE_PROMPT_CACHING_SONNET` | Set `1` to disable caching for Sonnet only |
| `DISABLE_PROMPT_CACHING_OPUS` | Set `1` to disable caching for Opus only |

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

## Additional Settings Reference

| Setting | Purpose |
|---------|---------|
| `$schema` | JSON schema URL for editor autocomplete and validation |
| `attribution.commit` | Git commit attribution text (replaces deprecated `includeCoAuthoredBy`) |
| `attribution.pr` | Pull request description attribution text |
| `autoUpdatesChannel` | Release channel: `"stable"` or `"latest"` |
| `companyAnnouncements` | Array of announcements cycled at startup |
| `forceLoginMethod` | Restrict login method: `"claudeai"` or `"console"` |
| `forceLoginOrgUUID` | Auto-select organization during login |
| `cleanupPeriodDays` | Inactive session deletion period (default: 30) |
| `alwaysThinkingEnabled` | Enable extended thinking by default |
| `effortLevel` | Default effort level: `"low"`, `"medium"`, or `"high"` |
| `fileSuggestion` | Custom script for `@` file autocomplete |
| `statusLine` | Custom status line context script |
| `teammateMode` | Agent team display: `"auto"`, `"in-process"`, or `"tmux"` |
| `spinnerVerbs` | Customize spinner verb text |
| `plansDirectory` | Custom directory for plan file storage |
| `awsAuthRefresh` | Custom script for AWS credential refresh |
| `awsCredentialExport` | Script outputting AWS credentials JSON |
| `otelHeadersHelper` | Script for dynamic OpenTelemetry headers |
| `enabledPlugins` | Object controlling plugin activation by name |
| `enableAllProjectMcpServers` | Auto-approve project `.mcp.json` servers |

**Managed-only settings** (set in `managed-settings.json` for Team Plans):

| Setting | Purpose |
|---------|---------|
| `allowedMcpServers` | Allowlist MCP servers by name, command, or URL pattern |
| `deniedMcpServers` | Denylist MCP servers |
| `strictKnownMarketplaces` | Restrict plugin marketplace additions |
| `allowManagedHooksOnly` | Block user, project, and plugin hooks |
| `allowManagedPermissionRulesOnly` | Enforce managed permission rules only |

## Config Backups (v2.1.20+)

Configuration files are automatically backed up with timestamps. The 5 most recent backups are rotated, preventing accidental configuration loss.

## MCP Configuration

MCP (Model Context Protocol) connects Claude Code to external tools and data sources. Configuration is team-relevant because servers can be shared via project scope or locked down via managed settings.

### MCP Scopes

| Scope | Storage | Shared | Use Case |
|-------|---------|--------|----------|
| `local` | `~/.claude.json` | No | Personal servers, sensitive credentials (default) |
| `project` | `.mcp.json` in project root | Yes (version control) | Team-shared servers and tools |
| `user` | `~/.claude.json` | No | Personal servers across all projects |

```bash
# Add project-scoped server (shared with team)
claude mcp add --transport http paypal --scope project https://mcp.paypal.com/mcp

# Add user-scoped server (personal, all projects)
claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/anthropic
```

### Project MCP File (`.mcp.json`)

Share MCP servers with your team by committing `.mcp.json` to version control:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "internal-api": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@company/mcp-server"],
      "env": {
        "API_URL": "${API_URL:-https://api.company.com}"
      }
    }
  }
}
```

Environment variable expansion (`${VAR}`, `${VAR:-default}`) is supported in `command`, `args`, `env`, `url`, and `headers`.

### Managed MCP (`managed-mcp.json`)

Admins deploy `managed-mcp.json` for exclusive control over MCP servers — users cannot add or modify servers beyond what's defined:

| Platform | Path |
|----------|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-mcp.json` |
| Linux / WSL | `/etc/claude-code/managed-mcp.json` |

The format is the same as `.mcp.json`. Alternatively, use `allowedMcpServers` and `deniedMcpServers` in managed settings for policy-based control that lets users add servers within constraints.

### OAuth Authentication

Remote MCP servers that require authentication use OAuth 2.0. Run `/mcp` inside Claude Code to authenticate. For servers that don't support dynamic client registration, provide credentials via `--client-id` and `--client-secret` flags.

### Tool Search

When many MCP tools are configured, Tool Search automatically activates to load tools on-demand instead of consuming context upfront. It triggers when tool descriptions exceed 10% of context. Control with `ENABLE_TOOL_SEARCH`: `auto` (default), `auto:<N>` (custom threshold), `true`, or `false`.

### Key CLI Commands

| Command | Description |
|---------|-------------|
| `claude mcp add` | Add an MCP server |
| `claude mcp list` | List configured servers |
| `claude mcp get <name>` | Show server details |
| `claude mcp remove <name>` | Remove a server |
| `claude mcp add-json <name> '<json>'` | Add from JSON config |
| `claude mcp add-from-claude-desktop` | Import from Claude Desktop |
| `claude mcp reset-project-choices` | Reset project server approvals |
| `/mcp` | Interactive server management and OAuth |

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

## Team-Relevant CLI Flags

| Flag | Description | Use Case |
|------|-------------|----------|
| `--agent` | Specify a subagent for the session | Override `agent` setting |
| `--mcp-config` | Load MCP servers from JSON files | CI/CD and shared configs |
| `--strict-mcp-config` | Only use MCP from `--mcp-config` | Locked-down environments |
| `--settings` | Load additional settings from JSON file or string | Override defaults per session |
| `--setting-sources` | Filter which setting sources load (`user,project,local`) | Debugging config issues |
| `--plugin-dir` | Load plugins from directories (repeatable) | Testing plugins locally |
| `--tools` | Restrict available tools (`""` for none, `"default"` for all, or tool names) | Limit tool access per session |
| `--init` / `--init-only` | Run initialization hooks (and optionally exit) | Automated environment setup |
| `--maintenance` | Run maintenance hooks and exit | Scheduled cleanup tasks |
| `--fallback-model` | Auto-fallback model when default is overloaded (print mode) | CI/CD reliability |
| `--no-session-persistence` | Disable session saving (print mode) | Ephemeral CI runs |
| `--disable-slash-commands` | Disable all skills and slash commands | Restricted sessions |
| `--permission-prompt-tool` | MCP tool for permission prompts in non-interactive mode | Automated permission handling |

## Headless / Programmatic Mode (Agent SDK)

Run Claude Code non-interactively with the `-p` (or `--print`) flag for CI/CD pipelines, scripts, and programmatic workflows.

### Basic Usage

```bash
# Simple query
claude -p "What does the auth module do?"

# Piped input
cat logs.txt | claude -p "Explain these errors"
```

### Output Formats

| Format | Flag | Description |
|--------|------|-------------|
| Text | `--output-format text` | Plain text (default) |
| JSON | `--output-format json` | Structured JSON with `result`, `session_id`, metadata |
| Stream JSON | `--output-format stream-json` | Newline-delimited JSON for real-time streaming |

#### JSON Output with Schema Validation

```bash
claude -p "Extract function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

The response includes metadata (session ID, usage) with structured output in the `structured_output` field.

#### Parsing with jq

```bash
# Extract text result
claude -p "Summarize this project" --output-format json | jq -r '.result'

# Stream text deltas
claude -p "Write a poem" --output-format stream-json --verbose --include-partial-messages | \
  jq -rj 'select(.type == "stream_event" and .event.delta.type? == "text_delta") | .event.delta.text'
```

### Auto-Approve Tools

```bash
claude -p "Run tests and fix failures" \
  --allowedTools "Bash,Read,Edit"

# Fine-grained: allow specific command prefixes
claude -p "Create a commit for staged changes" \
  --allowedTools "Bash(git diff *),Bash(git log *),Bash(git status *),Bash(git commit *)"
```

**Note:** `Bash(git diff *)` allows any command starting with `git diff ` (space before `*` matters). Without the space (`Bash(git diff*)`), it would also match `git diff-index`.

### Session Continuation

```bash
# Continue most recent conversation
claude -p "Now focus on database queries" --continue

# Capture session ID for later resume
session_id=$(claude -p "Start a review" --output-format json | jq -r '.session_id')
claude -p "Continue that review" --resume "$session_id"
```

### System Prompt Customization

| Flag | Behavior | Modes |
|------|----------|-------|
| `--system-prompt` | **Replaces** entire default prompt | Interactive + Print |
| `--system-prompt-file` | **Replaces** with file contents | Print only |
| `--append-system-prompt` | **Appends** to default prompt | Interactive + Print |
| `--append-system-prompt-file` | **Appends** file contents | Print only |

`--system-prompt` and `--system-prompt-file` are mutually exclusive. For most use cases, `--append-system-prompt` is recommended as it preserves Claude Code's built-in capabilities.

### Budget and Turn Limits

```bash
# Limit spending
claude -p --max-budget-usd 5.00 "Refactor the auth module"

# Limit agentic turns
claude -p --max-turns 3 "Fix lint errors"
```

**Note:** User-invocable skills (`/commit`, `/review`) are only available in interactive mode. In `-p` mode, describe the task instead.

**Note:** Claude Code includes many individual productivity features (background commands, vim mode, session management, etc.) documented in the [official docs](https://code.claude.com/docs).

---

[← Previous: VS Code Extension](16-vscode-extension.md) | [Back to Guide](../README.md) | [Next: Quick Reference →](18-quick-reference.md)

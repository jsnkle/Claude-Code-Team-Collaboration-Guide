# Part 9: Security Considerations

## Permission Modes

Claude Code supports six permission modes, controllable via `defaultMode` in settings or `--permission-mode` on the CLI:

| Mode | Description |
|------|-------------|
| `default` | Standard behavior: prompts for permission on first use |
| `acceptEdits` | Automatically accepts file edit permissions for the session |
| `plan` | Plan mode: Claude can analyze but not modify files or execute commands |
| `delegate` | Coordination-only mode for agent team leads |
| `dontAsk` | Auto-denies tools unless pre-approved via `/permissions` or `permissions.allow` rules |
| `bypassPermissions` | Skips all permission prompts (requires safe environment like a devcontainer) |

Admins can disable bypass mode: set `disableBypassPermissionsMode` to `"disable"` in managed settings.

## Permission Rule Syntax

Rules use the format `Tool` or `Tool(specifier)`. Rules support three levels: `allow`, `ask`, and `deny`.

### Permission Levels

| Level | Behavior |
|-------|----------|
| `allow` | Tool executes without prompting |
| `ask` | User is prompted for approval (default for most tools) |
| `deny` | Tool is blocked unconditionally |

### Additional Directories

Grant Claude access to directories outside the working directory via settings or CLI:

```json
{
  "permissions": {
    "additionalDirectories": ["../docs/", "../shared-lib/"]
  }
}
```

Also available via `--add-dir <path>` flag at startup or `/add-dir <path>` interactively.

### Basic Rules

| Rule | Effect |
|------|--------|
| `Bash` or `Bash(*)` | Matches all Bash commands |
| `Read(./.env)` | Matches reading `.env` in current directory |
| `WebFetch(domain:example.com)` | Matches fetch requests to example.com |

### Wildcard Patterns

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git commit *)"
    ],
    "deny": ["Bash(git push *)"]
  }
}
```

The space before `*` matters: `Bash(ls *)` matches `ls -la` but not `lsof`. Claude Code is aware of shell operators (`&&`) so `Bash(safe-cmd *)` won't match `safe-cmd && other-cmd`.

### Read/Edit Path Pattern Types

| Pattern | Meaning | Example | Matches |
|---------|---------|---------|---------|
| `//path` | Absolute from filesystem root | `Read(//Users/alice/secrets/**)` | `/Users/alice/secrets/**` |
| `~/path` | From home directory | `Read(~/Documents/*.pdf)` | `/Users/alice/Documents/*.pdf` |
| `/path` | Relative to settings file | `Edit(/src/**/*.ts)` | `<settings dir>/src/**/*.ts` |
| `path` or `./path` | Relative to current directory | `Read(*.env)` | `<cwd>/*.env` |

`*` matches files in a single directory; `**` matches recursively.

### MCP Tool Rules

- `mcp__puppeteer` — any tool from the puppeteer server
- `mcp__puppeteer__*` — wildcard, same effect
- `mcp__puppeteer__puppeteer_navigate` — specific tool

### Subagent Rules

Deny or allow specific subagent types:

- `Task(Explore)` — Explore subagent
- `Task(Plan)` — Plan subagent
- `Task(my-custom-agent)` — custom subagent

### Disallowing Tools via CLI

Use `--disallowedTools` to block specific tools for a session:

```bash
claude --disallowedTools "Bash,WebFetch"
```

Use `/permissions` interactively to view and manage permission rules.

## Permission Deny Rules (Required)

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./**/*.key)",
      "Read(./**/*.pem)",
      "Read(./**/*.p12)",
      "Read(./config/credentials.*)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(chmod 777 *)"
    ]
  }
}
```

Rule evaluation order: **Deny > Ask > Allow** (first match wins).

## Unreachable Rule Detection

Claude Code detects and warns about permission rules that can never be reached:

```json
{
  "permissions": {
    "deny": ["Bash(rm *)"],
    "allow": ["Bash(rm -rf *)"]
  }
}
```

The `allow` rule for `rm -rf` is unreachable because `deny` for `rm` matches first. Check warnings via `/permissions`.

## Prompt Injection Protections

Claude Code includes built-in protections against prompt injection:

- **Command blocklist**: `curl` and `wget` are blocked by default in Bash deny rules
- **Context-aware analysis**: Claude evaluates tool inputs for potential injection
- **Shell operator awareness**: Permission rules understand `&&`, `||`, and pipes — `Bash(safe-cmd *)` won't match `safe-cmd && malicious-cmd`

## Credential Storage

On macOS, API keys, OAuth tokens, and other credentials are stored in the encrypted **macOS Keychain**. No credentials are stored in plaintext on disk.

## Managed Permission Settings (Team Plan)

These settings are only available in `managed-settings.json`:

| Setting | Purpose |
|---------|---------|
| `allowManagedPermissionRulesOnly` | Block user/project permission rules — only managed rules apply |
| `allowManagedHooksOnly` | Block user, project, and plugin hooks |
| `strictKnownMarketplaces` | Restrict plugin marketplaces to an admin-approved list |
| `disableBypassPermissionsMode` | Set to `"disable"` to prevent bypass mode |

### Permissions + Sandboxing (Defense in Depth)

Permissions and [sandboxing](17-additional-features.md#sandbox-mode) are complementary layers. Permissions control which tools Claude can invoke and what specifiers are allowed. Sandboxing provides OS-level isolation for Bash commands that are permitted. Together they form a defense-in-depth strategy: permissions prevent unwanted actions; the sandbox limits damage if something unexpected executes.

## MCP Security

MCP servers are user-configured — Anthropic does not manage or audit third-party MCP servers. Only use MCP servers from trusted sources. Review server code and permissions before enabling.

Managed settings can control MCP server access:

```json
{
  "allowedMcpServers": ["github"],
  "deniedMcpServers": ["untrusted-server"]
}
```

## Platform Notes

**Windows (WebDAV)**: Be cautious with WebDAV-mapped drives. Claude Code may follow UNC paths to remote locations, potentially exposing file contents to untrusted servers. Restrict file access with deny rules if using WebDAV.

## Security Best Practices

1. **Never allow** `.env` file access in settings
2. **Use path-scoped security rules** for auth/payment code
3. **Audit hooks** — ensure they don't expose sensitive data
4. **Use admin policies** for organization-wide restrictions (Team Plan: configure via `managed-settings.json`; Individual Plans: use strict project-level deny rules)
5. **Review MCP servers** — only use trusted sources
6. **Monitor usage** — check for unexpected behavior with [OpenTelemetry monitoring](22-enterprise-admin.md#monitoring-opentelemetry)
7. **Regular audits** — review rule files periodically
8. **Check for warnings** — review unreachable rule warnings in `/permissions`

---

[← Previous: Best Practices](10-best-practices.md) | [Back to Guide](../README.md) | [Next: Troubleshooting →](12-troubleshooting.md)

# Part 4: Essential Configuration Files

## CLAUDE.md (Project Root)

Keep this **lean** - use `.claude/rules/` for detailed instructions.

```markdown
# Project: [Your Project Name]

## Overview
Brief description of what this project does and its architecture.

## Tech Stack
- Backend: Node.js with Express
- Frontend: React with TypeScript
- Database: PostgreSQL
- Infrastructure: AWS, Docker

## Quick Reference Commands
```bash
pnpm install         # Install dependencies
pnpm dev             # Start development server
pnpm test            # Run test suite
pnpm lint            # Run linting
pnpm build           # Production build
```

## Key Directories
- `/src/api/` - API routes and controllers
- `/src/components/` - React components
- `/src/models/` - Database models
- `/src/auth/` - Authentication (SECURITY CRITICAL)
- `/src/payments/` - Payment processing (SECURITY CRITICAL)

## Important Notes
- See `.claude/rules/` for detailed coding standards
- NEVER commit secrets to the repository
- Always run tests before pushing

## Individual Developer Preferences
@~/.claude/va-project-preferences.md
```

## Project Rules Examples

### `.claude/rules/code-style.md` (Always Loaded)

```markdown
# Code Style Standards

## Formatting
- Use 2-space indentation
- Maximum line length: 100 characters
- Use semicolons in JavaScript/TypeScript
- Use single quotes for strings

## Naming Conventions
- Components: PascalCase (e.g., `UserProfile`)
- Functions: camelCase (e.g., `getUserById`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `MAX_RETRY_COUNT`)
- Files: kebab-case (e.g., `user-profile.tsx`)

## Code Organization
- One component per file
- Group imports: external, internal, relative
- Export at bottom of file

## Documentation
- All public functions must have JSDoc comments
- Complex logic requires inline comments
- Update README when adding new features
```

### `.claude/rules/git-workflow.md` (Always Loaded)

```markdown
# Git Workflow Standards

## Branch Naming
- Features: `feature/TICKET-short-description`
- Bugs: `bugfix/TICKET-short-description`
- Hotfixes: `hotfix/TICKET-short-description`
- Releases: `release/v1.2.3`

## Commit Messages
Follow Conventional Commits format:
- `feat(scope): add new feature`
- `fix(scope): fix bug description`
- `docs(scope): update documentation`
- `refactor(scope): refactor code`
- `test(scope): add tests`
- `chore(scope): maintenance task`

## Workflow
1. Create branch from `main`
2. Make changes with atomic commits
3. Run `pnpm lint` and `pnpm test`
4. Push and create PR
5. Request review from at least 1 team member
6. Squash merge after approval

## IMPORTANT
- Never commit directly to `main`
- Always rebase before merging
- Delete branch after merge
```

### `.claude/rules/testing.md` (Always Loaded)

```markdown
# Testing Standards

## Requirements
- Minimum 80% code coverage for new code
- All business logic must have unit tests
- API endpoints require integration tests
- Critical paths need E2E tests

## Test Structure
- Use `describe` blocks for grouping
- Test names: "should [expected behavior] when [condition]"
- Follow AAA pattern: Arrange, Act, Assert

## Mocking
- Mock external services (APIs, databases)
- Use dependency injection for testability
- Reset mocks between tests

## Running Tests
```bash
pnpm test                 # Run all tests
pnpm test:unit            # Unit tests only
pnpm test:integration     # Integration tests
pnpm test:coverage        # With coverage report
```

## Before Committing
- Run full test suite
- Check coverage hasn't decreased
- Verify no skipped tests (.skip)
```

### `.claude/rules/security.md` (Path-Scoped)

```markdown
---
paths:
  - src/auth/**/*
  - src/payments/**/*
  - src/api/admin/**/*
  - "**/middleware/auth*"
---

# Security-Critical Code Rules

## MANDATORY for all changes to these files

### Input Validation
- Validate ALL inputs at function boundaries
- Use Zod schemas for runtime validation
- Never trust client-side validation alone

### Data Protection
- NEVER log sensitive data (passwords, tokens, card numbers, SSNs)
- Use parameterized queries - NO string concatenation for SQL
- Encrypt sensitive data at rest
- Hash passwords with bcrypt (min 12 rounds)

### Authentication & Authorization
- Require authentication checks on EVERY endpoint
- Verify authorization for resource access
- Use short-lived tokens (15 min access, 7 day refresh)
- Implement rate limiting on auth endpoints

### Logging & Monitoring
- Log all authentication attempts
- Include correlation IDs in all logs
- Never log request bodies containing credentials

## Before Committing Security Code
1. Run security scan: `pnpm security:check`
2. Verify no secrets in code: `pnpm scan:secrets`
3. Check for SQL injection: review all database queries
4. Peer review required for ALL security changes
```

### `.claude/rules/api-rules.md` (Path-Scoped)

```markdown
---
paths:
  - src/api/**/*
  - src/routes/**/*
  - src/controllers/**/*
---

# API Development Rules

## Endpoint Standards
- Use RESTful conventions
- Version APIs: `/api/v1/resource`
- Use plural nouns for resources: `/users`, `/orders`

## Request Handling
- Validate all inputs with Zod schemas
- Return appropriate HTTP status codes
- Include request ID in all responses

## Response Format
```json
{
  "success": true,
  "data": {},
  "meta": {
    "requestId": "uuid",
    "timestamp": "ISO-8601"
  }
}
```

## Error Format
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  },
  "meta": {
    "requestId": "uuid"
  }
}
```

## Documentation
- Add OpenAPI comments to all endpoints
- Include request/response examples
- Document all error codes
```

### `.claude/rules/frontend-rules.md` (Path-Scoped)

```markdown
---
paths:
  - src/components/**/*
  - src/pages/**/*
  - src/hooks/**/*
  - "**/*.tsx"
  - "**/*.jsx"
---

# Frontend Development Rules

## React Patterns
- Use functional components with hooks
- Prefer composition over inheritance
- Keep components under 200 lines
- Extract custom hooks for reusable logic

## State Management
- Use local state for component-specific data
- Use context for shared UI state
- Use React Query for server state

## Performance
- Memoize expensive calculations with useMemo
- Use useCallback for function props
- Lazy load routes and heavy components
- Avoid inline object/array creation in JSX

## Accessibility
- All images need alt text
- Use semantic HTML elements
- Ensure keyboard navigation works
- Test with screen reader

## Styling
- Use Tailwind CSS utility classes
- Extract repeated patterns to components
- Follow mobile-first approach
```

## .claude/settings.json (Team Shared)

```json
{
  "permissions": {
    "allow": [
      "Bash(pnpm *)",
      "Bash(pnpm test *)",
      "Bash(pnpm install)",
      "Bash(pnpm exec *)",
      "Bash(git *)",
      "Bash(gh *)",
      "Bash(docker *)",
      "Bash(docker-compose *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(grep *)",
      "Bash(find *)",
      "Bash(node *)",
      "Bash(curl *)",
      "Read(src/**)",
      "Read(test/**)",
      "Read(tests/**)",
      "Read(docs/**)",
      "Read(scripts/**)",
      "Edit(src/**)",
      "Edit(test/**)",
      "Edit(tests/**)",
      "WebFetch(domain:github.com)",
      "WebFetch(domain:stackoverflow.com)",
      "WebFetch(domain:npmjs.com)",
      "WebFetch(domain:developer.mozilla.org)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.*)",
      "Read(./**/*.key)",
      "Read(./**/*.pem)",
      "Read(./**/*.p12)",
      "Edit(./config/production/**)",
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(chmod 777 *)"
    ],
    "defaultMode": "default"
  },
  "env": {
    "NODE_ENV": "development"
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | { read file_path; if echo \"$file_path\" | grep -qE '\\.(ts|tsx|js)$'; then pnpm exec prettier --write \"$file_path\"; fi; }"
          }
        ]
      }
    ]
  },
  "attribution": {
    "commit": "Co-Authored-By: Claude <noreply@anthropic.com>"
  }
}
```

### Hook Events Reference

The hooks system supports 14 event types:

| Event | Trigger | Can block? |
|-------|---------|-----------|
| `SessionStart` | Session begins or resumes | No |
| `UserPromptSubmit` | User submits a prompt, before Claude processes it | Yes |
| `PreToolUse` | Before a tool call executes | Yes |
| `PermissionRequest` | When a permission dialog appears | Yes |
| `PostToolUse` | After a tool call succeeds | No |
| `PostToolUseFailure` | After a tool call fails | No |
| `Notification` | When Claude sends a notification | No |
| `SubagentStart` | When a subagent is spawned | No |
| `SubagentStop` | When a subagent finishes | Yes |
| `Stop` | When Claude finishes responding | Yes |
| `TeammateIdle` | Agent team member becomes idle | Yes |
| `TaskCompleted` | Task is being marked completed | Yes |
| `PreCompact` | Before context compaction | No |
| `SessionEnd` | Session terminates | No |

### Hook Handler Types

| Type | Description | Default timeout |
|------|-------------|----------------|
| `command` | Shell command; receives JSON on stdin, returns via exit codes/stdout | 600s |
| `prompt` | Single-turn LLM evaluation; returns yes/no JSON decision | 30s |
| `agent` | Multi-turn subagent with tools (Read, Grep, Glob) to verify conditions | 60s |

### Hook Handler Fields

| Field | Required | Description |
|-------|----------|-------------|
| `type` | Yes | `"command"`, `"prompt"`, or `"agent"` |
| `timeout` | No | Seconds before canceling |
| `statusMessage` | No | Custom spinner message |
| `once` | No | If `true`, runs only once per session (skills only) |
| `async` | No | (command only) If `true`, runs in background without blocking |

### SessionStart and `CLAUDE_ENV_FILE`

The `SessionStart` event supports a matcher to distinguish how the session started: `startup`, `resume`, `clear`, `compact`. Use `CLAUDE_ENV_FILE` (available in SessionStart hooks only) to persist environment variables:

```bash
echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
```

Use `/hooks` to browse and configure hooks interactively.

### MCP Configuration

#### Installing MCP Servers

```bash
# Remote HTTP server (recommended)
claude mcp add --transport http <name> <url>
claude mcp add --transport http notion https://mcp.notion.com/mcp
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"

# Local stdio server
claude mcp add --transport stdio --env API_KEY=YOUR_KEY my-server \
  -- npx -y my-mcp-server

# Add from JSON
claude mcp add-json weather '{"type":"http","url":"https://api.weather.com/mcp"}'

# Import from Claude Desktop
claude mcp add-from-claude-desktop

# Manage servers
claude mcp list
claude mcp get <name>
claude mcp remove <name>
/mcp  # Check server status and token costs
```

All options (`--transport`, `--env`, `--scope`, `--header`) must come before the server name. Use `--` to separate from command/args.

#### Installation Scopes

| Scope | Storage | Description |
|-------|---------|-------------|
| `local` | `~/.claude.json` (per-project) | Default. Private to you, current project only |
| `project` | `.mcp.json` in project root | Shared via version control |
| `user` | `~/.claude.json` | Available across all projects |

```bash
claude mcp add --transport http stripe --scope project https://mcp.stripe.com
```

#### Environment Variable Expansion in `.mcp.json`

Supports `${VAR}` and `${VAR:-default}` syntax in `command`, `args`, `env`, `url`, and `headers`:

```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

#### OAuth Authentication

```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
# Then use /mcp to authenticate

# Pre-configured OAuth credentials
claude mcp add --transport http \
  --client-id your-client-id --client-secret --callback-port 8080 \
  my-server https://mcp.example.com/mcp
```

#### MCP Resources and Prompts

Reference MCP resources with `@` mentions:
```
> Analyze @github:issue://123 and suggest a fix
> Compare @postgres:schema://users with @docs:file://database/user-model
```

MCP prompts are discovered dynamically as commands: `/mcp__server__prompt`

#### Tool Search

Auto-enabled when MCP tool descriptions exceed 10% of context window. Customize globally via `ENABLE_TOOL_SEARCH`:

| Value | Behavior |
|-------|----------|
| `auto` | Activates when tools exceed 10% of context (default) |
| `auto:N` | Custom threshold (e.g., `auto:5` for 5%) |
| `true` | Always enabled |
| `false` | Disabled, all tools loaded upfront |

Per-server configuration:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "my-mcp-server",
      "toolSearch": "auto:25"
    }
  }
}
```

#### Output Limits

MCP tool responses are limited to 25,000 tokens (warning at 10,000). Override with `MAX_MCP_OUTPUT_TOKENS`.

#### Managed MCP

**Option 1: Exclusive control** via `managed-mcp.json` at system paths:
- **macOS**: `/Library/Application Support/ClaudeCode/managed-mcp.json`
- **Linux/WSL**: `/etc/claude-code/managed-mcp.json`
- **Windows**: `C:\Program Files\ClaudeCode\managed-mcp.json`

**Option 2: Policy-based control** via managed settings:

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem"] },
    { "serverUrl": "https://mcp.company.com/*" },
    { "serverUrl": "https://*.internal.corp/*" }
  ],
  "deniedMcpServers": [
    { "serverName": "dangerous-server" },
    { "serverUrl": "https://*.untrusted.com/*" }
  ]
}
```

Allowlist behavior: `undefined` = no restrictions, `[]` = complete lockdown, list = only matching servers allowed. **Denylist takes absolute precedence.**

**Additional MCP settings:**

```json
{
  "enableAllProjectMcpServers": false,
  "enabledMcpjsonServers": ["github", "memory"],
  "disabledMcpjsonServers": ["filesystem"]
}
```

**Claude as MCP server**: Run `claude mcp serve` to expose Claude Code as an MCP server for other tools.

**Strict mode**: Use `--strict-mcp-config` to only load MCP servers from `--mcp-config` files.

**Windows note**: Use `cmd /c` wrapper for npx commands: `claude mcp add --transport stdio my-server -- cmd /c npx -y @some/package`

### Status Line Variables (v2.1.6+)

Custom status lines can use these context window variables:

- `context_window.used_percentage` — percentage of context window consumed
- `context_window.remaining_percentage` — percentage of context window remaining

## Model Configuration

### Model Aliases

| Alias | Behavior |
|-------|----------|
| `default` | Recommended model for your account type (Opus 4.6 for Max/Teams/Pro) |
| `sonnet` | Latest Sonnet model for daily coding tasks |
| `opus` | Latest Opus model for complex reasoning |
| `haiku` | Fast, efficient Haiku model for simple tasks |
| `sonnet[1m]` | Sonnet with 1 million token context window |
| `opusplan` | Uses `opus` during plan mode, switches to `sonnet` for execution |

Aliases always point to the latest version. To pin a specific version, use the full model name (e.g., `claude-opus-4-5-20251101`).

### Setting the Model

1. **During session** — `/model <alias|name>`
2. **At startup** — `claude --model <alias|name>`
3. **Environment variable** — `ANTHROPIC_MODEL=<alias|name>`
4. **Settings** — `model` field in settings file

### Effort Levels

Three levels: **low**, **medium**, and **high** (default). Controls Opus 4.6's adaptive reasoning.

- **In `/model`**: use left/right arrow keys to adjust the effort slider
- **Environment variable**: `CLAUDE_CODE_EFFORT_LEVEL=low|medium|high`
- **Settings**: set `effortLevel` in your settings file

### Model Override Environment Variables

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Model for `opus` alias, or `opusplan` in plan mode |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Model for `sonnet` alias, or `opusplan` in execution mode |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Model for `haiku` alias and background functionality |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model for subagents |

### Prompt Caching

| Variable | Description |
|----------|-------------|
| `DISABLE_PROMPT_CACHING` | Set `1` to disable for all models (takes precedence) |
| `DISABLE_PROMPT_CACHING_HAIKU` | Set `1` to disable for Haiku only |
| `DISABLE_PROMPT_CACHING_SONNET` | Set `1` to disable for Sonnet only |
| `DISABLE_PROMPT_CACHING_OPUS` | Set `1` to disable for Opus only |

## Complete Settings Reference

Settings files support a JSON schema for editor autocompletion:

```json
{ "$schema": "https://json.schemastore.org/claude-code-settings.json" }
```

| Setting | Description | Example |
|---------|-------------|---------|
| `apiKeyHelper` | Custom script to generate auth value | `"/bin/generate_temp_api_key.sh"` |
| `cleanupPeriodDays` | Days before inactive sessions are deleted (default: 30) | `20` |
| `companyAnnouncements` | Announcements displayed at startup (managed only) | `["Upgrade by Friday"]` |
| `env` | Environment variables for every session | `{"NODE_ENV": "development"}` |
| `effortLevel` | Opus 4.6 reasoning effort: `low`, `medium`, `high` | `"high"` |
| `attribution` | Customize git commit and PR attribution | See attribution section below |
| `permissions` | Configure allow/ask/deny rules for tools | See permissions section |
| `hooks` | Custom commands before/after tool executions | See hooks section |
| `disableAllHooks` | Disable all hooks and status line | `true` |
| `allowManagedHooksOnly` | (Managed only) Prevent user/project/plugin hooks | `true` |
| `allowManagedPermissionRulesOnly` | (Managed only) Only managed permission rules apply | `true` |
| `model` | Override default model | `"claude-sonnet-4-5-20250929"` |
| `otelHeadersHelper` | Script for dynamic OpenTelemetry headers | `"/bin/otel-headers.sh"` |
| `language` | Configure Claude's response language (v2.1+) | `"ja"` (Japanese), `"es"` (Spanish) |
| `respectGitignore` | Control whether file picker respects .gitignore (v2.1+) | `true` |
| `statusLine` | Configure custom status line display | `{"type": "command", "command": "..."}` |
| `fileSuggestion` | Custom script for `@` file autocomplete | `{"type": "command", "command": "..."}` |
| `outputStyle` | Configure output style | `"Explanatory"` |
| `forceLoginMethod` | Restrict login to `claudeai` or `console` | `"claudeai"` |
| `forceLoginOrgUUID` | Auto-select organization during login | `"uuid-here"` |
| `enableAllProjectMcpServers` | Auto-approve all MCP servers in `.mcp.json` | `true` |
| `enabledMcpjsonServers` | Whitelist specific `.mcp.json` servers | `["memory", "github"]` |
| `disabledMcpjsonServers` | Blacklist specific `.mcp.json` servers | `["filesystem"]` |
| `allowedMcpServers` | (Managed) MCP server allowlist | `["github"]` |
| `deniedMcpServers` | (Managed) MCP server denylist | `["filesystem"]` |
| `strictKnownMarketplaces` | (Managed) Plugin marketplace allowlist | See plugins doc |
| `alwaysThinkingEnabled` | Enable extended thinking by default | `true` |
| `awsAuthRefresh` | Custom script to refresh AWS credentials | `"aws sso login --profile myprofile"` |
| `awsCredentialExport` | Script outputting AWS credentials as JSON | `"/bin/generate_aws_grant.sh"` |
| `attribution` | Git commit and PR attribution (replaces `includeCoAuthoredBy`) | See attribution section |
| `spinnerVerbs` | Customize spinner verb text (v2.1.23+) | `{"mode": "append", "verbs": [...]}` |
| `showTurnDuration` | Show/hide turn duration messages (v2.1.7+) | `false` |
| `plansDirectory` | Custom directory for plan file storage (v2.1.9+) | `".claude/plans"` |
| `prefersReducedMotion` | Disable UI animations (v2.1.30+) | `true` |
| `terminalProgressBarEnabled` | Enable terminal progress bar (default: true) | `false` |
| `spinnerTipsEnabled` | Show tips in spinner (default: true) | `false` |
| `autoUpdatesChannel` | Release channel: `stable` or `latest` (default: `latest`) | `"stable"` |
| `teammateMode` | Agent team display: `auto`, `in-process`, or `tmux` | `"tmux"` |

### Attribution Settings

Customize git commit and PR attribution:

```json
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@company.com>",
    "pr": "Generated with AI"
  }
}
```

### File Suggestion Settings

Custom `@` file autocomplete:

```json
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

---

[← Previous: Directory Structure](03-directory-structure.md) | [Back to Guide](../README.md) | [Next: Slash Commands →](05-slash-commands.md)

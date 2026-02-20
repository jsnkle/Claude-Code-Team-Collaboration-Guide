# Part 21: Enterprise & Team Administration

This doc covers infrastructure topics for Team and Enterprise plan administrators: authentication, LLM gateways, network configuration, monitoring, and analytics.

> **Individual Plan users:** Most of this doc applies to Team/Enterprise plans. The LLM gateway and network config sections are relevant if you use Bedrock, Vertex, or a custom proxy.

## Authentication

### Authentication Methods

| Method | Best for | Key features |
|--------|----------|-------------|
| **Claude for Teams** | Smaller teams | Collaboration, admin tools, billing management |
| **Claude for Enterprise** | Large orgs | SSO, domain capture, role-based permissions, compliance API, managed policies |
| **Claude Console** | API-based billing | Per-user API keys, role assignment (Claude Code or Developer) |
| **Amazon Bedrock** | AWS-native teams | IAM-based auth, existing AWS billing |
| **Google Vertex AI** | GCP-native teams | WIF-based auth, existing GCP billing |
| **Microsoft Foundry** | Azure-native teams | Azure auth integration |

### Teams/Enterprise Setup

1. Subscribe to [Claude for Teams](https://claude.com/pricing) or contact sales for Enterprise
2. Invite team members from the admin dashboard
3. Team members install Claude Code and log in with their Claude.ai accounts

### Console Setup (API-Based)

1. Invite users from Console (Settings > Members > Invite)
2. Assign roles:
   - **Claude Code** role: users can only create Claude Code API keys
   - **Developer** role: users can create any kind of API key
3. Each user accepts the invite, installs Claude Code, and logs in with Console credentials

### Cloud Provider Setup

Configure environment variables and credentials per your provider's documentation (Bedrock, Vertex, or Foundry), then distribute via `managed-settings.json` or team documentation.

### Credential Management

- **macOS**: API keys and OAuth tokens stored in the encrypted macOS Keychain
- **Custom scripts**: Use the `apiKeyHelper` setting to run a shell script that returns an API key
- **Refresh intervals**: `apiKeyHelper` is called after 5 minutes or on HTTP 401. Customize with `CLAUDE_CODE_API_KEY_HELPER_TTL_MS`

```json
{
  "apiKeyHelper": "~/bin/get-api-key.sh"
}
```

### Login Restrictions

Restrict authentication methods via managed settings:

```json
{
  "forceLoginMethod": "claudeai",
  "forceLoginOrgUUID": "your-org-uuid"
}
```

## LLM Gateway

LLM gateways provide a centralized proxy layer for authentication, usage tracking, cost controls, audit logging, and model routing.

### Gateway Requirements

The gateway must expose at least one of these API formats:

| Format | Endpoints | Header/field requirements |
|--------|-----------|--------------------------|
| **Anthropic Messages** | `/v1/messages`, `/v1/messages/count_tokens` | Forward `anthropic-beta`, `anthropic-version` headers |
| **Bedrock InvokeModel** | `/invoke`, `/invoke-with-response-stream` | Preserve `anthropic_beta`, `anthropic_version` body fields |
| **Vertex rawPredict** | `:rawPredict`, `:streamRawPredict` | Forward `anthropic-beta`, `anthropic-version` headers |

> Failure to forward headers/fields may result in reduced functionality.

### Configuration

```bash
# Point Claude Code at your gateway
export ANTHROPIC_BASE_URL=https://gateway.company.com

# Static auth token
export ANTHROPIC_AUTH_TOKEN=sk-your-token

# Or dynamic auth via helper script
# (apiKeyHelper has lower precedence than ANTHROPIC_AUTH_TOKEN)
```

### LiteLLM Integration

> LiteLLM is a third-party proxy. Anthropic doesn't maintain or audit it.

**Unified endpoint (recommended):**

```bash
export ANTHROPIC_BASE_URL=https://litellm-server:4000
```

**Provider-specific pass-through:**

```bash
# Bedrock through LiteLLM
export ANTHROPIC_BEDROCK_BASE_URL=https://litellm-server:4000/bedrock
export CLAUDE_CODE_SKIP_BEDROCK_AUTH=1
export CLAUDE_CODE_USE_BEDROCK=1

# Vertex through LiteLLM
export ANTHROPIC_VERTEX_BASE_URL=https://litellm-server:4000/vertex_ai/v1
export ANTHROPIC_VERTEX_PROJECT_ID=your-gcp-project-id
export CLAUDE_CODE_SKIP_VERTEX_AUTH=1
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
```

**Dynamic auth with helper script:**

```bash
#!/bin/bash
# ~/bin/get-litellm-key.sh
vault kv get -field=api_key secret/litellm/claude-code
```

```json
{
  "apiKeyHelper": "~/bin/get-litellm-key.sh"
}
```

Set `CLAUDE_CODE_API_KEY_HELPER_TTL_MS=3600000` for hourly refresh.

> When using Anthropic Messages format with Bedrock or Vertex, you may need to set `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`.

## Network Configuration

### Proxy Setup

```bash
# HTTPS proxy (recommended)
export HTTPS_PROXY=https://proxy.example.com:8080

# HTTP proxy
export HTTP_PROXY=http://proxy.example.com:8080

# Bypass proxy (space or comma-separated)
export NO_PROXY="localhost 192.168.1.1 example.com .example.com"

# Basic auth
export HTTPS_PROXY=http://username:password@proxy.example.com:8080
```

> Claude Code does not support SOCKS proxies. For proxies requiring NTLM/Kerberos, use an LLM Gateway.

### Custom CA Certificates

```bash
export NODE_EXTRA_CA_CERTS=/path/to/ca-cert.pem
```

### mTLS Authentication

```bash
export CLAUDE_CODE_CLIENT_CERT=/path/to/client-cert.pem
export CLAUDE_CODE_CLIENT_KEY=/path/to/client-key.pem
export CLAUDE_CODE_CLIENT_KEY_PASSPHRASE="your-passphrase"  # optional
```

### Required Domain Allowlist

Claude Code requires access to these URLs:

| URL | Purpose |
|-----|---------|
| `api.anthropic.com` | Claude API endpoints |
| `claude.ai` | WebFetch safeguards |
| `statsig.anthropic.com` | Telemetry and metrics |
| `sentry.io` | Error reporting |

## Server-Managed Settings (Public Beta)

Server-managed settings allow admins to push configuration changes to Claude Code installations remotely, without requiring changes to local files. See the [official docs](https://code.claude.com/docs/en/server-managed-settings) for setup and configuration.

## Configuration Change Auditing (v2.1.49+)

The `ConfigChange` hook event fires when settings are modified, enabling centralized audit logging:

```json
{
  "hooks": {
    "ConfigChange": [{
      "type": "command",
      "command": "/path/to/audit-config-change.sh"
    }]
  }
}
```

Deploy this in `managed-settings.json` to track all configuration changes across the team. See [Security: ConfigChange Hook](11-security.md#configchange-hook-v2149) for details.

## Monitoring (OpenTelemetry)

Claude Code exports metrics and events via OpenTelemetry for usage tracking, cost monitoring, and observability.

### Quick Start

```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

### Managed Settings Deployment

```json
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "grpc",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://collector.company.com:4317",
    "OTEL_EXPORTER_OTLP_HEADERS": "Authorization=Bearer company-token"
  }
}
```

### Available Metrics

| Metric | Description | Unit |
|--------|-------------|------|
| `claude_code.session.count` | CLI sessions started | count |
| `claude_code.lines_of_code.count` | Lines of code modified (attribute: `type` = added/removed) | count |
| `claude_code.pull_request.count` | Pull requests created | count |
| `claude_code.commit.count` | Git commits created | count |
| `claude_code.cost.usage` | Session cost (attribute: `model`) | USD |
| `claude_code.token.usage` | Tokens used (attributes: `type`, `model`) | tokens |
| `claude_code.code_edit_tool.decision` | Edit permission decisions (attributes: `tool`, `decision`, `language`) | count |
| `claude_code.active_time.total` | Total active time | seconds |

### Available Events

Events are exported via OTel's logs/events protocol when `OTEL_LOGS_EXPORTER` is configured:

| Event | Key fields |
|-------|-----------|
| `claude_code.user_prompt` | `prompt_length`, `prompt` (redacted by default; enable with `OTEL_LOG_USER_PROMPTS=1`) |
| `claude_code.tool_result` | `tool_name`, `success`, `duration_ms`, `decision`, `source` |
| `claude_code.api_request` | `model`, `cost_usd`, `duration_ms`, `input_tokens`, `output_tokens` |
| `claude_code.api_error` | `model`, `error`, `status_code`, `attempt` |
| `claude_code.tool_decision` | `tool_name`, `decision`, `source` |

### Dynamic OTel Headers

```json
{
  "otelHeadersHelper": "/bin/generate_opentelemetry_headers.sh"
}
```

The script must output valid JSON with string key-value pairs. Runs at startup, then refreshes every 29 minutes (customize with `CLAUDE_CODE_OTEL_HEADERS_HELPER_DEBOUNCE_MS`).

### Multi-Team Segmentation

```bash
export OTEL_RESOURCE_ATTRIBUTES="department=engineering,team.id=platform,cost_center=eng-123"
```

Values must follow W3C Baggage specification: no spaces, comma-separated `key=value` pairs, US-ASCII only. Use percent-encoding for special characters.

### Cardinality Control

| Variable | Description | Default |
|----------|-------------|---------|
| `OTEL_METRICS_INCLUDE_SESSION_ID` | Include `session.id` attribute | `true` |
| `OTEL_METRICS_INCLUDE_VERSION` | Include `app.version` attribute | `false` |
| `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` | Include `user.account_uuid` attribute | `true` |

### Privacy

- Telemetry is opt-in and requires explicit `CLAUDE_CODE_ENABLE_TELEMETRY=1`
- User prompt content redacted by default (only `prompt_length` recorded)
- MCP server/tool names not logged by default (enable with `OTEL_LOG_TOOL_DETAILS=1`)

## Analytics Dashboards

### Dashboard Access

| Plan | Dashboard URL | Includes |
|------|--------------|----------|
| Teams / Enterprise | `claude.ai/analytics/claude-code` | Usage, contribution metrics (GitHub), leaderboard, CSV export |
| API (Console) | `platform.claude.com/claude-code` | Usage, spend tracking, team insights |

### Teams/Enterprise Metrics

| Metric | Description |
|--------|-------------|
| **PRs with CC** | Merged PRs containing Claude Code-assisted lines |
| **Lines of code with CC** | Effective lines written with Claude Code across merged PRs |
| **PRs with Claude Code (%)** | Percentage of merged PRs with CC-assisted code |
| **Suggestion accept rate** | Percentage of Edit/Write/NotebookEdit suggestions accepted |
| **Lines of code accepted** | Total accepted lines (excludes rejected) |

### Dashboard Charts

| Chart | Description |
|-------|-------------|
| **Adoption** | Daily active users and sessions |
| **PRs per user** | PRs merged per day / daily active users |
| **Pull requests breakdown** | Daily merged PRs split into "with CC" vs "without CC"; toggleable to Lines of code view |
| **Leaderboard** | Top 10 users by contribution volume; toggleable between PRs and lines of code |

Use **Export all users** to download CSV with complete contribution data for all users (not just the top 10).

### Enable Contribution Metrics

1. GitHub admin installs the [Claude GitHub App](https://github.com/apps/claude)
2. Claude Owner navigates to `claude.ai/admin-settings/claude-code` and enables analytics
3. Enable the "GitHub analytics" toggle
4. Complete GitHub authentication flow

Data appears within 24 hours with daily updates. Supports GitHub Cloud and GitHub Enterprise Server.

> Contribution metrics are not available for organizations with Zero Data Retention enabled.

### PR Attribution

PRs are tagged as "with Claude Code" if they contain at least one line written during a Claude Code session. Merged PRs are labeled `claude-code-assisted` in GitHub.

**Attribution rules:**
- Sessions from 21 days before to 2 days after PR merge are considered
- Code substantially rewritten by developers (>20% difference) is not attributed
- Auto-generated files (lock files, build output) are excluded
- Lines over 1,000 characters are excluded

### Console Metrics (API Customers)

The Console dashboard (`platform.claude.com/claude-code`) shows:
- Lines of code accepted / suggestion accept rate
- Daily active users and sessions
- Daily API costs
- Per-user spend and lines this month

> Contribution metrics with GitHub integration are **not** currently available for API customers. The Console dashboard shows usage and spend metrics only.

### Programmatic Access

Query attribution data programmatically by searching for PRs labeled `claude-code-assisted` in GitHub.

---

[← Previous: CI/CD Automation](20-cicd-automation.md) | [Back to Guide](../README.md) | [Next: Resources →](22-resources.md)

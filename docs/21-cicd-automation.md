# Part 19: CI/CD Automation

Claude Code integrates with GitHub Actions and GitLab CI/CD to bring AI-powered automation to pull requests, issues, and merge requests.

## GitHub Actions

The official GitHub Action (`anthropics/claude-code-action@v1`) enables `@claude` mentions in PRs and issues.

### Quick Setup

1. Run `/install-github-app` in Claude Code to install the GitHub app and configure secrets
2. Or manually: install the [Claude GitHub App](https://github.com/apps/claude), add `ANTHROPIC_API_KEY` to repository secrets, and copy the workflow file

### Basic Workflow

```yaml
name: Claude Code
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
jobs:
  claude:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Using Skills in CI

```yaml
name: Code Review
on:
  pull_request:
    types: [opened, synchronize]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "/review"
          claude_args: "--max-turns 5"
```

### Action Parameters

| Parameter | Description | Required |
|-----------|-------------|----------|
| `prompt` | Instructions for Claude (text or skill like `/review`) | No |
| `claude_args` | CLI arguments passed to Claude Code | No |
| `anthropic_api_key` | Claude API key | Yes* |
| `github_token` | GitHub token for API access | No |
| `trigger_phrase` | Custom trigger phrase (default: `@claude`) | No |
| `use_bedrock` | Use AWS Bedrock instead of Claude API | No |
| `use_vertex` | Use Google Vertex AI instead of Claude API | No |

*Required for direct Claude API; not required for Bedrock/Vertex.

### Common CLI Arguments

Pass via `claude_args`:

```yaml
claude_args: "--max-turns 5 --model claude-sonnet-4-5-20250929 --mcp-config /path/to/config.json"
```

- `--max-turns`: Maximum conversation turns (default: 10)
- `--model`: Model to use
- `--mcp-config`: Path to MCP configuration
- `--allowed-tools`: Comma-separated list of allowed tools
- `--append-system-prompt`: Custom instructions
- `--debug`: Enable debug output

### AWS Bedrock Setup

Requires OIDC Identity Provider configured in AWS for GitHub Actions:

```yaml
name: Claude PR Action
permissions:
  contents: write
  pull-requests: write
  issues: write
  id-token: write
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, assigned]
jobs:
  claude-pr:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'issues' && contains(github.event.issue.body, '@claude'))
    runs-on: ubuntu-latest
    env:
      AWS_REGION: us-west-2
    steps:
      - uses: actions/checkout@v4
      - id: app-token
        uses: actions/create-github-app-token@v2
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
          aws-region: us-west-2
      - uses: anthropics/claude-code-action@v1
        with:
          github_token: ${{ steps.app-token.outputs.token }}
          use_bedrock: "true"
          claude_args: '--model us.anthropic.claude-sonnet-4-5-20250929-v1:0 --max-turns 10'
```

Bedrock model IDs include region prefixes and version suffixes (e.g., `us.anthropic.claude-sonnet-4-5-20250929-v1:0`).

### Google Vertex AI Setup

Requires Workload Identity Federation configured for GitHub Actions:

```yaml
name: Claude PR Action
permissions:
  contents: write
  pull-requests: write
  issues: write
  id-token: write
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, assigned]
jobs:
  claude-pr:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'issues' && contains(github.event.issue.body, '@claude'))
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - id: app-token
        uses: actions/create-github-app-token@v2
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}
      - id: auth
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}
      - uses: anthropics/claude-code-action@v1
        with:
          github_token: ${{ steps.app-token.outputs.token }}
          trigger_phrase: "@claude"
          use_vertex: "true"
          claude_args: '--model claude-sonnet-4@20250514 --max-turns 10'
        env:
          ANTHROPIC_VERTEX_PROJECT_ID: ${{ steps.auth.outputs.project_id }}
          CLOUD_ML_REGION: us-east5
```

### Custom GitHub App

For organizations needing branded usernames or custom auth flows, create a custom GitHub App:

1. Go to GitHub Settings > Developer Settings > GitHub Apps > New
2. Set repository permissions: Contents (R&W), Issues (R&W), Pull requests (R&W)
3. Uncheck "Active" under Webhooks
4. Generate a private key and note the App ID
5. Add the private key as `APP_PRIVATE_KEY` and App ID as `APP_ID` in repository secrets
6. Use `actions/create-github-app-token@v2` to generate authentication tokens

## GitLab CI/CD (Beta)

GitLab CI/CD integration is maintained by GitLab and runs Claude Code in your GitLab pipelines. Support: [GitLab issue #573776](https://gitlab.com/gitlab-org/gitlab/-/issues/573776).

### Basic Pipeline

```yaml
stages:
  - ai

claude:
  stage: ai
  image: node:24-alpine3.21
  rules:
    - if: '$CI_PIPELINE_SOURCE == "web"'
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
  variables:
    GIT_STRATEGY: fetch
  before_script:
    - apk update
    - apk add --no-cache git curl bash
    - curl -fsSL https://claude.ai/install.sh | bash
  script:
    - /bin/gitlab-mcp-server || true
    - >
      claude
      -p "${AI_FLOW_INPUT:-'Review this MR and implement the requested changes'}"
      --permission-mode acceptEdits
      --allowedTools "Bash Read Edit Write mcp__gitlab"
      --debug
```

**Required CI/CD variables:** `ANTHROPIC_API_KEY` (masked, protected as needed).

### Trigger Mechanism

GitLab uses `AI_FLOW_*` variables to pass context:
- `AI_FLOW_INPUT`: The instruction or comment text
- `AI_FLOW_CONTEXT`: Reference to the MR or issue
- `AI_FLOW_EVENT`: The event type that triggered the pipeline

To enable `@claude` mention-driven triggers, add a project webhook for "Comments (notes)" that calls the pipeline trigger API with these variables.

### Bedrock via GitLab

```yaml
claude-bedrock:
  stage: ai
  image: node:24-alpine3.21
  before_script:
    - apk add --no-cache bash curl jq git python3 py3-pip
    - pip install --no-cache-dir awscli
    - curl -fsSL https://claude.ai/install.sh | bash
    - export AWS_WEB_IDENTITY_TOKEN_FILE="${CI_JOB_JWT_FILE:-/tmp/oidc_token}"
    - if [ -n "${CI_JOB_JWT_V2}" ]; then printf "%s" "$CI_JOB_JWT_V2" > "$AWS_WEB_IDENTITY_TOKEN_FILE"; fi
    - >
      aws sts assume-role-with-web-identity
      --role-arn "$AWS_ROLE_TO_ASSUME"
      --role-session-name "gitlab-claude-$(date +%s)"
      --web-identity-token "file://$AWS_WEB_IDENTITY_TOKEN_FILE"
      --duration-seconds 3600 > /tmp/aws_creds.json
    - export AWS_ACCESS_KEY_ID="$(jq -r .Credentials.AccessKeyId /tmp/aws_creds.json)"
    - export AWS_SECRET_ACCESS_KEY="$(jq -r .Credentials.SecretAccessKey /tmp/aws_creds.json)"
    - export AWS_SESSION_TOKEN="$(jq -r .Credentials.SessionToken /tmp/aws_creds.json)"
  script:
    - /bin/gitlab-mcp-server || true
    - >
      claude
      -p "${AI_FLOW_INPUT:-'Implement the requested changes and open an MR'}"
      --permission-mode acceptEdits
      --allowedTools "Bash Read Edit Write mcp__gitlab"
      --debug
  variables:
    AWS_REGION: "us-west-2"
```

## CLAUDE.md in CI

Your `CLAUDE.md` and `.claude/` configuration apply in CI just like local development. Define coding standards, review criteria, and project-specific rules that Claude follows when responding to `@claude` mentions or running automated tasks.

## Comparison

| Aspect | GitHub Actions | GitLab CI/CD |
|--------|---------------|--------------|
| Maturity | GA (v1.0) | Beta |
| Maintained by | Anthropic | GitLab |
| Action / Job | `anthropics/claude-code-action@v1` | Custom job in `.gitlab-ci.yml` |
| Quick setup | `/install-github-app` CLI command | Manual (CI/CD variable + job) |
| Auth app | Claude GitHub App or custom | `CI_JOB_TOKEN` or Project Access Token |
| Container image | Handled by the action | Must specify (e.g., `node:24-alpine3.21`) |
| Claude install | Handled by the action | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Trigger | Native event triggers | `AI_FLOW_*` variables via webhook/API |
| MCP server | Optional via `--mcp-config` | `/bin/gitlab-mcp-server` (GitLab MCP) |

## Migrating from Beta to v1 (GitHub Actions)

If you previously used `anthropics/claude-code-action@beta`, update to `@v1` with these input changes:

| Old Beta Input | New v1 Input |
|---|---|
| `mode` | Removed (auto-detected from event context) |
| `direct_prompt` | `prompt` |
| `override_prompt` | `prompt` with GitHub context variables |
| `custom_instructions` | `claude_args: --append-system-prompt "..."` |
| `max_turns` | `claude_args: --max-turns N` |
| `model` | `claude_args: --model <name>` |
| `allowed_tools` | `claude_args: --allowedTools "..."` |
| `disallowed_tools` | `claude_args: --disallowedTools "..."` |
| `claude_env` | `settings` JSON format |

## Cost & Security Best Practices

- **Never commit API keys** — use repository/CI secrets
- **Use OIDC** where possible (no long-lived credentials)
- **Set `--max-turns`** to control API costs per invocation
- **Set `--max-budget-usd`** to cap spending per run (e.g., `claude -p --max-budget-usd 5.00 "..."`)
- **Use `--fallback-model`** for reliability when the default model is overloaded
- **Configure workflow timeouts** to prevent runaway runs
- **Review AI-generated PRs/MRs** like any other contributor
- **Use concurrency controls** to limit parallel runs

---

[← Previous: Agent Teams](20-agent-teams.md) | [Back to Guide](../README.md) | [Next: Enterprise Admin →](22-enterprise-admin.md)

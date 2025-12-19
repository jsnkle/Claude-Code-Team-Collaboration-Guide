# Claude Code Team Onboarding & Collaboration Guide

## Executive Summary

This guide provides a comprehensive game plan for deploying Claude Code across a small team. It covers the latest feature sets (as of v2.0.73), recommended directory structures, project rules, slash commands, and configurations that support effective team collaboration.

---

## Part 1: Claude Code Feature Overview (v2.0.73)

### Core Features

| Feature | Purpose | Scope |
|---------|---------|-------|
| **CLAUDE.md** | Project context & instructions loaded at startup | Project/User/Enterprise |
| **Project Rules** | Modular, path-scoped instruction files in `.claude/rules/` | Project/User |
| **settings.json** | Permissions, environment variables, tool behavior | Project/User/Enterprise |
| **Slash Commands** | Reusable prompt templates triggered with `/` | Project/User |
| **Subagents** | Specialized AI assistants with isolated context | Project/User |
| **Skills** | Auto-loading procedural knowledge based on task context | Project/User |
| **Hooks** | Shell commands triggered at lifecycle events | Project/User |
| **Plugins** | Bundled packages of commands, agents, hooks | Marketplace/Custom |
| **MCP Servers** | External tool integrations (GitHub, Jira, etc.) | Project/User |
| **Checkpoints** | Automatic code state snapshots for `/rewind` recovery | Session |
| **Output Styles** | Modify Claude's behavior (Default, Explanatory, Learning) | Project/User |
| **VS Code Extension** | Native IDE integration with inline diffs and plan mode | IDE |

### Key v2.0+ Features

| Feature | Description |
|---------|-------------|
| **Checkpoints & /rewind** | Automatically saves code state before each edit. Use `Esc+Esc` or `/rewind` to restore code, conversation, or both to any previous point. |
| **Plan Mode** | Toggle with `Shift+Tab`. Claude creates a plan before executing, allowing review and feedback. |
| **Extended Thinking** | Toggle with `Alt+T` (sticky across sessions). Claude shows reasoning process. Say "think" or "ultrathink" for deeper reasoning. Enabled by default for Opus 4.5. |
| **History Search** | `Ctrl+R` to search through prompt history across sessions. |
| **Output Styles** | `/output-style` to switch between Default, Explanatory (educational insights), or Learning (collaborative coding). |
| **VS Code Extension** | Native extension with sidebar panel, inline diffs, plan mode editing, and auto-accept. |
| **Named Sessions** | `/rename` to name sessions, `/resume <n>` or `claude --resume <n>` to resume specific sessions. |
| **Background Agents** | Start messages with `&` to send background tasks. Agents run while you work. |
| **Background Commands** | `Ctrl+B` to run any bash command in background (great for dev servers, log tailing). |
| **Explore Subagent** | Powered by Haiku, efficiently searches codebase to save context. |
| **Plugin System** | `/plugin install`, `/plugin marketplace` - Extend with custom commands, agents, hooks, MCP servers. |
| **Sandbox Mode** | Bash sandboxing on Linux/Mac for safer command execution. |
| **Web Search** | Claude can search the web for current information. |
| **Image Support** | Paste images directly into prompt (`Ctrl+V` or drag-and-drop). Clickable image links open in default viewer. |
| **Chrome Extension** | Control your browser directly from Claude Code with Claude in Chrome (Beta). |
| **Prompt Suggestions** | Claude suggests follow-up prompts. Press `Enter` to accept immediately, `Tab` to edit first. Toggle in `/config`. |
| **Model Switching** | Switch models while typing with `Alt+P` (Option+P on Mac). |
| **Yank-Pop (Kill Ring)** | `Alt+Y` cycles through previously deleted text (readline-style kill ring). |
| **Plugin Search** | Search and filter plugins in the discovery screen (`/plugin`). |
| **Custom Session IDs** | Fork sessions with custom IDs using `--fork-session` flag. |
| **/usage** | Check subscription plan usage limits (% remaining). |
| **/stats** | View usage statistics, graphs, and streaks. |
| **/export** | Export conversation for sharing. |
| **/doctor** | Diagnose and fix configuration issues. |
| **/context** | Visualize current context usage. |
| **/compact** | Compress conversation to save context space. |
| **/permissions** | Manage tool permissions with search and filtering. |
| **/add-dir** | Add additional working directories to session. |
| **/todos** | List all TODO items Claude is tracking. |
| **/statusline** | Customize terminal status line display. |

### Memory & Configuration Hierarchy

Claude Code uses a hierarchical system where higher levels take precedence:

| Level | Memory Location | Settings Location | Shared With |
|-------|-----------------|-------------------|-------------|
| **1. Enterprise** | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | `managed-settings.json` | All org users |
| **2. User** | `~/.claude/CLAUDE.md` | `~/.claude/settings.json` | Just you (all projects) |
| **3. Project** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | `./.claude/settings.json` | Team via git |
| **4. Project Local** | `./CLAUDE.local.md` | `./.claude/settings.local.json` | Just you (this project) |

**Note:** Project rules (`.claude/rules/`) load with the same priority as `.claude/CLAUDE.md`.

---

## Part 2: Project Rules System

### Overview

The `.claude/rules/` directory allows you to organize project instructions into **modular, focused rule files** instead of one large CLAUDE.md. This is ideal for teams managing complex codebases.

### Key Benefits

- **Separation of Concerns** - Update security rules without touching styling guidelines
- **Path-Scoped Activation** - Rules only load when working on matching files
- **Reduced Token Usage** - Irrelevant rules stay out of context
- **Team Collaboration** - Different team members can own different rule files

### Directory Structure

```
.claude/rules/
├── code-style.md           # Always loaded (no paths frontmatter)
├── testing.md              # Always loaded
├── git-workflow.md         # Always loaded
├── security.md             # Path-scoped to sensitive areas
├── api-rules.md            # Path-scoped to API files
├── frontend/               # Subdirectories for organization
│   ├── react.md
│   └── styles.md
└── backend/
    ├── database.md
    └── services.md
```

### Path-Scoped Rules (Conditional Rules)

Rules can target specific files using YAML frontmatter:

```markdown
---
paths:
  - src/api/**/*.ts
  - src/api/**/*.js
---

# API Development Rules

- All API endpoints must include input validation using Zod
- Use the standard error response format: `{ error: string, code: number }`
- Include OpenAPI documentation comments
- Log all requests with correlation IDs
```

**This rule ONLY activates when Claude is working on files matching those paths.**

### Unconditional Rules

Rules without a `paths` field load for ALL files:

```markdown
# Code Style Rules

- Use 2-space indentation
- Maximum line length: 100 characters
- Use descriptive variable names
- All functions must have JSDoc comments
```

### User-Level Rules

Personal rules that apply across ALL your projects:

```
~/.claude/rules/
├── preferences.md      # Your personal coding preferences
└── workflows.md        # Your preferred workflows
```

User-level rules load **before** project rules, giving project rules higher priority to override personal preferences when needed.

### Symlink Support

Share rules across multiple projects:

```bash
# Link a shared company standards directory
ln -s ~/company-standards/claude-rules .claude/rules/shared

# Link individual rule files
ln -s ~/company-standards/security.md .claude/rules/security.md
```

---

## Part 3: Recommended Directory Structure

### Complete Project Structure

```
your-project/
├── .claude/
│   ├── CLAUDE.md                    # Core project overview (keep lean)
│   ├── settings.json                # Team permissions & config (commit to git)
│   ├── settings.local.json          # Personal overrides (auto-gitignored)
│   │
│   ├── rules/                       # Modular project rules
│   │   ├── code-style.md            # Always loaded - formatting standards
│   │   ├── git-workflow.md          # Always loaded - branching, commits
│   │   ├── testing.md               # Always loaded - test requirements
│   │   ├── api-rules.md             # paths: src/api/**/*
│   │   ├── frontend-rules.md        # paths: src/components/**/*
│   │   ├── database-rules.md        # paths: src/models/**/*
│   │   └── security.md              # paths: src/auth/**, src/payments/**
│   │
│   ├── skills/                      # Agent skills (model-invoked)
│   │   ├── commit-helper/           # Each skill in its own folder
│   │   │   └── SKILL.md
│   │   └── code-reviewer/
│   │       └── SKILL.md
│   │
│   ├── commands/                    # Team slash commands
│   │   ├── dev/
│   │   │   ├── start.md             # /dev/start - Initialize dev session
│   │   │   ├── test.md              # /dev/test - Run test suite
│   │   │   └── lint.md              # /dev/lint - Run linters
│   │   ├── git/
│   │   │   ├── branch.md            # /git/branch - Create feature branch
│   │   │   ├── commit.md            # /git/commit - Smart commit
│   │   │   └── pr.md                # /git/pr - Create pull request
│   │   ├── review.md                # /review - Code review checklist
│   │   ├── debug.md                 # /debug - Systematic debugging
│   │   └── docs.md                  # /docs - Generate documentation
│   │
│   └── agents/                      # Team subagents
│       ├── code-reviewer.md         # Code review specialist
│       ├── test-writer.md           # Unit test generation
│       ├── security-scanner.md      # Security analysis
│       └── documenter.md            # Documentation generator
│
├── .mcp.json                        # MCP server configurations (optional)
├── CLAUDE.md                        # Alternative location for main instructions
├── CLAUDE.local.md                  # Personal additions (gitignored)
└── ... (your project files)
```

### User-Level Structure (Each Developer)

```
~/.claude/
├── CLAUDE.md                   # Personal preferences across all projects
├── settings.json               # Personal global settings
├── settings.local.json         # Machine-specific overrides
├── rules/                      # Personal rules for all projects
│   ├── preferences.md
│   └── workflows.md
├── skills/                     # Personal skills
│   └── my-workflow/
│       └── SKILL.md
├── commands/                   # Personal slash commands
│   ├── my-workflow.md
│   └── standup.md
└── agents/                     # Personal subagents
    └── personal-assistant.md
```

---

## Part 4: Essential Configuration Files

### 4.1 CLAUDE.md (Project Root)

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
npm install          # Install dependencies
npm run dev          # Start development server
npm run test         # Run test suite
npm run lint         # Run linting
npm run build        # Production build
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

### 4.2 Project Rules Examples

#### `.claude/rules/code-style.md` (Always Loaded)

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

#### `.claude/rules/git-workflow.md` (Always Loaded)

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
3. Run `npm run lint` and `npm run test`
4. Push and create PR
5. Request review from at least 1 team member
6. Squash merge after approval

## IMPORTANT
- Never commit directly to `main`
- Always rebase before merging
- Delete branch after merge
```

#### `.claude/rules/testing.md` (Always Loaded)

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
npm run test              # Run all tests
npm run test:unit         # Unit tests only
npm run test:integration  # Integration tests
npm run test:coverage     # With coverage report
```

## Before Committing
- Run full test suite
- Check coverage hasn't decreased
- Verify no skipped tests (.skip)
```

#### `.claude/rules/security.md` (Path-Scoped)

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
1. Run security scan: `npm run security:check`
2. Verify no secrets in code: `npm run scan:secrets`
3. Check for SQL injection: review all database queries
4. Peer review required for ALL security changes
```

#### `.claude/rules/api-rules.md` (Path-Scoped)

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

#### `.claude/rules/frontend-rules.md` (Path-Scoped)

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

### 4.3 .claude/settings.json (Team Shared)

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run:*)",
      "Bash(npm test:*)",
      "Bash(npm install)",
      "Bash(npx:*)",
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(docker:*)",
      "Bash(docker-compose:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(node:*)",
      "Bash(curl:*)",
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
      "Bash(rm -rf:*)",
      "Bash(sudo:*)",
      "Bash(chmod 777:*)"
    ],
    "defaultMode": "normal"
  },
  "env": {
    "NODE_ENV": "development"
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.ts)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_FILE_PATH\""
          }
        ]
      },
      {
        "matcher": "Write(*.tsx)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_FILE_PATH\""
          }
        ]
      },
      {
        "matcher": "Write(*.js)",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$CLAUDE_FILE_PATH\""
          }
        ]
      }
    ]
  },
  "includeCoAuthoredBy": true
}
```

### 4.3.1 Complete Settings Reference

| Setting | Description | Example |
|---------|-------------|---------|
| `apiKeyHelper` | Custom script to generate auth value | `"/bin/generate_temp_api_key.sh"` |
| `cleanupPeriodDays` | Days before inactive sessions are deleted (default: 30) | `20` |
| `env` | Environment variables for every session | `{"NODE_ENV": "development"}` |
| `attribution` | Customize git commit and PR attribution | See attribution section below |
| `permissions` | Configure allow/ask/deny rules for tools | See permissions section |
| `hooks` | Custom commands before/after tool executions | See hooks section |
| `disableAllHooks` | Disable all hooks | `true` |
| `model` | Override default model | `"claude-sonnet-4-5-20250929"` |
| `statusLine` | Configure custom status line | `{"type": "command", "command": "..."}` |
| `fileSuggestion` | Custom script for `@` file autocomplete | `{"type": "command", "command": "..."}` |
| `outputStyle` | Configure output style | `"Explanatory"` |
| `forceLoginMethod` | Restrict to `claudeai` or `console` | `"claudeai"` |
| `forceLoginOrgUUID` | Auto-select organization during login | `"uuid-here"` |
| `enableAllProjectMcpServers` | Auto-approve all MCP servers in `.mcp.json` | `true` |
| `enabledMcpjsonServers` | List of specific MCP servers to approve | `["memory", "github"]` |
| `disabledMcpjsonServers` | List of MCP servers to reject | `["filesystem"]` |
| `alwaysThinkingEnabled` | Enable extended thinking by default | `true` |
| `awsAuthRefresh` | Custom script to refresh AWS credentials | `"aws sso login --profile myprofile"` |
| `awsCredentialExport` | Script outputting AWS credentials as JSON | `"/bin/generate_aws_grant.sh"` |
| `includeCoAuthoredBy` | Include co-author line in commits | `true` |

#### Attribution Settings

Customize git commit and PR attribution:

```json
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@company.com>",
    "pr": "Generated with AI"
  }
}
```

#### File Suggestion Settings

Custom `@` file autocomplete:

```json
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

### 4.4 Sample Slash Commands

#### `/dev/start` - Initialize Development Session
**File:** `.claude/commands/dev/start.md`

```markdown
---
model: sonnet
---

Initialize a development session for this project:

1. Check git status and current branch
2. Pull latest changes if on a feature branch
3. Check for any outstanding TODOs in recent changes
4. Verify dependencies are up to date
5. Start the development server if not running
6. Provide a brief summary of recent team activity

!git status
!git log --oneline -5
!git branch --show-current
```

#### `/git/branch` - Create Feature Branch
**File:** `.claude/commands/git/branch.md`

```markdown
---
model: haiku
---

Create a new feature branch based on the description: $ARGUMENTS

Follow our branch naming convention:
- Features: feature/TICKET-short-description
- Bugs: bugfix/TICKET-short-description
- Hotfix: hotfix/TICKET-short-description

Steps:
1. Fetch latest from origin
2. Ensure we're on main and it's up to date
3. Create new branch with proper naming
4. Push the new branch to origin

!git fetch origin
!git branch --show-current
!git status --short
```

#### `/git/commit` - Smart Commit
**File:** `.claude/commands/git/commit.md`

```markdown
---
model: sonnet
---

Analyze staged changes and create a commit with Conventional Commits format.

!git diff --cached --stat
!git diff --cached

Based on the changes above:
1. Determine the commit type (feat, fix, docs, style, refactor, test, chore)
2. Identify the scope from the files changed
3. Write a concise subject line (max 50 chars)
4. Add body with details if changes are complex
5. Reference any ticket numbers if apparent

Format:
```
<type>(<scope>): <subject>

[optional body]

[optional footer with ticket refs]
```
```

#### `/review` - Code Review
**File:** `.claude/commands/review.md`

```markdown
---
model: opus
---

Perform a comprehensive code review of: $ARGUMENTS

Use our project's coding standards from .claude/rules/ as your reference.

## Review Checklist

### 1. Code Quality
- [ ] Clean, readable code
- [ ] Proper error handling
- [ ] No code duplication (DRY)
- [ ] Appropriate abstractions
- [ ] Follows our code style rules

### 2. Security (if applicable)
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Authentication/authorization checks

### 3. Performance
- [ ] Efficient algorithms
- [ ] No memory leaks
- [ ] Appropriate caching
- [ ] Database query optimization
- [ ] No N+1 queries

### 4. Testing
- [ ] Adequate test coverage
- [ ] Edge cases covered
- [ ] Tests are meaningful and not brittle

### 5. Documentation
- [ ] Functions are documented
- [ ] Complex logic explained
- [ ] API changes documented

Provide specific, actionable feedback organized by severity:
- 🔴 **Critical**: Must fix before merge
- 🟠 **High**: Should fix before merge
- 🟡 **Medium**: Consider fixing
- 🟢 **Suggestion**: Nice to have
```

#### `/debug` - Systematic Debugging
**File:** `.claude/commands/debug.md`

```markdown
---
model: opus
---

Debug the following issue: $ARGUMENTS

Follow this systematic approach:

## 1. Understand the Problem
- What is the expected behavior?
- What is the actual behavior?
- Can we reproduce it consistently?

## 2. Gather Information
!git log --oneline -10
- Check relevant logs
- Review recent changes to affected files
- Examine related code paths

## 3. Form Hypotheses
List possible causes ranked by likelihood:
1. [Most likely cause]
2. [Second most likely]
3. [Less likely but possible]

## 4. Investigate
- Test each hypothesis systematically
- Use debugging tools (breakpoints, logging)
- Narrow down the root cause

## 5. Fix and Verify
- Implement the minimal fix
- Verify the issue is resolved
- Check for side effects
- Add regression test

## 6. Document
- What was the root cause?
- How was it fixed?
- How can we prevent similar issues?
```

### 4.5 Sample Subagents

#### Subagent Configuration Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier (lowercase, hyphens) |
| `description` | Yes | Natural language purpose - helps Claude decide when to use |
| `tools` | No | Comma-separated tool list (inherits all if omitted) |
| `model` | No | Model alias: `sonnet`, `opus`, `haiku`, or `inherit` |
| `permissionMode` | No | Permission handling: `default`, `acceptEdits`, `bypassPermissions`, `plan`, `ignore` |
| `skills` | No | Comma-separated skill names to auto-load |

#### Code Reviewer Agent
**File:** `.claude/agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: Specialist for thorough code reviews focusing on quality, security, and best practices. Invoke when reviewing PRs or code changes.
tools: Read, Grep, Glob
model: sonnet
permissionMode: default
---

You are a senior code reviewer with expertise in identifying code quality issues, security vulnerabilities, and performance problems.

## Your Role
- Review code changes thoroughly and systematically
- Provide specific, actionable feedback
- Prioritize findings by severity
- Reference project coding standards from .claude/rules/

## Review Process
1. Understand the context and purpose of changes
2. Check for security vulnerabilities (especially in auth/payment code)
3. Evaluate code quality and maintainability
4. Assess test coverage adequacy
5. Verify documentation completeness

## Output Format
Organize findings by category:
- 🔴 **Critical**: Must fix before merge
- 🟠 **High**: Should fix before merge
- 🟡 **Medium**: Consider fixing
- 🟢 **Suggestion**: Nice to have improvements

Be constructive and explain WHY something should be changed, not just what.
```

#### Test Writer Agent
**File:** `.claude/agents/test-writer.md`

```markdown
---
name: test-writer
description: Generates comprehensive unit and integration tests. Use when you need tests written for new or existing code.
tools: Read, Write, Bash, Grep, Glob
model: sonnet
---

You are a testing specialist focused on writing comprehensive, maintainable tests.

## Your Expertise
- Unit testing with Jest
- Integration testing
- React component testing with Testing Library
- Mocking strategies
- Edge case identification

## Test Writing Principles
1. Each test should test ONE thing
2. Use descriptive names: "should [expected behavior] when [condition]"
3. Follow AAA pattern: Arrange, Act, Assert
4. Mock external dependencies appropriately
5. Cover edge cases and error conditions
6. Tests should be independent and idempotent

## Process
1. Analyze the code to be tested
2. Identify all code paths and edge cases
3. Write tests for happy path first
4. Add tests for error conditions
5. Verify all tests pass: `npm run test`
6. Check coverage: `npm run test:coverage`
```

#### Security Scanner Agent
**File:** `.claude/agents/security-scanner.md`

```markdown
---
name: security-scanner
description: Analyzes code for security vulnerabilities. Use when reviewing security-critical code or before releases.
tools: Read, Grep, Glob, Bash
model: opus
---

You are a security specialist focused on identifying vulnerabilities in code.

## Your Expertise
- OWASP Top 10 vulnerabilities
- Authentication/authorization flaws
- Injection attacks (SQL, XSS, Command)
- Sensitive data exposure
- Security misconfiguration

## Scan Process
1. Identify security-critical areas (auth, payments, admin)
2. Check for common vulnerabilities
3. Review input validation
4. Examine data handling practices
5. Verify access controls
6. Check for hardcoded secrets

## Output Format
Report findings with:
- **Severity**: Critical / High / Medium / Low
- **Location**: File and line number
- **Description**: What the vulnerability is
- **Impact**: What could happen if exploited
- **Recommendation**: How to fix it
- **Reference**: OWASP or CWE identifier if applicable
```

#### Built-in Subagents

Claude Code includes several built-in subagents:

| Subagent | Model | Purpose |
|----------|-------|---------|
| **General-Purpose** | Sonnet | Complex multi-step tasks requiring exploration and modification |
| **Plan** | Sonnet | Research codebase in plan mode (read-only) |
| **Explore** | Haiku | Fast codebase exploration with thoroughness levels: quick, medium, very thorough |

#### Resumable Subagents

Subagents can be resumed to continue previous work:

```bash
> Resume agent abc123 and now analyze the authorization logic as well
```

Each execution gets a unique `agentId` stored in `agent-{agentId}.jsonl`. Full context is preserved when resumed, making this useful for long-running research or analysis tasks.

---

## Part 5: Agent Skills

### Overview

**Agent Skills** are modular capabilities that extend Claude's functionality through organized folders. Unlike slash commands (which you invoke explicitly with `/command`), skills are **model-invoked** — Claude autonomously decides when to use them based on context and your request.

### Skills vs Other Features

| Feature | Invocation | Trigger | Use Case |
|---------|-----------|---------|----------|
| **Skills** | Automatic (Claude decides) | Context matching | Complex capabilities with supporting files |
| **Slash Commands** | Manual (`/command`) | Explicit user request | Simple, frequently used prompts |
| **Subagents** | Delegated (auto or explicit) | Task delegation | Specialized AI personalities |
| **Hooks** | Event-triggered | Lifecycle events | Deterministic automation |

**When to use Skills:**
- When Claude should automatically discover and apply capabilities
- When you have multi-file reference materials (scripts, templates, examples)
- When you want consistent procedures applied without explicit invocation

**When to use Slash Commands:**
- When you want explicit control over when something runs
- For simple, single-file prompts

### Directory Structure

Skills are stored in a `skills/` directory with each skill in its own folder:

```
.claude/skills/                    # Project skills (team-shared)
├── commit-helper/
│   └── SKILL.md                   # Required - main skill file
├── code-reviewer/
│   └── SKILL.md
└── pdf-processing/
    ├── SKILL.md                   # Required - main skill file
    ├── FORMS.md                   # Optional - supplementary docs
    ├── REFERENCE.md               # Optional - API reference
    └── scripts/                   # Optional - helper scripts
        └── validate.py

~/.claude/skills/                  # User skills (personal)
├── my-workflow/
│   └── SKILL.md
└── personal-templates/
    └── SKILL.md
```

### SKILL.md File Format

Each skill requires a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
---

# Your Skill Name

## Instructions
Provide clear, step-by-step guidance for Claude.

## Examples
Show concrete examples of using this Skill.
```

#### Required Fields

| Field | Requirements | Example |
|-------|--------------|---------|
| `name` | Lowercase letters, numbers, hyphens (max 64 chars) | `commit-helper`, `pdf-processing` |
| `description` | What it does + when to use it (max 1024 chars) | `Generate commit messages from diffs. Use when committing changes.` |

#### Optional Fields

| Field | Purpose | Example |
|-------|---------|---------|
| `allowed-tools` | Restrict which tools Claude can use | `Read, Grep, Glob` |

### Writing Effective Descriptions

The description is critical — it's how Claude decides when to use your skill.

**Too Vague (won't work well):**
```yaml
description: Helps with data
description: For files
```

**Specific and Actionable:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.

description: Generate clear commit messages from git diffs with proper formatting. Use when writing commit messages or reviewing staged changes.
```

**Include:**
- Action verbs describing capabilities
- Specific file types or formats handled
- Trigger keywords users might mention
- When the skill should activate

### Example Skills

#### Simple Skill: Commit Message Helper

**File:** `.claude/skills/commit-helper/SKILL.md`

```markdown
---
name: commit-helper
description: Generates clear commit messages from git diffs. Use when writing commit messages or reviewing staged changes.
---

# Commit Message Helper

## Instructions

1. Run `git diff --staged` to see changes
2. Analyze the changes and suggest a commit message with:
   - Summary under 50 characters
   - Detailed description of what changed
   - List of affected components

## Best Practices

- Use present tense ("Add feature" not "Added feature")
- Explain what and why, not how
- Reference issue numbers when applicable

## Examples

Good:
```
Add user authentication with JWT tokens

- Implement JWT token generation and validation
- Add password hashing with bcrypt
- Create auth middleware for protected routes
- Fixes #123
```

Bad:
```
fixed stuff
```
```

#### Read-Only Skill: Code Reviewer

**File:** `.claude/skills/code-reviewer/SKILL.md`

```markdown
---
name: code-reviewer
description: Review code for best practices and potential issues. Use when reviewing code, checking PRs, or analyzing code quality.
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

This skill provides code review capabilities with **read-only** file access.

## Review Checklist

1. **Code organization** - Clear structure, appropriate abstractions
2. **Error handling** - All paths covered, meaningful messages
3. **Performance** - No N+1 queries, efficient algorithms
4. **Security** - Input validation, no hardcoded secrets
5. **Test coverage** - Unit tests present, edge cases covered

## Instructions

1. Use Read to examine files
2. Use Grep to search for patterns
3. Use Glob to find related files
4. Provide detailed feedback organized by severity

## Feedback Format

**Critical (Must Fix)**
- Issue and location
- Suggested fix

**Warnings (Should Fix)**
- Issue and impact
- Suggested improvement

**Suggestions (Consider)**
- Enhancement idea
- Rationale
```

#### Multi-File Skill: PDF Processing

**File:** `.claude/skills/pdf-processing/SKILL.md`

````markdown
---
name: pdf-processing
description: Extract text, fill forms, merge PDFs. Use when working with PDF files, forms, or document extraction. Requires pypdf and pdfplumber packages.
---

# PDF Processing

## Quick Start

### Extract Text from PDF

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    text = pdf.pages[0].extract_text()
    print(text)
```

### Extract Tables

```python
with pdfplumber.open("document.pdf") as pdf:
    table = pdf.pages[0].extract_table()
    for row in table:
        print(row)
```

### Fill PDF Forms

For form filling, see [FORMS.md](FORMS.md).

## Requirements

```bash
pip install pypdf pdfplumber
```

## Error Handling

- Handle corrupted PDFs gracefully
- Provide clear error messages
- Suggest alternatives if extraction fails
````

### Skill Discovery and Testing

**View available skills:**
```
What Skills are available?
List all available Skills
```

**Test skill activation:**
Ask questions that match your skill's description:
```
# If description mentions "PDF files"
Can you help me extract text from this PDF?

# If description mentions "commit messages"
Help me write a commit message for these changes
```

### Best Practices

1. **Keep skills focused** - One capability per skill, not "utility functions"
2. **Use progressive disclosure** - Reference supporting files for advanced content
3. **Document dependencies** - List required packages in both description and content
4. **Use tool restrictions** - Add `allowed-tools` for read-only review skills
5. **Include working examples** - Show concrete, copy-pasteable code
6. **Test with your team** - Verify skills activate when expected

### Troubleshooting

**Claude doesn't use your skill:**
1. Make description more specific with trigger keywords
2. Check YAML is valid (no tabs, proper `---` delimiters)
3. Verify file is in correct location (`skills/name/SKILL.md`)

**Multiple skills conflict:**
Use distinct trigger terms in descriptions:
```yaml
# Skill 1
description: Analyze sales data in Excel files. Use for sales reports, revenue tracking.

# Skill 2
description: Analyze log files and system metrics. Use for debugging, performance monitoring.
```

---

## Part 6: CLAUDE.md Imports

CLAUDE.md files can import other files using `@path/to/import` syntax:

```markdown
# Project Overview
See @README.md for detailed project information.
See @docs/architecture.md for system design.

# Development Standards
See @docs/contributing.md for contribution guidelines.

# Individual Developer Preferences (each dev creates their own)
@~/.claude/va-project-preferences.md
```

### Import Features
- **Relative and absolute paths** supported
- **Recursive imports** up to 5 levels deep
- **Not evaluated** inside code blocks or backticks
- **Great for team members** to add individual preferences without committing to repo

### View Loaded Memories
Run `/memory` command to see all loaded memory files.

---

## Part 7: Team Onboarding Checklist

### Pre-Onboarding (DevOps/Lead - You)

- [ ] Ensure all developers have Claude Pro/Max subscription or premium seats
- [ ] Create project repository with `.claude/` directory structure
- [ ] Create lean `CLAUDE.md` with project overview
- [ ] Set up `.claude/rules/` with modular rule files
- [ ] Configure path-scoped rules for security-critical areas
- [ ] Configure `.claude/settings.json` with team permissions
- [ ] Create initial slash commands for common workflows
- [ ] Create subagents for specialized tasks
- [ ] Set up any required MCP servers (GitHub, Jira, etc.)
- [ ] Test configurations work as expected
- [ ] Document onboarding steps for team

### Developer Onboarding Steps

#### Step 1: Install Claude Code

**Native Install (Recommended):**
```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex

# Windows CMD
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

**Homebrew:**
```bash
brew install --cask claude-code
```

**NPM (Node.js 18+):**
```bash
npm install -g @anthropic-ai/claude-code
```

```bash
# Verify installation
claude --version
```

#### Step 2: Authenticate
```bash
# Start Claude Code and follow authentication prompts
claude

# If using team/enterprise account:
# Select "Claude account with subscription" when prompted
# Choose your organization if prompted
```

#### Step 3: Clone Project & Initialize
```bash
# Clone your project repository
git clone <your-repo-url>
cd <your-project>

# Start Claude Code in your project
claude

# Claude will automatically load:
# - CLAUDE.md
# - .claude/rules/*.md
# - .claude/settings.json
```

#### Step 4: Verify Configuration
```bash
# Inside Claude Code session:
/memory          # View all loaded memory files (CLAUDE.md + rules)
/config          # View current settings
/help            # See all available commands including custom ones
```

#### Step 5: Set Up Personal Preferences (Optional)
```bash
# Create personal preferences file
mkdir -p ~/.claude/rules
echo "# My Preferences" > ~/.claude/rules/preferences.md

# Or create project-specific personal preferences
# (automatically gitignored)
echo "# My local settings" > CLAUDE.local.md
```

#### Step 6: Test Custom Commands
```bash
# Try the team slash commands
/dev/start                      # Initialize dev session
/git/branch feature add-login   # Create feature branch
/review src/api/users.ts        # Code review
```

### Post-Onboarding Verification

- [ ] Developer can run Claude Code successfully
- [ ] Custom slash commands appear in `/help`
- [ ] Project rules load correctly (`/memory` shows all rule files)
- [ ] Permissions work correctly (can't read .env files)
- [ ] Git workflow commands function properly
- [ ] Developer knows how to ask Claude to edit CLAUDE.md for persistent memories
- [ ] Developer knows how to create personal preferences

---

## Part 8: Best Practices for Team Collaboration

### Project Rules Strategy

| Rule Type | Use Case | Example |
|-----------|----------|---------|
| **Always Loaded** | Universal standards | code-style.md, git-workflow.md |
| **Path-Scoped** | Domain-specific rules | security.md → auth/**, payments/** |
| **User-Level** | Personal preferences | ~/.claude/rules/preferences.md |

### CLAUDE.md Best Practices

1. **Keep it lean** - Move detailed rules to `.claude/rules/`
2. **Ask Claude to edit** - Have Claude add instructions to CLAUDE.md during sessions
3. **Use imports** - Reference other docs with `@path/to/file`
4. **Review periodically** - Remove outdated instructions
5. **Commit changes** - Include CLAUDE.md updates in PRs

### Permission Strategy

| Environment | Approach |
|-------------|----------|
| Development | More permissive, allow common dev tools |
| Staging | Moderate, restrict production configs |
| Production | Restrictive, use enterprise policies |

### Slash Command Guidelines

1. **Namespace commands** - Use folders (`/dev/`, `/git/`, etc.)
2. **Use appropriate models** - `haiku` for simple, `sonnet` for complex, `opus` for critical
3. **Include `!` commands** - Pre-load context with bash output
4. **Document in the file** - Commands are self-documenting
5. **Use `$ARGUMENTS`** - Make commands flexible

### Subagent Strategy

- **Read-only agents** for review tasks (limit tools to Read, Grep, Glob)
- **Full-access agents** only when necessary
- **Descriptive names** so Claude auto-delegates appropriately
- **Concise prompts** - Under 500 lines performs better

### Hook Usage

#### Available Hook Events

| Event | Purpose |
|-------|---------|
| `PreToolUse` | Before tool execution; can allow/deny/ask permission |
| `PostToolUse` | After tool completes; provide feedback to Claude |
| `PermissionRequest` | When permission dialog shown; allow/deny on behalf of user |
| `UserPromptSubmit` | Before Claude processes user prompt; validate/add context |
| `Stop` | When main agent finishes; control continuation |
| `SubagentStop` | When subagent finishes; control continuation |
| `Notification` | When notifications sent; filter by type |
| `PreCompact` | Before compacting context (manual/auto) |
| `SessionStart` | Session begins; load context/setup environment |
| `SessionEnd` | Session ends; cleanup tasks |

#### Command Hooks (Bash)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.py)",
        "hooks": [{"type": "command", "command": "black \"$CLAUDE_FILE_PATH\"", "timeout": 60}]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash(rm:*)",
        "hooks": [{"type": "command", "command": "echo 'Warning: Delete operation'"}]
      }
    ]
  }
}
```

#### Prompt-Based Hooks (LLM)

For events: `Stop`, `SubagentStop`, `UserPromptSubmit`, `PreToolUse`, `PermissionRequest`

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": ".*",
        "hooks": [{
          "type": "prompt",
          "prompt": "Evaluate if Claude should stop: $ARGUMENTS",
          "timeout": 30
        }]
      }
    ]
  }
}
```

#### Environment Variables in Hooks

- `CLAUDE_PROJECT_DIR`: Project root directory
- `CLAUDE_FILE_PATH`: Path of file being operated on
- `CLAUDE_CODE_REMOTE`: Whether running in remote environment
- `CLAUDE_ENV_FILE`: (SessionStart only) Path to persist environment variables
- `CLAUDE_PLUGIN_ROOT`: (Plugin hooks) Root directory of the plugin

#### MCP Tool Matching in Hooks

MCP tools follow pattern: `mcp__<server>__<tool>`
```json
{
  "matcher": "mcp__memory__.*"
}
```

---

## Part 9: Security Considerations

### Permission Deny Rules (Required)

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
      "Bash(curl:* | *)",
      "Bash(wget:*)",
      "Bash(rm -rf:*)",
      "Bash(sudo:*)",
      "Bash(chmod 777:*)"
    ]
  }
}
```

### Security Best Practices

1. **Never allow** `.env` file access in settings
2. **Use path-scoped security rules** for auth/payment code
3. **Audit hooks** - Ensure they don't expose sensitive data
4. **Use enterprise policies** for organization-wide restrictions
5. **Review MCP servers** - Only use trusted sources
6. **Monitor usage** - Check for unexpected behavior
7. **Regular audits** - Review rule files periodically

---

## Part 10: Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Rules not loading | Check files are `.md` in `.claude/rules/` directory |
| Path-scoped rule not activating | Verify glob pattern matches your file paths |
| Commands not showing | Ensure files are in `.claude/commands/` with `.md` extension |
| Permissions not working | Check hierarchy - project settings override user settings |
| CLAUDE.md not loading | Verify file location and naming |
| Imports not working | Check path is correct, not inside code block |
| Hooks not firing | Check matcher patterns and script permissions |

### Useful Commands

```bash
/memory          # View all loaded memory files and rules
/config          # View current configuration
/help            # List all commands
/status          # Check status
/clear           # Clear conversation (use often!)
/login           # Re-authenticate
/agents          # Manage subagents
/init            # Bootstrap/update CLAUDE.md
```

---

## Part 11: Checkpoints, Rewind & Session Management

### Checkpoints (Automatic)

Claude Code automatically captures snapshots of your code **before each edit**. This creates a safety net for ambitious refactoring and exploration.

**What's Tracked:**
- All file edits made through Claude's editing tools
- Conversation history at each checkpoint

**What's NOT Tracked:**
- Files modified by bash commands (e.g., `npm run build`)
- Manual edits you make outside Claude Code
- External service state (APIs, databases)

### Using /rewind

Access via `Esc + Esc` or `/rewind` command.

**Restore Options:**

| Option | What It Restores | Best For |
|--------|------------------|----------|
| **Conversation only** | Conversation history to prior point | Re-phrasing a prompt without losing code |
| **Code only** | File changes to prior state | Undoing bad edits while keeping context |
| **Both** | Code AND conversation | Full rollback after major wrong turn |

**Best Practices:**
- Use `/rewind` liberally for experimentation
- Combine with Git for permanent history
- Use Plan Mode (`Shift+Tab`) first for risky operations
- Think of checkpoints as "local undo" and Git as "permanent history"

### Session Commands

| Command | Description |
|---------|-------------|
| `/clear` | Clear conversation history, start fresh |
| `/compact` | Compress conversation to save context |
| `/context` | Visualize current context usage |
| `/export` | Export conversation for sharing |
| `claude -c` | Continue most recent session |
| `claude -r` | Resume specific previous conversation |

---

## Part 12: Plugin System

Plugins are a lightweight way to package and share customizations: slash commands, subagents, hooks, MCP servers, and output styles.

### Installing Plugins

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

### Plugin Configuration

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

### Team Plugin Distribution

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

### Use Cases

- **Enforcing standards**: Ensure specific hooks run for code reviews
- **Supporting users**: Provide slash commands for common workflows
- **Sharing workflows**: Distribute debugging setups, deployment pipelines
- **Connecting tools**: Package MCP server configurations

---

## Part 13: Output Styles

Output styles modify Claude's system prompt to adapt behavior for different use cases.

### Built-in Styles

| Style | Description |
|-------|-------------|
| **Default** | Standard software engineering assistance |
| **Explanatory** | Provides educational "Insights" between tasks, helps understand implementation choices |
| **Learning** | Collaborative mode where Claude adds `TODO(human)` markers for you to implement |

### Switching Styles

```bash
# Interactive menu
/output-style

# Direct switch
/output-style explanatory
/output-style learning
/output-style default
```

### Custom Output Styles

Create custom styles in `~/.claude/output-styles/` or `.claude/output-styles/`:

```markdown
---
name: Security Auditor
description: Focuses on security implications of all code changes
keep-coding-instructions: true
---

# Security Auditor Mode

You are a security-focused code assistant. For every change:
1. Identify potential security implications
2. Flag any new attack vectors introduced
3. Recommend security hardening measures
4. Reference OWASP guidelines where applicable

Always prioritize security over convenience.
```

### When to Use Output Styles

- **Explanatory**: Onboarding new team members, learning a codebase
- **Learning**: Training junior developers, educational contexts
- **Custom**: Specialized workflows (security audits, documentation focus, etc.)

---

## Part 14: VS Code Extension

### Overview

The native VS Code extension (beta) provides a graphical interface integrated directly into your IDE.

### Key Features

| Feature | Description |
|---------|-------------|
| **Sidebar Panel** | Dedicated Claude Code panel in VS Code sidebar |
| **Inline Diffs** | See proposed changes with accept/reject buttons |
| **Plan Mode** | Review and edit Claude's plans before accepting |
| **Auto-Accept** | Automatically apply trusted changes |
| **Extended Thinking** | Toggle reasoning visibility |
| **Selection Context** | Current selection/tab automatically shared |
| **Diagnostic Sharing** | Lint and syntax errors auto-shared with Claude |
| **Drag & Drop** | Drop files and folders into chat |
| **Tab Icon Badges** | Visual indicators for pending permissions and unread completions |

### Installation

1. Open VS Code Extensions (`Ctrl+Shift+X`)
2. Search "Claude Code"
3. Install the official Anthropic extension
4. Click the Spark icon in sidebar

### File Reference Shortcuts

- **Mac**: `Cmd+Option+K` to insert file references like `@File#L1-99`
- **Windows/Linux**: `Alt+Ctrl+K`

### VS Code vs CLI

| Use CLI When... | Use Extension When... |
|-----------------|----------------------|
| Terminal-native workflows | Visual interface preferred |
| Keyboard-first efficiency | Plan mode with editing needed |
| Resource-constrained environments | Inline diffs helpful |
| Advanced permission control needed | Real-time visual feedback wanted |

### Configuration

In VS Code settings or `.vscode/settings.json`:
```json
{
  "claudeCode.disableLoginPrompt": true,
  "claudeCode.respectGitIgnore": true,
  "env": {
    "CLAUDE_CODE_USE_BEDROCK": "1",
    "AWS_REGION": "us-east-2"
  }
}
```

---

## Part 15: Advanced Features

### Background Commands (`Ctrl+B`)

Run any bash command in the background while Claude continues working:
- Great for dev servers, log tailing, long-running builds
- Claude can check on background processes as needed

### Background Agents

Start a message with `&` to send it as a background task:
```
& Run the full test suite and fix any failures
```
The agent works in the background while you continue other tasks.

### Named Sessions

```bash
# Name the current session
/rename my-feature-work

# Resume a named session (in REPL)
/resume my-feature-work

# Resume from terminal
claude --resume my-feature-work
```

### Thinking Mode Triggers

Trigger deeper reasoning with keywords in your prompt:
- "think" - Enable thinking mode
- "think harder" - More thorough analysis
- "ultrathink" - Maximum reasoning depth

### Web Search

Claude can search the web for current information. Just ask questions about recent events, documentation, or anything requiring up-to-date information.

### Image Support

Multiple ways to include images:
- **Paste**: `Ctrl+V` (or `Cmd+V` on Mac in VS Code)
- **Drag & Drop**: Drag image files into the prompt
- **@-mention**: `@path/to/image.png`

### Custom Status Line

Customize your terminal status line with `/statusline`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

The status line can include `current_usage` field for context window calculations.

### Shell Override

Use the `CLAUDE_CODE_SHELL` environment variable to override the default shell:

```bash
export CLAUDE_CODE_SHELL=/bin/zsh
claude
```

### Sandbox Mode (Linux/Mac)

Enable bash sandboxing for safer command execution:

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

### Vim Mode

Enable vim-style editing with `/vim` command or configure via `/config`:

**Mode Switching:**
- `Esc` → Enter NORMAL mode
- `i` / `I` → Insert before cursor / at beginning of line
- `a` / `A` → Insert after cursor / at end of line
- `o` / `O` → Open line below / above

**Navigation (NORMAL mode):**
- `h/j/k/l` → Move left/down/up/right
- `w/e/b` → Next word / end of word / previous word
- `0/$` → Beginning / end of line
- `gg/G` → Beginning / end of input

**Editing (NORMAL mode):**
- `x` → Delete character
- `dd/D` → Delete line / to end of line
- `cc/C` → Change line / to end of line
- `.` → Repeat last change

### Session Management

| Command | Description |
|---------|-------------|
| `claude -c` | Continue most recent session |
| `claude -r` | Resume specific conversation |
| `claude --resume <name>` | Resume named session |
| `/resume` | Switch conversations within REPL |
| `/rename` | Name current session |

### Prompt Suggestions

Claude can suggest follow-up prompts. Configure in `/config` (or `/settings`):
- Press `Enter` to accept and submit immediately
- Press `Tab` to accept for editing
- Toggle on/off in `/config`

---

## Part 16: Quick Reference Card

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Alt+T` | Toggle extended thinking mode (sticky across sessions) |
| `Shift+Tab` | Toggle plan mode / cycle permission modes |
| `Ctrl+R` | Search prompt history |
| `Ctrl+C` | Cancel current operation |
| `Ctrl+D` | Exit Claude Code session |
| `Ctrl+L` | Clear terminal screen (keeps conversation) |
| `Ctrl+Z` | Suspend Claude Code (resume with `fg`) |
| `Ctrl+B` | Run bash command in background |
| `Ctrl+G` | Edit prompt in system text editor |
| `Ctrl+J` | Insert newline (control sequence) |
| `Ctrl+Y` | Paste deleted text (readline-style yank) |
| `Alt+Y` | Cycle through kill ring history (yank-pop) |
| `Ctrl+O` | Toggle verbose output mode |
| `Alt+P` / `Option+P` | Switch models while typing |
| `Alt+V` (Windows) | Paste image from clipboard |
| `Esc + Esc` | Open rewind menu |
| `\` + `Enter` | Insert newline (quick escape) |
| `Option+Enter` (Mac) | Insert newline (macOS default) |
| `Shift+Enter` | Insert newline (after `/terminal-setup`) |
| `Alt+M` | Toggle permission modes (alternative to Shift+Tab) |
| `@` path | File/folder autocomplete and reference |
| `#` at start | Add to CLAUDE.md memory shortcut |
| `!` command | Direct bash execution |
| `&` message | Send as background task |

### Memory & Rules Locations

| Type | Location | Shared |
|------|----------|--------|
| Project Memory | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team (git) |
| Project Rules | `./.claude/rules/*.md` | Team (git) |
| Project Skills | `./.claude/skills/*/SKILL.md` | Team (git) |
| Project Local | `./CLAUDE.local.md` | No (gitignored) |
| User Memory | `~/.claude/CLAUDE.md` | No |
| User Rules | `~/.claude/rules/*.md` | No |
| User Skills | `~/.claude/skills/*/SKILL.md` | No |
| Output Styles | `./.claude/output-styles/*.md` | Team (git) |

### Path-Scoped Rule Syntax
```markdown
---
paths:
  - src/api/**/*.ts
  - src/auth/**/*
---

# Rules that only apply to matching files
```

### Import Syntax
```markdown
@README.md                           # Relative path
@docs/architecture.md                # Subdirectory
@~/.claude/my-preferences.md         # Home directory
```

### Essential Slash Commands

| Command | Description |
|---------|-------------|
| `/help` | Show all commands |
| `/init` | Initialize/update CLAUDE.md |
| `/memory` | View/edit all loaded memories and rules |
| `/config` or `/settings` | View and modify settings |
| `/permissions` | Manage tool permissions with search (`/` to search) |
| `/clear` | Clear conversation history |
| `/rewind` | Restore code/conversation to checkpoint |
| `/compact` | Compress conversation to save context |
| `/context` | Visualize context usage |
| `/usage` | Check plan usage limits |
| `/cost` | Check session API token usage |
| `/stats` | View usage statistics and streaks |
| `/export` | Export conversation |
| `/doctor` | Diagnose configuration issues |
| `/model` | Change or configure model |
| `/output-style` | Change output style |
| `/review` | Request code review |
| `/security-review` | Complete security review of pending branch changes |
| `/todos` | List tracked TODO items |
| `/add-dir` | Add working directory |
| `/status` | Show version and connectivity |
| `/resume` | Switch to another conversation |
| `/rename` | Name current session |
| `/plugin` | Manage plugins (with search filtering) |
| `/mcp` | Manage MCP servers |
| `/statusline` | Customize status line |
| `/terminal-setup` | Configure terminal integration |
| `/bashes` | List and manage background tasks |
| `/sandbox` | Enable sandboxed bash tool |
| `/hooks` | Manage hook configurations |
| `/ide` | Manage IDE integrations and status |
| `/agents` | Manage custom AI subagents |
| `/vim` | Enter vim editing mode |
| `/privacy-settings` | View and update privacy settings |
| `/release-notes` | View release notes |
| `/install-github-app` | Set up Claude GitHub Actions |
| `/bug` | Report bugs (sends conversation to Anthropic) |
| `/login` | Switch Anthropic accounts |
| `/logout` | Sign out from your Anthropic account |
| `/exit` | Exit the REPL |

### CLI Flags

| Flag | Description |
|------|-------------|
| `claude -c` | Continue most recent session |
| `claude -r` | Resume specific previous conversation |
| `claude --resume <n>` | Resume named session |
| `claude -p "prompt"` | Headless mode with prompt |
| `claude --model <model>` | Set model (alias: sonnet, opus, haiku) |
| `claude --agents` | Dynamically add subagents via JSON |
| `claude --system-prompt` | Replace entire default system prompt |
| `claude --system-prompt-file` | Load system prompt from file (print mode only) |
| `claude --append-system-prompt` | Add to system prompt |
| `claude --tools` | Specify available tools (`"Bash,Edit,Read"` or `"default"`) |
| `claude --allowedTools` | Tools that execute without prompting |
| `claude --disallowedTools` | Tools removed from context |
| `claude --mcp-config <file>` | Load MCP servers from config |
| `claude --strict-mcp-config` | Only use specified MCP servers |
| `claude --mcp-debug` | Debug MCP server issues |
| `claude --add-dir <path>` | Add working directory |
| `claude --dangerously-skip-permissions` | Skip all permission checks |
| `claude --permission-mode` | Begin in specified permission mode |
| `claude --max-turns` | Limit agentic turns (non-interactive mode) |
| `claude --fork-session` | Create new session ID when resuming |
| `claude --session-id` | Use specific session ID (must be valid UUID) |
| `claude --output-format` | Specify output format (`text`, `json`, `stream-json`) |
| `claude --input-format` | Specify input format (`text`, `stream-json`) |
| `claude --json-schema` | Get validated JSON output matching schema (print mode) |
| `claude --chrome` | Enable Chrome browser integration |
| `claude --no-chrome` | Disable Chrome integration |
| `claude --ide` | Auto-connect to IDE if available |
| `claude --fallback-model` | Auto-fallback to specified model when overloaded |
| `claude --debug` | Enable debug mode with optional filtering |
| `claude --verbose` | Enable verbose logging |
| `claude --settings` | Load settings from JSON file or string |
| `claude --plugin-dir` | Load plugins from directories |
| `claude update` | Update to latest version |
| `claude mcp` | Configure MCP servers |

### MCP Commands

| Command | Description |
|---------|-------------|
| `/mcp` | View MCP server status and tools |
| `/mcp enable <server>` | Enable an MCP server |
| `/mcp disable <server>` | Disable an MCP server |
| `claude mcp add` | Interactive MCP setup wizard |
| `claude mcp add-json <n> <json>` | Add MCP server from JSON |
| `claude mcp list` | List configured MCP servers |
| `@server-name` | Toggle MCP server on/off |

### Permission Patterns
- `Bash(npm run:*)` - All npm run commands
- `Read(src/**)` - All files in src recursively
- `Edit(*.ts)` - All TypeScript files
- `WebFetch(domain:github.com)` - Specific domain
- `mcp__server__*` - All tools from a specific MCP server (wildcard)
- `mcp__github__*` - All GitHub MCP tools
- `mcp__memory__create_entities` - Specific MCP tool

---

## Appendix: Additional Resources

### Official Documentation
- [Claude Code Documentation](https://code.claude.com/docs/en/overview)
- [Memory Management](https://code.claude.com/docs/en/memory)
- [Settings Reference](https://code.claude.com/docs/en/settings)
- [CLI Reference](https://code.claude.com/docs/en/cli-reference)
- [Interactive Mode](https://code.claude.com/docs/en/interactive-mode)
- [Slash Commands](https://code.claude.com/docs/en/slash-commands)
- [Checkpointing](https://code.claude.com/docs/en/checkpointing)
- [Output Styles](https://code.claude.com/docs/en/output-styles)
- [Plugins](https://code.claude.com/docs/en/plugins)
- [Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [Skills](https://code.claude.com/docs/en/skills)
- [Hooks](https://code.claude.com/docs/en/hooks)
- [MCP Integration](https://code.claude.com/docs/en/mcp)
- [Sandboxing](https://code.claude.com/docs/en/sandboxing)
- [Common Workflows](https://code.claude.com/docs/en/common-workflows)
- [Headless Mode](https://code.claude.com/docs/en/headless)

### Best Practices & Guides
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Using CLAUDE.md Files](https://claude.com/blog/using-claude-md-files)
- [Enabling Autonomous Work](https://www.anthropic.com/news/enabling-claude-code-to-work-more-autonomously)

### Community Resources
- [Awesome Claude Code (GitHub)](https://github.com/hesreallyhim/awesome-claude-code)
- [Claude Code Changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)
- [Claude Code Issues](https://github.com/anthropics/claude-code/issues)

---

*Document Version: 2.4 | Compatible with Claude Code v2.0.73*
*Includes: Project Rules, Path-Scoped Rules, Memory Imports, Checkpoints/Rewind, Output Styles, Plugins, VS Code Extension, Background Agents, Named Sessions, Sandbox Mode, Chrome Extension, Prompt Suggestions, Complete Configuration Examples*

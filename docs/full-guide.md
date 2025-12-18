# Claude Code Team Onboarding & Collaboration Guide

## Executive Summary

This guide provides a comprehensive game plan for deploying Claude Code across a small team. It covers the latest feature sets (as of v2.0.72), recommended directory structures, project rules, slash commands, and configurations that support effective team collaboration.

---

## Part 1: Claude Code Feature Overview (v2.0.72)

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
| **Image Support** | Paste images directly into prompt (`Ctrl+V` or drag-and-drop). |
| **Chrome Extension** | Control your browser directly from Claude Code with Claude in Chrome (Beta). |
| **Prompt Suggestions** | Claude suggests follow-up prompts. Press `Enter` to accept immediately, `Tab` to edit first. |
| **Model Switching** | Switch models while typing with `Alt+P` (Option+P on Mac). |
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

#### Code Reviewer Agent
**File:** `.claude/agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: Specialist for thorough code reviews focusing on quality, security, and best practices. Invoke when reviewing PRs or code changes.
tools: Read, Grep, Glob
model: sonnet
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

---

## Part 5: CLAUDE.md Imports

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

## Part 6: Team Onboarding Checklist

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
```bash
# Install Node.js 18+ if not already installed
# Then install Claude Code globally
npm install -g @anthropic-ai/claude-code

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

## Part 7: Best Practices for Team Collaboration

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

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.py)",
        "hooks": [{"type": "command", "command": "black \"$CLAUDE_FILE_PATH\""}]
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

---

## Part 8: Security Considerations

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

## Part 9: Troubleshooting

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

## Part 10: Checkpoints, Rewind & Session Management

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

## Part 11: Plugin System

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

## Part 12: Output Styles

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

## Part 13: VS Code Extension

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

## Part 14: Advanced Features

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

## Part 15: Quick Reference Card

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Alt+T` | Toggle extended thinking mode (sticky across sessions) |
| `Shift+Tab` | Toggle plan mode / cycle permission modes |
| `Ctrl+R` | Search prompt history |
| `Ctrl+C` | Cancel current operation |
| `Ctrl+Z` | Suspend Claude Code (resume with `fg`) |
| `Ctrl+B` | Run bash command in background |
| `Ctrl+G` | Edit prompt in system text editor |
| `Ctrl+Y` | Paste deleted text (readline-style) |
| `Ctrl+O` | Toggle transcript mode |
| `Alt+P` / `Option+P` | Switch models while typing |
| `Esc + Esc` | Open rewind menu |
| `@` path | File/folder autocomplete and reference |
| `!` command | Direct bash execution |
| `&` message | Send as background task |

### Memory & Rules Locations

| Type | Location | Shared |
|------|----------|--------|
| Project Memory | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team (git) |
| Project Rules | `./.claude/rules/*.md` | Team (git) |
| Project Local | `./CLAUDE.local.md` | No (gitignored) |
| User Memory | `~/.claude/CLAUDE.md` | No |
| User Rules | `~/.claude/rules/*.md` | No |
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
| `/permissions` | Manage tool permissions with search |
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
| `/todos` | List tracked TODO items |
| `/add-dir` | Add working directory |
| `/status` | Show version and connectivity |
| `/resume` | Switch to another conversation |
| `/rename` | Name current session |
| `/plugin` | Manage plugins |
| `/mcp` | Manage MCP servers |
| `/statusline` | Customize status line |
| `/terminal-setup` | Configure terminal integration |

### CLI Flags

| Flag | Description |
|------|-------------|
| `claude -c` | Continue most recent session |
| `claude -r` | Resume specific previous conversation |
| `claude --resume <n>` | Resume named session |
| `claude -p "prompt"` | Headless mode with prompt |
| `claude --agents` | Dynamically add subagents |
| `claude --append-system-prompt` | Add to system prompt |
| `claude --mcp-config <file>` | Load MCP servers from config |
| `claude --mcp-debug` | Debug MCP server issues |
| `claude --add-dir <path>` | Add working directory |
| `claude --dangerously-skip-permissions` | Skip all permission checks |

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

---

## Appendix: Additional Resources

### Official Documentation
- [Claude Code Documentation](https://code.claude.com/docs)
- [Memory Management](https://code.claude.com/docs/en/memory)
- [Settings Reference](https://code.claude.com/docs/en/settings)
- [Checkpointing](https://code.claude.com/docs/en/checkpointing)
- [Output Styles](https://code.claude.com/docs/en/output-styles)
- [Plugins](https://code.claude.com/docs/en/plugins)
- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [Skills](https://code.claude.com/docs/en/skills)
- [Hooks](https://code.claude.com/docs/en/hooks)
- [MCP Integration](https://code.claude.com/docs/en/mcp)
- [Sandboxing](https://code.claude.com/docs/en/sandboxing)

### Best Practices & Guides
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Using CLAUDE.md Files](https://claude.com/blog/using-claude-md-files)
- [Enabling Autonomous Work](https://www.anthropic.com/news/enabling-claude-code-to-work-more-autonomously)

### Community Resources
- [Awesome Claude Code (GitHub)](https://github.com/hesreallyhim/awesome-claude-code)
- [Claude Code Changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)
- [Claude Code Issues](https://github.com/anthropics/claude-code/issues)

---

*Document Version: 2.3 | Compatible with Claude Code v2.0.72*
*Includes: Project Rules, Path-Scoped Rules, Memory Imports, Checkpoints/Rewind, Output Styles, Plugins, VS Code Extension, Background Agents, Named Sessions, Sandbox Mode, Chrome Extension, Prompt Suggestions, Complete Configuration Examples*

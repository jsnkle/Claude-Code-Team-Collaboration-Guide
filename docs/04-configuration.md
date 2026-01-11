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
      "Bash(pnpm:*)",
      "Bash(pnpm test:*)",
      "Bash(pnpm install)",
      "Bash(pnpm exec:*)",
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
  "includeCoAuthoredBy": true
}
```

## Complete Settings Reference

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
| `language` | Configure Claude's response language (v2.1+) | `"ja"` (Japanese), `"es"` (Spanish) |
| `respectGitignore` | Control whether file picker respects .gitignore (v2.1+) | `true` |
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

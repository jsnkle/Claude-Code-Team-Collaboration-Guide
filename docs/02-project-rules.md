# Part 2: Project Rules System

## Overview

The `.claude/rules/` directory allows you to organize project instructions into **modular, focused rule files** instead of one large CLAUDE.md. This is ideal for teams managing complex codebases.

## Key Benefits

- **Separation of Concerns** - Update security rules without touching styling guidelines
- **Path-Scoped Activation** - Rules only load when working on matching files
- **Reduced Token Usage** - Irrelevant rules stay out of context
- **Team Collaboration** - Different team members can own different rule files

## Directory Structure

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

## Path-Scoped Rules (Conditional Rules)

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

## Unconditional Rules

Rules without a `paths` field load for ALL files:

```markdown
# Code Style Rules

- Use 2-space indentation
- Maximum line length: 100 characters
- Use descriptive variable names
- All functions must have JSDoc comments
```

## User-Level Rules

Personal rules that apply across ALL your projects:

```
~/.claude/rules/
├── preferences.md      # Your personal coding preferences
└── workflows.md        # Your preferred workflows
```

User-level rules load **before** project rules, giving project rules higher priority to override personal preferences when needed.

## Symlink Support

Share rules across multiple projects:

```bash
# Link a shared company standards directory
ln -s ~/company-standards/claude-rules .claude/rules/shared

# Link individual rule files
ln -s ~/company-standards/security.md .claude/rules/security.md
```

---

[← Previous: Feature Overview](01-feature-overview.md) | [Back to Guide](../README.md) | [Next: Directory Structure →](03-directory-structure.md)

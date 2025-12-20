# Slash Commands

Slash commands are reusable prompt templates triggered with `/`. They live in `.claude/commands/` and can include shell commands, model selection, and dynamic arguments.

## `/dev/start` - Initialize Development Session

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

## `/git/branch` - Create Feature Branch

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

## `/git/commit` - Smart Commit

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

## `/review` - Code Review

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

## `/debug` - Systematic Debugging

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

## Command Guidelines

1. **Namespace commands** - Use folders (`/dev/`, `/git/`, etc.)
2. **Use appropriate models** - `haiku` for simple, `sonnet` for complex, `opus` for critical
3. **Include `!` commands** - Pre-load context with bash output
4. **Document in the file** - Commands are self-documenting
5. **Use `$ARGUMENTS`** - Make commands flexible

---

[← Previous: Configuration](04-configuration.md) | [Back to Guide](../README.md) | [Next: Subagents →](06-subagents.md)

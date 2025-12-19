---
name: commit-helper
description: Generates clear commit messages from git diffs following Conventional Commits format. Use when writing commit messages, reviewing staged changes, or preparing commits.
---

# Commit Message Helper

## Instructions

1. Run `git diff --staged` to see staged changes
2. Analyze the changes and determine:
   - The type of change (feat, fix, docs, style, refactor, test, chore)
   - The scope (component, module, or area affected)
   - A concise summary of what changed

3. Generate a commit message following this format:
   ```
   <type>(<scope>): <subject>

   [optional body with more details]

   [optional footer with issue references]
   ```

## Commit Types

| Type | Description |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `style` | Formatting, missing semicolons, etc. |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding missing tests |
| `chore` | Maintenance tasks, dependency updates |

## Best Practices

- Keep subject line under 50 characters
- Use imperative mood ("Add feature" not "Added feature")
- Don't end subject line with a period
- Explain what and why, not how
- Reference issue numbers when applicable

## Examples

### Good Commit Messages

```
feat(auth): add JWT token refresh mechanism

- Implement automatic token refresh before expiry
- Add refresh token storage in secure cookie
- Create middleware to handle token validation

Closes #123
```

```
fix(api): handle null response from payment gateway

The payment gateway occasionally returns null instead of
an error object. This adds null checking to prevent crashes.

Fixes #456
```

### Bad Commit Messages

```
fixed stuff
```

```
WIP
```

```
Updated files
```

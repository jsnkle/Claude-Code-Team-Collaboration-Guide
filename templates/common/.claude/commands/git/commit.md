---
model: sonnet
---

Analyze staged changes and create a commit with Conventional Commits format.

Based on the staged changes:
1. **Check for atomicity first** — verify staged changes represent a single logical unit. If changes span multiple concerns (e.g., a bug fix mixed with a refactor), stop and ask the user to split them into separate commits
2. Determine the commit type (feat, fix, docs, style, refactor, test, chore)
3. Identify the scope from the files changed
4. Write a concise subject line (max 50 chars)
5. Add body with details if changes are complex
6. Reference any ticket numbers if apparent

Format:
```
<type>(<scope>): <subject>

[optional body]

[optional footer with ticket refs]
```

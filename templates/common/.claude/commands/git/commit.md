---
model: sonnet
---

Analyze staged changes and create a commit with Conventional Commits format.

Based on the staged changes:
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

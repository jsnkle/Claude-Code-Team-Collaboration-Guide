# Part 13: Custom Output Styles

Output styles modify Claude's behavior. While Claude Code includes built-in styles (Default, Explanatory, Learning), teams can create and distribute **custom output styles**.

## Creating Team Output Styles

Place custom styles in `.claude/output-styles/` to distribute with your project:

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

## Team Use Cases

- **Security Auditor**: Enforce security-first reviews
- **Documentation Focus**: Ensure thorough documentation
- **Strict Code Review**: Enforce team coding standards

Developers switch styles with `/output-style`. For full details, see the [official output styles documentation](https://code.claude.com/docs/en/output-styles).

---

[← Previous: Plugins](14-plugins.md) | [Back to Guide](../README.md) | [Next: VS Code Extension →](16-vscode-extension.md)

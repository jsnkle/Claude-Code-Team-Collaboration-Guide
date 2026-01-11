# Part 9: Security Considerations

## Permission Deny Rules (Required)

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

## Wildcard Bash Permissions (v2.1+)

You can use wildcard patterns for Bash tool permissions:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm *)",
      "Bash(pnpm *)",
      "Bash(git *)"
    ]
  }
}
```

This allows any command starting with `npm`, `pnpm`, or `git` without individual permission prompts.

## Unreachable Rule Detection (v2.1+)

Claude Code now detects and warns about permission rules that can never be reached. For example:

```json
{
  "permissions": {
    "deny": [
      "Bash(rm:*)"
    ],
    "allow": [
      "Bash(rm -rf:*)"
    ]
  }
}
```

The `allow` rule for `rm -rf` is unreachable because the `deny` rule for `rm` blocks all `rm` commands first. Claude Code will warn you about these configuration issues.

## Security Best Practices

1. **Never allow** `.env` file access in settings
2. **Use path-scoped security rules** for auth/payment code
3. **Audit hooks** - Ensure they don't expose sensitive data
4. **Use enterprise policies** for organization-wide restrictions
5. **Review MCP servers** - Only use trusted sources
6. **Monitor usage** - Check for unexpected behavior
7. **Regular audits** - Review rule files periodically
8. **Check for warnings** - Review unreachable rule warnings in `/permissions`

---

[← Previous: Best Practices](10-best-practices.md) | [Back to Guide](../README.md) | [Next: Troubleshooting →](12-troubleshooting.md)

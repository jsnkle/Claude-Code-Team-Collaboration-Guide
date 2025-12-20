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

## Security Best Practices

1. **Never allow** `.env` file access in settings
2. **Use path-scoped security rules** for auth/payment code
3. **Audit hooks** - Ensure they don't expose sensitive data
4. **Use enterprise policies** for organization-wide restrictions
5. **Review MCP servers** - Only use trusted sources
6. **Monitor usage** - Check for unexpected behavior
7. **Regular audits** - Review rule files periodically

---

[← Previous: Best Practices](10-best-practices.md) | [Back to Guide](../README.md) | [Next: Troubleshooting →](12-troubleshooting.md)

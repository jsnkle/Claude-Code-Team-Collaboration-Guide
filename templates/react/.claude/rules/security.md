---
paths:
  - src/auth/**/*
  - src/payments/**/*
  - src/api/admin/**/*
  - "**/middleware/auth*"
---

# Security-Critical Code Rules

<!-- TODO: Customize security paths and requirements for your project -->

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

### CSRF Protection

- Use anti-CSRF tokens for all state-changing operations
- Validate `Origin` and `Referer` headers on mutations
- Use `SameSite=Strict` or `SameSite=Lax` for session cookies
- Implement double-submit cookie pattern for API endpoints

### Security Headers

Configure these headers on all responses:

```
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), microphone=(), camera=()
```

> Use [helmet](https://helmetjs.github.io/) for Express or equivalent middleware for your framework.

### Logging & Monitoring
- Log all authentication attempts
- Include correlation IDs in all logs
- Never log request bodies containing credentials

## Before Committing Security Code

1. Run security audit: `npm audit` (built-in)
2. Check for secrets in code: `npx secretlint "**/*"` or `git diff --cached | grep -E "(password|secret|api_key|token)"`
3. Review all database queries for SQL injection
4. Peer review required for ALL security changes

> **Note:** For enhanced security scanning, consider adding these scripts to package.json:
> - `"security:check": "npm audit && npx eslint --config .eslintrc.security.js src/"`
> - `"scan:secrets": "npx secretlint \"**/*\""`

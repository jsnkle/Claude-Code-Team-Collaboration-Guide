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

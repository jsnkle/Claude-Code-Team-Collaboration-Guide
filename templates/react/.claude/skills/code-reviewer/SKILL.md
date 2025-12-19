---
name: code-reviewer
description: Performs thorough code reviews focusing on quality, security, and best practices. Use when reviewing code changes, checking PRs, or analyzing code quality. Read-only access only.
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

This skill provides code review capabilities with **read-only** file access to ensure safe, non-destructive reviews.

## Review Process

1. **Understand Context**
   - What is the purpose of this change?
   - What problem does it solve?

2. **Examine Code Structure**
   - Use Glob to find related files
   - Use Grep to search for patterns
   - Use Read to examine file contents

3. **Apply Review Checklist**
   - Work through each category below
   - Note issues by severity

4. **Provide Feedback**
   - Organize by severity
   - Include specific file locations
   - Suggest concrete fixes

## Review Checklist

### Code Quality
- [ ] Clean, readable code following project style
- [ ] No code duplication (DRY principle)
- [ ] Appropriate abstractions and separation of concerns
- [ ] Clear naming for variables, functions, and classes
- [ ] Functions are focused and not too long

### Error Handling
- [ ] All error paths are handled
- [ ] Errors have meaningful messages
- [ ] Async errors are caught properly
- [ ] Edge cases are considered

### Security
- [ ] No hardcoded secrets or credentials
- [ ] User input is validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (proper escaping)
- [ ] Authentication/authorization checks present

### Performance
- [ ] No obvious performance issues
- [ ] No N+1 query patterns
- [ ] Appropriate use of memoization
- [ ] No unnecessary re-renders (React)
- [ ] Large lists are virtualized if needed

### Testing
- [ ] Tests exist for new functionality
- [ ] Edge cases are tested
- [ ] Tests are meaningful (not just coverage padding)
- [ ] Mocking is appropriate

### Documentation
- [ ] Complex logic is commented
- [ ] Public APIs are documented
- [ ] README updated if needed

## Feedback Format

Organize findings by severity:

### Critical (Must Fix Before Merge)
Issues that will cause bugs, security vulnerabilities, or major problems.

**Example:**
```
CRITICAL: SQL Injection vulnerability
Location: src/api/users.ts:45
Issue: User input directly concatenated into SQL query
Fix: Use parameterized queries instead
```

### High (Should Fix Before Merge)
Significant issues that affect maintainability or could cause problems.

### Medium (Consider Fixing)
Issues that would improve the code but aren't blocking.

### Suggestions (Nice to Have)
Minor improvements or alternative approaches to consider.

## Review Response Template

```markdown
## Code Review Summary

**Overall Assessment:** [Approve / Request Changes / Comment]

### Critical Issues
[List or "None found"]

### High Priority
[List or "None found"]

### Medium Priority
[List or "None found"]

### Suggestions
[List or "None"]

### What's Good
[Positive observations about the code]
```

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

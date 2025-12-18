---
model: sonnet
---

Create a pull request for the current branch: $ARGUMENTS

!git log --oneline main..HEAD
!git diff main..HEAD --stat

Based on the changes:
1. Write a clear PR title following our conventions
2. Summarize the changes in the description
3. List any breaking changes
4. Add testing instructions
5. Tag relevant reviewers

Use `gh pr create` to create the PR.

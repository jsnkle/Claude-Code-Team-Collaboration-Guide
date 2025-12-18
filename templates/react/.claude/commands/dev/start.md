---
model: sonnet
---

Initialize a development session for this project:

1. Check git status and current branch
2. Pull latest changes if on a feature branch
3. Check for any outstanding TODOs in recent changes
4. Verify dependencies are up to date
5. Start the development server if not running
6. Provide a brief summary of recent team activity

!git status
!git log --oneline -5
!git branch --show-current

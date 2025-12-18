---
model: haiku
---

Generate my daily standup update:

!git log --oneline --since="yesterday" --author="$(git config user.email)"
!git status --short

Based on my recent commits and current work:
1. What I completed yesterday
2. What I'm working on today
3. Any blockers

Format for Slack/Teams posting.

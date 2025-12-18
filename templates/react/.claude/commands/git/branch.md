---
model: haiku
---

Create a new feature branch based on the description: $ARGUMENTS

Follow our branch naming convention:
- Features: feature/{{TICKET_PREFIX}}-short-description
- Bugs: bugfix/{{TICKET_PREFIX}}-short-description
- Hotfix: hotfix/{{TICKET_PREFIX}}-short-description

Steps:
1. Fetch latest from origin
2. Ensure we're on main and it's up to date
3. Create new branch with proper naming
4. Push the new branch to origin

!git fetch origin
!git branch --show-current
!git status --short

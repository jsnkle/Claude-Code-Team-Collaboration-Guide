---
name: daily-standup
description: Generates daily standup summaries from recent git activity. Use when preparing for standup, summarizing work, or reporting progress.
---

# Daily Standup Summary

Generate a standup summary based on recent git activity across your projects.

## Instructions

1. Check git log for recent commits
2. Review any work-in-progress branches
3. Identify blockers or pending items
4. Format as a standup update

## Commands to Run

```bash
# Recent commits (last 24 hours)
git log --oneline --since="24 hours ago" --author="$(git config user.email)"

# Current branch status
git status --short

# Recent branches worked on
git branch --sort=-committerdate | head -5
```

## Standup Format

Generate a summary in this format:

### Yesterday
- What was completed (based on commits)
- Key accomplishments

### Today
- Current work-in-progress (based on branch/status)
- Planned tasks

### Blockers
- Any issues preventing progress
- Pending reviews or dependencies

## Example Output

```markdown
## Standup - [Date]

### Yesterday
- Completed user authentication module (3 commits)
- Fixed pagination bug in dashboard
- Updated API documentation

### Today
- Working on: payment integration (feature/payments branch)
- Need to: write tests for auth module
- Planning: review PR #45

### Blockers
- Waiting on API credentials from external team
- Need design review for checkout flow
```

## Tips

- Focus on outcomes, not just activity
- Mention any help needed
- Keep it concise (2-3 minutes when spoken)

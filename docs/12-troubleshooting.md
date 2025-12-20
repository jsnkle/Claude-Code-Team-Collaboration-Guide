# Part 10: Troubleshooting

## Common Issues

| Issue | Solution |
|-------|----------|
| Rules not loading | Check files are `.md` in `.claude/rules/` directory |
| Path-scoped rule not activating | Verify glob pattern matches your file paths |
| Commands not showing | Ensure files are in `.claude/commands/` with `.md` extension |
| Permissions not working | Check hierarchy - project settings override user settings |
| CLAUDE.md not loading | Verify file location and naming |
| Imports not working | Check path is correct, not inside code block |
| Hooks not firing | Check matcher patterns and script permissions |

## Useful Commands

```bash
/memory          # View all loaded memory files and rules
/config          # View current configuration
/help            # List all commands
/status          # Check status
/clear           # Clear conversation (use often!)
/login           # Re-authenticate
/agents          # Manage subagents
/init            # Bootstrap/update CLAUDE.md
```

---

[← Previous: Security](11-security.md) | [Back to Guide](../README.md) | [Next: Checkpoints →](13-checkpoints.md)

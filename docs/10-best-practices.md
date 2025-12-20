# Part 8: Best Practices for Team Collaboration

## Project Rules Strategy

| Rule Type | Use Case | Example |
|-----------|----------|---------|
| **Always Loaded** | Universal standards | code-style.md, git-workflow.md |
| **Path-Scoped** | Domain-specific rules | security.md → auth/**, payments/** |
| **User-Level** | Personal preferences | ~/.claude/rules/preferences.md |

## CLAUDE.md Best Practices

1. **Keep it lean** - Move detailed rules to `.claude/rules/`
2. **Ask Claude to edit** - Have Claude add instructions to CLAUDE.md during sessions
3. **Use imports** - Reference other docs with `@path/to/file`
4. **Review periodically** - Remove outdated instructions
5. **Commit changes** - Include CLAUDE.md updates in PRs

## Permission Strategy

| Environment | Approach |
|-------------|----------|
| Development | More permissive, allow common dev tools |
| Staging | Moderate, restrict production configs |
| Production | Restrictive, use enterprise policies |

## Slash Command Guidelines

1. **Namespace commands** - Use folders (`/dev/`, `/git/`, etc.)
2. **Use appropriate models** - `haiku` for simple, `sonnet` for complex, `opus` for critical
3. **Include `!` commands** - Pre-load context with bash output
4. **Document in the file** - Commands are self-documenting
5. **Use `$ARGUMENTS`** - Make commands flexible

## Subagent Strategy

- **Read-only agents** for review tasks (limit tools to Read, Grep, Glob)
- **Full-access agents** only when necessary
- **Descriptive names** so Claude auto-delegates appropriately
- **Concise prompts** - Under 500 lines performs better

## Hook Usage

### Available Hook Events

| Event | Purpose |
|-------|---------|
| `PreToolUse` | Before tool execution; can allow/deny/ask permission |
| `PostToolUse` | After tool completes; provide feedback to Claude |
| `PermissionRequest` | When permission dialog shown; allow/deny on behalf of user |
| `UserPromptSubmit` | Before Claude processes user prompt; validate/add context |
| `Stop` | When main agent finishes; control continuation |
| `SubagentStop` | When subagent finishes; control continuation |
| `Notification` | When notifications sent; filter by type |
| `PreCompact` | Before compacting context (manual/auto) |
| `SessionStart` | Session begins; load context/setup environment |
| `SessionEnd` | Session ends; cleanup tasks |

### Command Hooks (Bash)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.py)",
        "hooks": [{"type": "command", "command": "black \"$CLAUDE_FILE_PATH\"", "timeout": 60}]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash(rm:*)",
        "hooks": [{"type": "command", "command": "echo 'Warning: Delete operation'"}]
      }
    ]
  }
}
```

### Prompt-Based Hooks (LLM)

For events: `Stop`, `SubagentStop`, `UserPromptSubmit`, `PreToolUse`, `PermissionRequest`

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": ".*",
        "hooks": [{
          "type": "prompt",
          "prompt": "Evaluate if Claude should stop: $ARGUMENTS",
          "timeout": 30
        }]
      }
    ]
  }
}
```

### Environment Variables in Hooks

- `CLAUDE_PROJECT_DIR`: Project root directory
- `CLAUDE_FILE_PATH`: Path of file being operated on
- `CLAUDE_CODE_REMOTE`: Whether running in remote environment
- `CLAUDE_ENV_FILE`: (SessionStart only) Path to persist environment variables
- `CLAUDE_PLUGIN_ROOT`: (Plugin hooks) Root directory of the plugin

### MCP Tool Matching in Hooks

MCP tools follow pattern: `mcp__<server>__<tool>`
```json
{
  "matcher": "mcp__memory__.*"
}
```

---

[← Previous: Onboarding](09-onboarding.md) | [Back to Guide](../README.md) | [Next: Security →](11-security.md)

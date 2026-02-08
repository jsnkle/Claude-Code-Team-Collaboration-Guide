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
| Production | Restrictive — Team Plan: enforce via `managed-settings.json`; Individual Plans: use strict project-level deny rules |

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

### Available Hook Events (14 Events)

| Event | Purpose | Can block? |
|-------|---------|-----------|
| `SessionStart` | Session begins; load context/setup environment | No |
| `UserPromptSubmit` | Before Claude processes user prompt; validate/add context | Yes |
| `PreToolUse` | Before tool execution; can allow/deny/ask permission | Yes |
| `PermissionRequest` | When permission dialog shown; allow/deny on behalf of user | Yes |
| `PostToolUse` | After tool completes; provide feedback to Claude | No |
| `PostToolUseFailure` | After a tool call fails; provide error feedback | No |
| `Notification` | When notifications sent; filter by type | No |
| `SubagentStart` | When a subagent is spawned | No |
| `SubagentStop` | When subagent finishes; control continuation | Yes |
| `Stop` | When main agent finishes; control continuation | Yes |
| `TeammateIdle` | Agent team member becomes idle | Yes |
| `TaskCompleted` | Task is being marked completed | Yes |
| `PreCompact` | Before compacting context (manual/auto) | No |
| `SessionEnd` | Session ends; cleanup tasks | No |

### Command Hooks (Bash)

Matchers are **regex on the tool name only** — they don't filter on tool input. Your hook script reads the full tool input from stdin as JSON and inspects file paths, commands, etc. inside the script.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{"type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/scripts/lint-python.sh", "timeout": 60}]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{"type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/scripts/block-rm.sh"}]
      }
    ]
  }
}
```

### Prompt-Based Hooks (LLM)

Single-turn LLM evaluation. Returns a yes/no JSON decision.

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

### Agent-Based Hooks

Multi-turn subagent with tools (Read, Grep, Glob) to verify conditions. Up to 50 tool-use turns.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{
          "type": "agent",
          "prompt": "Verify the edited file follows project conventions: $ARGUMENTS",
          "timeout": 60
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
- `CLAUDE_ENV_FILE`: (SessionStart only) Path to persist environment variables for subsequent Bash commands
- `CLAUDE_PLUGIN_ROOT`: (Plugin hooks) Root directory of the plugin

Use `/hooks` to browse and configure hooks interactively.

### MCP Tool Matching in Hooks

MCP tools follow pattern: `mcp__<server>__<tool>`
```json
{
  "matcher": "mcp__memory__.*"
}
```

### Hook Caveats

**Stop hook infinite loop prevention:** Stop hooks receive a `stop_hook_active` field in their stdin JSON. If `true`, the hook is being called because a *previous* Stop hook continued the conversation. Your hook should exit 0 (allow stop) in this case to prevent infinite loops.

**PermissionRequest hooks don't fire in `-p` mode:** When running Claude in non-interactive mode (`-p`), `PermissionRequest` hooks are never triggered. Use `PreToolUse` hooks instead if you need to control tool permissions in headless/CI pipelines.

**Structured output varies by event:**
- `PreToolUse`: Return `{ "decision": "allow" | "deny" | "ask", "reason": "..." }`
- `PostToolUse` / `Stop`: Return `{ "decision": "block", "reason": "..." }` at top level to continue the conversation
- `PermissionRequest`: Return `{ "hookSpecificOutput": { "decision": { "behavior": "allow" | "deny" | "ask" } } }`

---

[← Previous: Onboarding](09-onboarding.md) | [Back to Guide](../README.md) | [Next: Security →](11-security.md)

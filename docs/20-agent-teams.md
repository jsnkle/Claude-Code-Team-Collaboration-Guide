# Part 20: Agent Teams

## Overview

Agent teams let you coordinate multiple Claude Code instances working together. One session acts as the **team lead**, coordinating work, assigning tasks, and synthesizing results. Teammates work independently, each in its own context window, and communicate directly with each other.

> **Experimental:** Agent teams are disabled by default. They have known limitations around session resumption, task coordination, and shutdown behavior. See [Limitations](#key-limitations) below.

Official docs: [Agent Teams](https://code.claude.com/docs/en/agent-teams)

## Agent Teams vs Subagents

Agent teams and [subagents](06-subagents.md) both parallelize work, but they operate differently. Choose based on whether your workers need to communicate with each other:

|  | Subagents | Agent Teams |
|--|-----------|-------------|
| **Context** | Own context window; results return to the caller | Own context window; fully independent |
| **Communication** | Report results back to the main agent only | Teammates message each other directly |
| **Coordination** | Main agent manages all work | Shared task list with self-coordination |
| **Best for** | Focused tasks where only the result matters | Complex work requiring discussion and collaboration |
| **Token cost** | Lower: results summarized back to main context | Higher: each teammate is a separate Claude instance |

Use **subagents** when you need quick, focused workers that report back. Use **agent teams** when teammates need to share findings, challenge each other, and coordinate on their own.

## Enabling Agent Teams

Enable agent teams by setting the `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` environment variable to `1`. You can do this in your shell or through [settings.json](04-configuration.md):

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

This can be set at any level of the [configuration hierarchy](01-feature-overview.md#memory--configuration-hierarchy) — project `settings.json` for team-wide enablement, or user/local settings for individual use.

## Configuration

### Display Mode (`teammateMode`)

Agent teams support two display modes, controlled by the `teammateMode` setting:

| Mode | Behavior | Requirements |
|------|----------|--------------|
| `"in-process"` | All teammates run inside your main terminal. Use `Shift+Up/Down` to select a teammate. | Any terminal |
| `"tmux"` | Each teammate gets its own split pane. | tmux or iTerm2 |
| `"auto"` (default) | Uses split panes if already inside a tmux session, otherwise in-process. | — |

Configure in `settings.json`:

```json
{
  "teammateMode": "in-process"
}
```

Or override per session with the CLI flag:

```bash
claude --teammate-mode in-process
```

**Split-pane requirements:**
- **tmux**: install through your system's package manager. `tmux -CC` in iTerm2 is the suggested entrypoint.
- **iTerm2**: install the [`it2` CLI](https://github.com/mkusaka/it2), then enable the Python API in iTerm2 Settings > General > Magic > Enable Python API.

### Delegate Mode

Delegate mode restricts the lead to coordination-only tools (spawning, messaging, shutting down teammates, managing tasks) so it doesn't start implementing tasks itself. Enable by pressing `Shift+Tab` to cycle into delegate mode after starting a team.

### Permissions

Teammates start with the lead's permission settings. If the lead runs with `--dangerously-skip-permissions`, all teammates do too. You can change individual teammate modes after spawning, but you can't set per-teammate modes at spawn time.

Pre-approve common operations in your [permission settings](04-configuration.md) before spawning teammates to reduce permission prompt interruptions.

## Quality Gate Hooks

Two hook events provide automation points for agent team workflows. See [Hooks](04-configuration.md#hook-events-reference-v219) for general hook configuration.

### `TeammateIdle`

Runs when a teammate is about to go idle. Exit with code 2 to send feedback and keep the teammate working.

```json
{
  "hooks": {
    "TeammateIdle": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/scripts/check-teammate-idle.sh"
          }
        ]
      }
    ]
  }
}
```

### `TaskCompleted`

Runs when a task is being marked complete. Exit with code 2 to prevent completion and send feedback.

```json
{
  "hooks": {
    "TaskCompleted": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/scripts/validate-task-completion.sh"
          }
        ]
      }
    ]
  }
}
```

The **exit code 2 pattern** is the key mechanism: your hook script runs validation checks (e.g., tests pass, linting clean, docs updated) and exits with code 2 plus a message to reject the completion and give the teammate actionable feedback.

## Best Practices

### Give Teammates Enough Context

Teammates load project context automatically (CLAUDE.md, MCP servers, skills) but don't inherit the lead's conversation history. Include task-specific details in the spawn prompt:

```
Spawn a security reviewer teammate with the prompt: "Review the authentication module
at src/auth/ for security vulnerabilities. Focus on token handling, session
management, and input validation. The app uses JWT tokens stored in
httpOnly cookies. Report any issues with severity ratings."
```

### Size Tasks Appropriately

- **Too small**: coordination overhead exceeds the benefit
- **Too large**: teammates work too long without check-ins, increasing risk of wasted effort
- **Just right**: self-contained units that produce a clear deliverable — a function, a test file, or a review

Having 5–6 tasks per teammate keeps everyone productive and lets the lead reassign work if someone gets stuck.

### Avoid File Conflicts

Two teammates editing the same file leads to overwrites. Break the work so each teammate owns a different set of files.

### Pre-Approve Permissions

Teammate permission requests bubble up to the lead, creating friction. Pre-approve common operations in your project's [settings.json](04-configuration.md) `permissions.allow` list before spawning teammates.

### Start with Research and Review

If you're new to agent teams, start with tasks that have clear boundaries and don't require writing code: reviewing a PR, researching a library, or investigating a bug. These show the value of parallel exploration without the coordination challenges of parallel implementation.

### Monitor and Steer

Check in on teammates' progress, redirect approaches that aren't working, and synthesize findings as they come in. Letting a team run unattended for too long increases the risk of wasted effort.

## Key Limitations

| Limitation | Detail |
|------------|--------|
| **No session resumption** | `/resume` and `/rewind` do not restore in-process teammates. After resuming, the lead may try to message teammates that no longer exist. |
| **One team per session** | Clean up the current team before starting a new one. |
| **No nested teams** | Teammates cannot spawn their own teams. Only the lead can manage the team. |
| **Lead is fixed** | The session that creates the team is the lead for its lifetime. You can't promote a teammate or transfer leadership. |
| **Split panes require tmux or iTerm2** | Not supported in VS Code's integrated terminal, Windows Terminal, or Ghostty. |
| **Task status can lag** | Teammates sometimes fail to mark tasks as completed, blocking dependent tasks. Nudge the teammate or update status manually. |
| **Shutdown can be slow** | Teammates finish their current request or tool call before shutting down. |
| **Permissions set at spawn** | All teammates start with the lead's permission mode. Per-teammate modes can only be changed after spawning. |

---

[← Previous: Quick Reference](18-quick-reference.md) | [Back to Guide](../README.md) | [Next: Resources →](19-resources.md)

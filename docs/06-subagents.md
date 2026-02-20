# Subagents

Subagents are specialized AI assistants with isolated context. Claude can delegate tasks to them automatically based on their descriptions, or you can invoke them explicitly.

## Subagent Configuration Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier (lowercase, hyphens) |
| `description` | Yes | Natural language purpose — helps Claude decide when to use |
| `tools` | No | Comma-separated tool list (inherits all if omitted). Use `Task(agent-name)` to restrict which sub-agents this agent can spawn |
| `disallowedTools` | No | Tools to deny, removed from inherited or specified list |
| `model` | No | Model alias: `sonnet`, `opus`, `haiku`, or `inherit` (default: `inherit`) |
| `permissionMode` | No | Permission mode: `default`, `acceptEdits`, `delegate`, `dontAsk`, `bypassPermissions`, or `plan` |
| `maxTurns` | No | Maximum number of agentic turns before the subagent stops |
| `skills` | No | Comma-separated skill names to auto-load. Full skill content is injected; subagents don't inherit skills from parent |
| `mcpServers` | No | MCP servers available to this subagent. Either a server name referencing an already-configured server or an inline `{name: config}` definition |
| `hooks` | No | Lifecycle hooks scoped to this subagent (supports `PreToolUse`, `PostToolUse`, `Stop`) |
| `memory` | No | Memory scope: `user`, `project`, or `local` (v2.1.33+) |
| `isolation` | No | Isolation mode: `"worktree"` runs the agent in its own git worktree (v2.1.49+) |
| `background` | No | When `true`, agent runs persistently in the background (v2.1.49+) |

## Code Reviewer Agent

**File:** `.claude/agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: Specialist for thorough code reviews focusing on quality, security, and best practices. Invoke when reviewing PRs or code changes.
tools: Read, Grep, Glob
model: sonnet
permissionMode: default
---

You are a senior code reviewer with expertise in identifying code quality issues, security vulnerabilities, and performance problems.

## Your Role
- Review code changes thoroughly and systematically
- Provide specific, actionable feedback
- Prioritize findings by severity
- Reference project coding standards from .claude/rules/

## Review Process
1. Understand the context and purpose of changes
2. Check for security vulnerabilities (especially in auth/payment code)
3. Evaluate code quality and maintainability
4. Assess test coverage adequacy
5. Verify documentation completeness

## Output Format
Organize findings by category:
- 🔴 **Critical**: Must fix before merge
- 🟠 **High**: Should fix before merge
- 🟡 **Medium**: Consider fixing
- 🟢 **Suggestion**: Nice to have improvements

Be constructive and explain WHY something should be changed, not just what.
```

## Test Writer Agent

**File:** `.claude/agents/test-writer.md`

```markdown
---
name: test-writer
description: Generates comprehensive unit and integration tests. Use when you need tests written for new or existing code.
tools: Read, Write, Bash, Grep, Glob
model: sonnet
---

You are a testing specialist focused on writing comprehensive, maintainable tests.

## Your Expertise
- Unit testing with Vitest
- Integration testing
- React component testing with Testing Library
- Mocking strategies with vi.fn() and vi.mock()
- Edge case identification

## Vitest Best Practices
- Use `describe` and `it` blocks (or `test`) for structure
- Leverage Vitest's built-in assertion matchers (`expect`)
- Use `vi.fn()` for function mocks, `vi.spyOn()` for spying
- Use `vi.mock()` for module mocking (hoisted automatically)
- Use `beforeEach`/`afterEach` for setup/teardown
- Use `vi.clearAllMocks()` or `vi.resetAllMocks()` between tests

## Test Writing Principles
1. Each test should test ONE thing
2. Use descriptive names: "should [expected behavior] when [condition]"
3. Follow AAA pattern: Arrange, Act, Assert
4. Mock external dependencies with `vi.mock()`
5. Cover edge cases and error conditions
6. Tests should be independent and idempotent

## Process
1. Analyze the code to be tested
2. Identify all code paths and edge cases
3. Write tests for happy path first
4. Add tests for error conditions
5. Verify all tests pass: `pnpm test`
6. Check coverage: `pnpm test:coverage`
```

## Security Scanner Agent

**File:** `.claude/agents/security-scanner.md`

```markdown
---
name: security-scanner
description: Analyzes code for security vulnerabilities. Use when reviewing security-critical code or before releases.
tools: Read, Grep, Glob, Bash
model: opus
---

You are a security specialist focused on identifying vulnerabilities in code.

## Your Expertise
- OWASP Top 10 vulnerabilities
- Authentication/authorization flaws
- Injection attacks (SQL, XSS, Command)
- Sensitive data exposure
- Security misconfiguration

## Scan Process
1. Identify security-critical areas (auth, payments, admin)
2. Check for common vulnerabilities
3. Review input validation
4. Examine data handling practices
5. Verify access controls
6. Check for hardcoded secrets

## Output Format
Report findings with:
- **Severity**: Critical / High / Medium / Low
- **Location**: File and line number
- **Description**: What the vulnerability is
- **Impact**: What could happen if exploited
- **Recommendation**: How to fix it
- **Reference**: OWASP or CWE identifier if applicable
```

## Built-in Subagents

Claude Code includes several built-in subagents:

| Subagent | Model | Tools | Purpose |
|----------|-------|-------|---------|
| **General-Purpose** | Inherits | All tools | Complex research, multi-step operations, code modifications |
| **Plan** | Inherits | Read-only (denied Write/Edit) | Codebase research for planning (used during plan mode) |
| **Explore** | Haiku | Read-only (denied Write/Edit) | Fast codebase exploration with thoroughness levels: quick, medium, very thorough |
| **Bash** | Inherits | Terminal commands | Running terminal commands in a separate context |
| **statusline-setup** | Sonnet | — | Configuring the status line (triggered via `/statusline`) |
| **Claude Code Guide** | Haiku | — | Answering questions about Claude Code features |

## Resumable Subagents

Subagents can be resumed to continue previous work:

```bash
> Resume agent abc123 and now analyze the authorization logic as well
```

Each execution gets a unique `agentId`. The full transcript is stored at `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl`. Full context is preserved when resumed, making this useful for long-running research or analysis tasks.

## Foreground vs Background Behavior

- **Foreground subagents**: Block the main conversation until complete. Permission prompts and `AskUserQuestion` are passed through to you.
- **Background subagents**: Run concurrently. Before launching, Claude Code prompts for any tool permissions the subagent will need upfront. Once running, the subagent inherits these permissions and auto-denies anything not pre-approved. MCP tools are **not** available in background subagents. Background agents return a final answer summary rather than the raw transcript (v2.1.47+).

Claude decides foreground vs background based on the task. You can also:
- Ask Claude to "run this in the background"
- Press **Ctrl+B** to background a running task
- Press **Ctrl+F** (two-press confirmation) to kill background agents (v2.1.49+)

To disable all background task functionality: set `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1`.

### Always-On Background Agents (v2.1.49+)

Set `background: true` in agent frontmatter to create an agent that runs persistently in the background:

```markdown
---
name: watcher
description: Monitors test output and reports failures.
background: true
tools: Bash, Read
---
```

### Worktree Isolation (v2.1.49+)

Set `isolation: "worktree"` to run the agent in its own git worktree, preventing file conflicts with the main session:

```markdown
---
name: parallel-worker
description: Works on a separate feature in isolation.
isolation: worktree
tools: Read, Write, Edit, Bash, Grep, Glob
---
```

Also available via the `--worktree` (`-w`) CLI flag to launch an entire Claude session in an isolated worktree.

## `--agents` CLI Flag

Define subagents dynamically via JSON for a single session (not saved to disk):

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  },
  "debugger": {
    "description": "Debugging specialist for errors and test failures.",
    "prompt": "You are an expert debugger. Analyze errors, identify root causes, and provide fixes."
  }
}'
```

The `--agents` flag accepts JSON with the same frontmatter fields: `description`, `prompt`, `tools`, `disallowedTools`, `model`, `permissionMode`, `mcpServers`, `hooks`, `maxTurns`, `skills`, `memory`, `isolation`, and `background`.

## Agent Teams

Agent teams are a separate concept from subagents — they coordinate multiple independent Claude Code sessions that communicate with each other, rather than child tasks that report back. See [Part 19: Agent Teams](19-agent-teams.md) for full documentation including configuration, hooks, and best practices.

## Agent Memory (v2.1.33+)

The `memory` frontmatter field gives an agent persistent memory that Claude automatically records and recalls across sessions. This is useful for agents that build up project knowledge over time.

| Scope | Persists Across | Storage Path |
|-------|-----------------|--------------|
| `user` | All projects for this user | `~/.claude/agent-memory/<name>/` |
| `project` | All sessions in this project | `.claude/agent-memory/<name>/` |
| `local` | All sessions in this project (not shared) | `.claude/agent-memory-local/<name>/` |

```markdown
---
name: code-reviewer
description: Reviews code changes with persistent knowledge of past review decisions.
tools: Read, Grep, Glob
memory: project
---
```

With `memory: project`, the agent remembers patterns it's seen, decisions made in past reviews, and project-specific conventions — without being re-told each session.

## Restricting Sub-Agent Access (v2.1.33+)

Use `Task(agent-name)` syntax in the `tools` field to control which sub-agents an agent can spawn. This prevents agents from delegating to agents they shouldn't have access to.

```markdown
---
name: orchestrator
description: Coordinates code changes by delegating to specialized agents.
tools: Read, Write, Bash, Task(code-reviewer), Task(test-writer)
---
```

This agent can only spawn `code-reviewer` and `test-writer` sub-agents — it cannot invoke `security-scanner` or any other agent. Without `Task(...)` restrictions, agents inherit access to all available sub-agents.

You can also disable sub-agent access entirely by omitting `Task` from the tools list while specifying other tools explicitly.

## Managing Subagents

Use `/agents` interactively to view, create, edit, and delete subagents. It shows all available subagents (built-in, user, project, and plugin) and supports creating new ones with guided setup or Claude generation.

## Task Tool Metrics (v2.1.41+)

When a subagent completes, the Task tool result includes token count, tool uses, and duration metrics. These are useful for monitoring subagent efficiency and cost.

## Auto-Compaction

Subagents auto-compact at approximately 95% context capacity, using the same logic as the main conversation. Set `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` to trigger earlier (e.g., `50` for 50%). Compaction events are logged in subagent transcript files.

## Subagent Strategy

- **Read-only agents** for review tasks (limit tools to Read, Grep, Glob)
- **Full-access agents** only when necessary
- **Descriptive names** so Claude auto-delegates appropriately
- **Concise prompts** - Under 500 lines performs better
- **Scope memory appropriately** - Use `project` for team-shared knowledge, `local` for individual preferences

---

[← Previous: Slash Commands](05-slash-commands.md) | [Back to Guide](../README.md) | [Next: Skills →](07-skills.md)

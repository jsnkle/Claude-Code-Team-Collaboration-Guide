# Part 16: Quick Reference Card

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Alt+T` | Toggle extended thinking mode (sticky across sessions) |
| `Shift+Tab` | Toggle plan mode / cycle permission modes |
| `Ctrl+R` | Search prompt history |
| `Ctrl+C` | Cancel current operation |
| `Ctrl+D` | Exit Claude Code session |
| `Ctrl+L` | Clear terminal screen (keeps conversation) |
| `Ctrl+Z` | Suspend Claude Code (resume with `fg`) |
| `Ctrl+B` | Run bash command or agent in background (unified in v2.1+) |
| `Ctrl+F` | Kill background agents (two-press confirmation, v2.1.49+) |
| `Ctrl+G` | Edit prompt in system text editor |
| `Ctrl+J` | Insert newline (control sequence) |
| `Ctrl+Y` | Paste deleted text (readline-style yank) |
| `Alt+Y` | Cycle through kill ring history (yank-pop) |
| `Ctrl+O` | Toggle verbose output mode (shows real-time thinking in v2.1+) |
| `Ctrl+T` (in `/theme`) | Toggle syntax highlighting |
| `Alt+P` / `Option+P` | Switch models while typing |
| `Alt+V` (Windows) | Paste image from clipboard |
| `Esc + Esc` | Open rewind menu |
| `\` + `Enter` | Insert newline (quick escape) |
| `Option+Enter` (Mac) | Insert newline (macOS default) |
| `Shift+Enter` | Insert newline (native in iTerm2, WezTerm, Ghostty, Kitty) |
| `Alt+M` | Toggle permission modes (alternative to Shift+Tab) |
| `@` path | File/folder autocomplete and reference |
| `#` at start | Add to CLAUDE.md memory shortcut |
| `!` command | Direct bash execution |
| `&` message | Send as background task |

**Note:** On macOS, keyboard shortcuts display 'opt' instead of 'alt' (e.g., `Option+T` instead of `Alt+T`).

**Terminal Setup:** Run `/terminal-setup` to configure your terminal for optimal Claude Code experience. Supported terminals include iTerm2, Kitty, Alacritty, Zed, Warp, WezTerm, and Ghostty.

**Customizable Keybindings (v2.1.18+):** Run `/keybindings` to customize keyboard shortcuts with chord sequence support. Keybindings are context-aware and stored in `~/.claude/keybindings.json`. The `chat:newline` keybinding can be customized for multi-line input (v2.1.47+).

## Vim Motions (v2.1+)

Enhanced Vim support with additional motions:

| Motion | Action |
|--------|--------|
| `y` / `yy` / `Y` | Yank (copy) text |
| `p` / `P` | Paste yanked text |
| `;` | Repeat last f/t motion |
| `,` | Repeat last f/t motion in reverse |
| `>>` / `<<` | Indent/dedent line |
| `J` | Join lines |
| Text objects | `iw`, `aw`, `i"`, `a"`, `i(`, `a(`, etc. |

## Memory & Rules Locations

| Type | Location | Shared |
|------|----------|--------|
| Project Memory | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team (git) |
| Project Rules | `./.claude/rules/*.md` | Team (git) |
| Project Skills | `./.claude/skills/*/SKILL.md` | Team (git) |
| Project Local | `./CLAUDE.local.md` | No (gitignored) |
| User Memory | `~/.claude/CLAUDE.md` | No |
| User Rules | `~/.claude/rules/*.md` | No |
| User Skills | `~/.claude/skills/*/SKILL.md` | No |
| Output Styles | `./.claude/output-styles/*.md` | Team (git) |

## Path-Scoped Rule Syntax

```markdown
---
paths:
  - src/api/**/*.ts
  - src/auth/**/*
---

# Rules that only apply to matching files
```

## Import Syntax

```markdown
@README.md                           # Relative path
@docs/architecture.md                # Subdirectory
@~/.claude/my-preferences.md         # Home directory
@README.md#installation              # File with anchor fragment (v2.1.41+)
```

## Useful Verification Commands

These built-in commands help verify team configurations are loaded correctly:

| Command | Purpose |
|---------|---------|
| `/memory` | View all loaded memories and rules - verify team configs loaded |
| `/help` | Show all commands including custom team commands |
| `/doctor` | Diagnose configuration issues (includes auto-update channel info) |
| `/plan` | Enter plan mode directly (v2.1+) |
| `/stats` | View usage metrics and trends (supports date range filtering v2.1.6+) |
| `/config` | Search and filter settings (v2.1.6+) |
| `/debug` | Session troubleshooting (v2.1.30+) |
| `/context` | Display context token count with colored output (v2.1.27+) |
| `/keybindings` | Customize keyboard shortcuts with chord support (v2.1.18+) |
| `/sandbox` | Show sandbox dependency status with install instructions (v2.1.20+) |
| `/teleport` | Remote session management (v2.1+) |
| `/remote-env` | Remote environment management (v2.1+) |

## CLI Flags

| Flag | Purpose |
|------|---------|
| `-p`, `--print` | Run non-interactively (Agent SDK / headless mode) |
| `-c`, `--continue` | Continue most recent conversation in current directory |
| `-r`, `--resume <id\|name>` | Resume a specific session by ID or name |
| `--model <name>` | Set model for the session (`sonnet`, `opus`, or full model ID) |
| `--fallback-model <name>` | Auto-fallback when default model is overloaded (print mode only) |
| `--output-format <fmt>` | Output format: `text`, `json`, `stream-json` (print mode only) |
| `--json-schema <schema>` | Validate JSON output against schema (print mode only) |
| `--max-turns <n>` | Limit agentic turns (print mode only) |
| `--max-budget-usd <n>` | Spending limit before stopping (print mode only) |
| `--allowedTools <tools>` | Tools that execute without permission prompts |
| `--disallowedTools <tools>` | Tools removed from the model's context |
| `--tools <tools>` | Restrict available built-in tools (`""` to disable all, `"default"` for all) |
| `--system-prompt <text>` | Replace entire system prompt |
| `--append-system-prompt <text>` | Append to default system prompt |
| `--append-system-prompt-file <f>` | Append file contents to system prompt (print mode only) |
| `--permission-mode <mode>` | Start in specified permission mode |
| `-w`, `--worktree` | Launch Claude in an isolated git worktree (v2.1.49+) |
| `--agents <json>` | Define custom subagents dynamically via JSON |
| `--agent <name>` | Specify an agent for the session |
| `--from-pr <number\|url>` | Resume session linked to a GitHub PR |
| `--add-dir <path>` | Add directory for skills and CLAUDE.md loading |
| `--mcp-config <path>` | Load MCP servers from JSON files |
| `--strict-mcp-config` | Only use MCP servers from `--mcp-config` |
| `--plugin-dir <path>` | Load plugins from directory (repeatable) |
| `--remote <task>` | Create a web session on claude.ai |
| `--teleport` | Resume a web session in local terminal |
| `--setting-sources <list>` | Comma-separated setting sources: `user`, `project`, `local` |
| `--init-only` | Run initialization hooks and exit |
| `--maintenance` | Run maintenance hooks and exit |
| `--fork-session` | Create new session ID when resuming |
| `--teammate-mode <mode>` | Agent team display: `auto`, `in-process`, `tmux` |
| `--verbose` | Enable verbose logging (shows full turn-by-turn output) |
| `--debug [categories]` | Debug mode with optional category filtering (e.g., `"api,mcp"`) |
| `--dangerously-skip-permissions` | Skip all permission prompts (use with caution) |

## PR Integration (v2.1.20+)

- PR review status indicator in prompt footer (approved/changes requested/pending/draft)
- Sessions auto-linked to PRs when created via `gh pr create` (v2.1.27+)
- Merged PRs display purple status indicator (v2.1.23+)

For the complete list of built-in slash commands and CLI flags, see the [official CLI reference](https://code.claude.com/docs/en/cli-reference).

## Permission Patterns

- `Bash(npm *)` - All npm commands (space-based wildcard)
- `Bash(pnpm *)` - All pnpm commands
- `Read(src/**)` - All files in src recursively
- `Edit(*.ts)` - All TypeScript files
- `WebFetch(domain:github.com)` - Specific domain
- `Task(code-reviewer)` - Specific subagent
- `Skill(deploy *)` - Skill with prefix match
- `mcp__server__*` - All tools from a specific MCP server (wildcard)
- `mcp__github__*` - All GitHub MCP tools
- `mcp__memory__create_entities` - Specific MCP tool

---

[← Previous: Additional Features](17-additional-features.md) | [Back to Guide](../README.md) | [Next: Agent Teams →](19-agent-teams.md)

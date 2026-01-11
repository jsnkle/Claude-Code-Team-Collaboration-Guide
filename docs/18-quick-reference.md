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
```

## Useful Verification Commands

These built-in commands help verify team configurations are loaded correctly:

| Command | Purpose |
|---------|---------|
| `/memory` | View all loaded memories and rules - verify team configs loaded |
| `/help` | Show all commands including custom team commands |
| `/doctor` | Diagnose configuration issues |
| `/plan` | Enter plan mode directly (v2.1+) |
| `/stats` | View usage metrics and trends |
| `/teleport` | Remote session management (v2.1+) |
| `/remote-env` | Remote environment management (v2.1+) |

For the complete list of built-in slash commands and CLI flags, see the [official CLI reference](https://code.claude.com/docs/en/cli-reference).

## Permission Patterns

- `Bash(pnpm:*)` - All pnpm commands (colon syntax)
- `Bash(npm *)` - All npm commands (v2.1+ wildcard syntax)
- `Read(src/**)` - All files in src recursively
- `Edit(*.ts)` - All TypeScript files
- `WebFetch(domain:github.com)` - Specific domain
- `mcp__server__*` - All tools from a specific MCP server (wildcard)
- `mcp__github__*` - All GitHub MCP tools
- `mcp__memory__create_entities` - Specific MCP tool

---

[← Previous: Additional Features](17-additional-features.md) | [Back to Guide](../README.md) | [Next: Resources →](19-resources.md)

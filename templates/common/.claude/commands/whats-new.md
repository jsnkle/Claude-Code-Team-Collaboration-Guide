---
model: haiku
---

<!-- Update: 2025-02 -->

# What's New in Claude Code

Here are the latest feature highlights for your team. Share these tips in your next standup or Slack channel!

## Recent Highlights (v2.1.33)

### 1. Hooks System
Claude Code now supports lifecycle hooks — run custom scripts on events like `PreToolUse`, `PostToolUse`, `SessionStart`, and more. Use them to auto-format files, enforce lint rules, or bootstrap dev environments.
**Try it:** Check `.claude/settings.json` for the `hooks` key.

### 2. Agent Skills (SKILL.md)
Define reusable skills in `.claude/skills/` that Claude can invoke for specialized tasks like generating commit messages or scaffolding components.
**Try it:** Run `/commit` to see the commit-helper skill in action.

### 3. Output Styles
Customize Claude's response format with `.claude/output-styles/*.md` files or the `--output-style` flag. Great for enforcing review formats or audit-style reports.
**Try it:** `claude --output-style concise`

### 4. Agent Teams (Research Preview)
Delegate work to specialized sub-agents with their own tools and instructions. Useful for splitting code review, testing, and documentation tasks.
**Try it:** See `.claude/agents/` for team-configured sub-agents.

### 5. Plugin Pinning
Pin tool versions for reproducible team setups. Ensures everyone uses the same MCP server versions.
**Try it:** Add `pinnedPlugins` to your settings.json.

### 6. Path-Scoped Rules
Rules can now target specific directories — e.g., stricter security rules for `src/auth/` or different style rules for legacy code.
**Try it:** Add a `globs` field to any rule file's frontmatter.

### 7. Session Memory via /memory
Use `/memory` to see all loaded context files (CLAUDE.md, rules, etc.) at a glance. Helpful for verifying your configuration is loaded correctly.
**Try it:** Run `/memory` in any session.

### 8. Keyboard Shortcuts & Keybindings
Customize keybindings via `~/.claude/keybindings.json` — remap submit, add chord shortcuts, and more.
**Try it:** Run `/keybindings-help` for setup guidance.

---

*Run this command anytime with `/whats-new`. Update the version marker above when refreshing content so the session hook re-notifies developers.*

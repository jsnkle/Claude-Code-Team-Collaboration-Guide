# Part 3: Recommended Directory Structure

## Project Structure

After copying templates, your project will have this structure:

```
your-project/
├── .claude/
│   ├── CLAUDE.md                    # Project context and overview
│   ├── settings.json                # Permissions, hooks, environment
│   ├── settings.local.json          # Personal overrides (gitignored)
│   │
│   ├── rules/                       # Coding standards (from templates)
│   │   ├── code-style.md            # Formatting, naming (from common/)
│   │   ├── git-workflow.md          # Branching, commits (from common/)
│   │   ├── testing.md               # Test requirements (from common/)
│   │   └── react.md                 # React patterns (from react/)
│   │
│   ├── skills/                      # Agent skills
│   │   ├── commit-helper/
│   │   │   └── SKILL.md             # Conventional commits (from common/)
│   │   └── component-scaffolder/
│   │       └── SKILL.md             # Component scaffolding (from react/)
│   │
│   ├── commands/                    # Slash commands
│   │   ├── git/                     # Git commands (from common/)
│   │   │   ├── branch.md
│   │   │   ├── commit.md
│   │   │   └── pr.md
│   │   ├── dev/                     # Dev commands (from react/)
│   │   │   ├── start.md
│   │   │   ├── test.md
│   │   │   └── lint.md
│   │   ├── review.md                # Code review (from common/)
│   │   ├── debug.md                 # Debugging (from common/)
│   │   └── docs.md                  # Documentation (from common/)
│   │
│   └── agents/                      # Subagents
│       ├── code-reviewer.md         # Generic reviewer (from common/)
│       └── test-writer.md           # React tests (from react/)
│
├── CLAUDE.local.md                  # Personal additions (gitignored)
└── ... (your project files)
```

## Template Composition

Templates are designed to be **composable**. The structure above results from:

```bash
cp -r templates/common/.claude ./    # Universal best practices
cp -r templates/react/.claude ./     # React-specific (merges with common)
```

Adding more stack templates adds their rules, commands, and agents:

```bash
cp -r templates/express/.claude ./   # Would add express.md, api-security.md, etc.
```

## User-Level Structure

Each developer can have personal preferences in `~/.claude/`:

```
~/.claude/
├── CLAUDE.md                   # Personal preferences across all projects
├── settings.json               # Personal global settings
├── rules/                      # Personal rules
├── skills/                     # Personal skills
├── commands/                   # Personal slash commands
└── agents/                     # Personal subagents
```

## Key Points

- **Project-level** (`.claude/`) is committed to git and shared with team
- **User-level** (`~/.claude/`) is personal and applies to all projects
- **settings.local.json** and **CLAUDE.local.md** are gitignored for personal overrides
- Templates **merge** - later copies add to earlier ones

---

[← Previous: Project Rules](02-project-rules.md) | [Back to Guide](../README.md) | [Next: Configuration Files →](04-configuration.md)

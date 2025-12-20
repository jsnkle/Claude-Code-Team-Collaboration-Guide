# Part 3: Recommended Directory Structure

## Complete Project Structure

```
your-project/
├── .claude/
│   ├── CLAUDE.md                    # Core project overview (keep lean)
│   ├── settings.json                # Team permissions & config (commit to git)
│   ├── settings.local.json          # Personal overrides (auto-gitignored)
│   │
│   ├── rules/                       # Modular project rules
│   │   ├── code-style.md            # Always loaded - formatting standards
│   │   ├── git-workflow.md          # Always loaded - branching, commits
│   │   ├── testing.md               # Always loaded - test requirements
│   │   ├── api-rules.md             # paths: src/api/**/*
│   │   ├── frontend-rules.md        # paths: src/components/**/*
│   │   ├── database-rules.md        # paths: src/models/**/*
│   │   └── security.md              # paths: src/auth/**, src/payments/**
│   │
│   ├── skills/                      # Agent skills (model-invoked)
│   │   ├── commit-helper/           # Each skill in its own folder
│   │   │   └── SKILL.md
│   │   └── code-reviewer/
│   │       └── SKILL.md
│   │
│   ├── commands/                    # Team slash commands
│   │   ├── dev/
│   │   │   ├── start.md             # /dev/start - Initialize dev session
│   │   │   ├── test.md              # /dev/test - Run test suite
│   │   │   └── lint.md              # /dev/lint - Run linters
│   │   ├── git/
│   │   │   ├── branch.md            # /git/branch - Create feature branch
│   │   │   ├── commit.md            # /git/commit - Smart commit
│   │   │   └── pr.md                # /git/pr - Create pull request
│   │   ├── review.md                # /review - Code review checklist
│   │   ├── debug.md                 # /debug - Systematic debugging
│   │   └── docs.md                  # /docs - Generate documentation
│   │
│   └── agents/                      # Team subagents
│       ├── code-reviewer.md         # Code review specialist
│       ├── test-writer.md           # Unit test generation
│       ├── security-scanner.md      # Security analysis
│       └── documenter.md            # Documentation generator
│
├── .mcp.json                        # MCP server configurations (optional)
├── CLAUDE.md                        # Alternative location for main instructions
├── CLAUDE.local.md                  # Personal additions (gitignored)
└── ... (your project files)
```

## User-Level Structure (Each Developer)

```
~/.claude/
├── CLAUDE.md                   # Personal preferences across all projects
├── settings.json               # Personal global settings
├── settings.local.json         # Machine-specific overrides
├── rules/                      # Personal rules for all projects
│   ├── preferences.md
│   └── workflows.md
├── skills/                     # Personal skills
│   └── my-workflow/
│       └── SKILL.md
├── commands/                   # Personal slash commands
│   ├── my-workflow.md
│   └── standup.md
└── agents/                     # Personal subagents
    └── personal-assistant.md
```

---

[← Previous: Project Rules](02-project-rules.md) | [Back to Guide](../README.md) | [Next: Configuration Files →](04-configuration.md)

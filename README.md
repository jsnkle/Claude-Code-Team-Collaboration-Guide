# Claude Code Team Collaboration Templates

A practical template repository for deploying Claude Code across development teams. Templates are **composable** — mix and match common foundations with stack-specific configurations.

**Compatible with Claude Code v2.0.74**

## Who This Guide Is For

Claude Code uses a [hierarchical configuration system](docs/01-feature-overview.md) with four levels: Enterprise → User → Project → Project Local. This guide focuses on **project-level configuration** — the `.claude/` directory and files you commit to git.

| Your Situation | How This Guide Helps |
|----------------|---------------------|
| **Team without Enterprise tier** | This is your *primary mechanism* for standardizing Claude Code across your team. Use these templates to establish shared rules, commands, and workflows. |
| **Team with Enterprise tier** | Your organization's `managed-settings.json` handles org-wide policies. Use this guide for *project-specific* context, commands, and agents that sit beneath those guardrails. |

Both scenarios benefit from project-level configuration — the difference is whether you have an additional enterprise layer above it.

## Quick Start

Templates are **composable**. Start with `common/` for universal best practices, then add stack-specific templates.

### 1. Copy Templates to Your Project

```bash
# Always start with common
cp -r templates/common/.claude /path/to/your-project/

# Add stack-specific template (merges with common)
cp -r templates/react/.claude /path/to/your-project/
```

### 2. Customize Placeholders

Edit `.claude/CLAUDE.md` and replace placeholders:

| Placeholder | Description |
|-------------|-------------|
| `{{PROJECT_NAME}}` | Your project's name |
| `{{PROJECT_DESCRIPTION}}` | Brief project description |
| `{{TECH_STACK}}` | Your technology stack |
| `{{KEY_DIRECTORIES}}` | Important directories in your project |
| `{{TECH_LEAD}}` | Tech lead contact |
| `{{DEVOPS_CONTACT}}` | DevOps contact |
| `{{TICKET_PREFIX}}` | JIRA/ticket prefix (in git-workflow.md) |

### 3. Commit and Use

```bash
git add .claude/
git commit -m "chore: add Claude Code team configuration"

# Start using
claude
/memory    # Verify rules loaded
/help      # See available commands
```

## Available Templates

| Template | Purpose | Status |
|----------|---------|--------|
| `common/` | Universal best practices (git, code style, testing) | Available |
| `react/` | React + TypeScript + Vite + Vitest | Available |
| `express/` | Express.js API development | Planned |
| `hono/` | Hono API framework | Planned |
| `nestjs/` | NestJS framework | Planned |
| `python/` | Python development | Planned |

### Composing Templates

```bash
# React SPA
cp -r templates/common/.claude ./
cp -r templates/react/.claude ./

# Full-stack (when express is available)
cp -r templates/common/.claude ./
cp -r templates/react/.claude ./
cp -r templates/express/.claude ./

# API only (when express is available)
cp -r templates/common/.claude ./
cp -r templates/express/.claude ./
```

## Template Contents

### `common/` — Universal Best Practices

```
templates/common/.claude/
├── CLAUDE.md                    # Project context template
├── settings.json                # Base permissions (git, file operations)
├── rules/
│   ├── code-style.md            # Formatting, naming conventions
│   ├── git-workflow.md          # Branch naming, commits, PRs
│   └── testing.md               # Testing philosophy
├── commands/
│   ├── git/
│   │   ├── branch.md            # /git/branch
│   │   ├── commit.md            # /git/commit
│   │   └── pr.md                # /git/pr
│   ├── review.md                # /review
│   ├── debug.md                 # /debug
│   └── docs.md                  # /docs
├── agents/
│   └── code-reviewer.md         # Generic code review agent
└── skills/
    └── commit-helper/
        └── SKILL.md             # Conventional commits helper
```

### `react/` — React-Specific

```
templates/react/.claude/
├── CLAUDE.md                    # React project context
├── settings.json                # React tooling (vite, vitest, etc.)
├── rules/
│   └── react.md                 # React patterns, hooks, components
├── commands/
│   └── dev/
│       ├── start.md             # /dev/start
│       ├── test.md              # /dev/test
│       └── lint.md              # /dev/lint
└── agents/
    └── test-writer.md           # React Testing Library specialist
```

## Documentation

- **[Claude Code Docs](https://code.claude.com/docs)** - Official documentation
- **[Changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)** - Latest features

### Guide Contents

| Part | Section | Description |
|------|---------|-------------|
| 1 | [Feature Overview](docs/01-feature-overview.md) | Core features, v2.0+ additions, memory hierarchy |
| 2 | [Project Rules System](docs/02-project-rules.md) | Modular rules, path-scoped activation |
| 3 | [Directory Structure](docs/03-directory-structure.md) | Complete project layout |
| 4 | [Configuration Files](docs/04-configuration.md) | CLAUDE.md, rules, settings.json examples |
| 5 | [Slash Commands](docs/05-slash-commands.md) | Team slash commands for common workflows |
| 6 | [Subagents](docs/06-subagents.md) | Specialized AI assistants for delegation |
| 7 | [Agent Skills](docs/07-skills.md) | Model-invoked capabilities, SKILL.md format |
| 8 | [CLAUDE.md Imports](docs/08-imports.md) | Import syntax, recursive imports |
| 9 | [Team Onboarding](docs/09-onboarding.md) | Pre-onboarding setup, developer steps |
| 10 | [Best Practices](docs/10-best-practices.md) | Rules strategy, permissions, commands |
| 11 | [Security](docs/11-security.md) | Permission deny rules, security best practices |
| 12 | [Troubleshooting](docs/12-troubleshooting.md) | Common issues, useful commands |
| 13 | [Checkpoints & Recovery](docs/13-checkpoints.md) | Code state snapshots |
| 14 | [Plugin System](docs/14-plugins.md) | Installing and distributing plugins |
| 15 | [Custom Output Styles](docs/15-output-styles.md) | Team-distributed output styles |
| 16 | [VS Code Extension](docs/16-vscode-extension.md) | IDE integration |
| 17 | [Team-Configurable Features](docs/17-additional-features.md) | Sandbox mode, env vars |
| 18 | [Quick Reference](docs/18-quick-reference.md) | Keyboard shortcuts, patterns |
| 19 | [Resources](docs/19-resources.md) | Official docs, community resources |

## Team Onboarding

### For DevOps/Team Leads

1. Copy `common/` + stack template(s) to your project
2. Customize `.claude/CLAUDE.md` with project details
3. Review and adjust rules for your team's standards
4. Test with `claude` and verify with `/memory`
5. Commit and share with team

### For Developers

1. Pull the project (includes `.claude/` directory)
2. Run `claude` in the project
3. Verify with `/memory` and `/help`

---

*Template Version: 2.0 | Compatible with Claude Code v2.0.74*

**Created by Jason Kellie | MIT License**

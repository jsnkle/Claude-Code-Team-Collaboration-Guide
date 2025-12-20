# Claude Code Team Collaboration Templates

A practical template repository for deploying Claude Code across development teams. Copy these templates into your projects to establish consistent AI-assisted development workflows.

**Compatible with Claude Code v2.0.74**

## Who This Guide Is For

Claude Code uses a [hierarchical configuration system](docs/01-feature-overview.md) with four levels: Enterprise → User → Project → Project Local. This guide focuses on **project-level configuration** — the `.claude/` directory and files you commit to git.

| Your Situation | How This Guide Helps |
|----------------|---------------------|
| **Team without Enterprise tier** | This is your *primary mechanism* for standardizing Claude Code across your team. Use these templates to establish shared rules, commands, and workflows. |
| **Team with Enterprise tier** | Your organization's `managed-settings.json` handles org-wide policies. Use this guide for *project-specific* context, commands, and agents that sit beneath those guardrails. |

Both scenarios benefit from project-level configuration — the difference is whether you have an additional enterprise layer above it.

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
| 7 | [Agent Skills](docs/07-skills.md) | Model-invoked capabilities, SKILL.md format, examples |
| 8 | [CLAUDE.md Imports](docs/08-imports.md) | Import syntax, recursive imports, viewing loaded memories |
| 9 | [Team Onboarding](docs/09-onboarding.md) | Pre-onboarding setup, developer steps, verification |
| 10 | [Best Practices](docs/10-best-practices.md) | Rules strategy, permissions, commands, hooks |
| 11 | [Security](docs/11-security.md) | Permission deny rules, security best practices |
| 12 | [Troubleshooting](docs/12-troubleshooting.md) | Common issues, useful commands |
| 13 | [Checkpoints & Recovery](docs/13-checkpoints.md) | Brief overview of checkpoint feature |
| 14 | [Plugin System](docs/14-plugins.md) | Installing, configuring, distributing team plugins |
| 15 | [Custom Output Styles](docs/15-output-styles.md) | Team-distributed output styles |
| 16 | [VS Code Extension](docs/16-vscode-extension.md) | Brief note on extension compatibility |
| 17 | [Team-Configurable Features](docs/17-additional-features.md) | Sandbox mode, environment variables, model override |
| 18 | [Quick Reference](docs/18-quick-reference.md) | Keyboard shortcuts, locations, permission patterns |
| 19 | [Resources](docs/19-resources.md) | Official docs, best practices, community resources |

## Quick Start

### 1. Copy the Template to Your Project

```bash
# Copy the React template to your project
cp -r templates/react/.claude /path/to/your-project/
```

### 2. Customize Placeholders

Search for `{{PLACEHOLDER}}` in the copied files and replace with your project values:

| Placeholder | Location | Description |
|-------------|----------|-------------|
| `{{PROJECT_NAME}}` | `.claude/CLAUDE.md` | Your project's name |
| `{{PROJECT_DESCRIPTION}}` | `.claude/CLAUDE.md` | Brief project description |
| `{{DATABASE}}` | `.claude/CLAUDE.md` | Database type (PostgreSQL, MongoDB, etc.) |
| `{{INFRASTRUCTURE}}` | `.claude/CLAUDE.md` | Cloud provider (AWS, GCP, Azure) |
| `{{TECH_LEAD}}` | `.claude/CLAUDE.md` | Tech lead contact |
| `{{DEVOPS_CONTACT}}` | `.claude/CLAUDE.md` | DevOps contact |
| `{{TICKET_PREFIX}}` | `.claude/rules/git-workflow.md` | JIRA/ticket prefix (e.g., PROJ, TEAM) |

### 3. Commit to Your Project

```bash
git add .claude/ CLAUDE.md
git commit -m "chore: add Claude Code team configuration"
```

### 4. Start Using Claude Code

```bash
cd /path/to/your-project
claude

# Verify configuration loaded
/memory    # Should show your rules
/help      # Should show custom commands
```

## Repository Structure

```
claude-code-guide/
├── README.md                 # This file (quick start)
├── LICENSE
├── TODO.md                   # Track refinements needed
│
├── docs/
│   ├── 01-feature-overview.md    # Core features & memory hierarchy
│   ├── 02-project-rules.md       # Modular rules system
│   ├── 03-directory-structure.md # Project layout
│   ├── 04-configuration.md       # CLAUDE.md & settings.json
│   ├── 05-slash-commands.md      # Team commands
│   ├── 06-subagents.md           # AI assistants
│   ├── 07-skills.md              # Model-invoked capabilities
│   ├── 08-imports.md             # CLAUDE.md imports
│   ├── 09-onboarding.md          # Team onboarding
│   ├── 10-best-practices.md      # Collaboration strategies
│   ├── 11-security.md            # Security considerations
│   ├── 12-troubleshooting.md     # Common issues
│   ├── 13-checkpoints.md         # Code recovery
│   ├── 14-plugins.md             # Plugin system
│   ├── 15-output-styles.md       # Custom output styles
│   ├── 16-vscode-extension.md    # IDE integration
│   ├── 17-additional-features.md # Sandbox, env vars
│   ├── 18-quick-reference.md     # Shortcuts & patterns
│   └── 19-resources.md           # Links & resources
│
├── templates/
│   └── react/                # React/TypeScript stack template
│       ├── .claude/
│       │   ├── CLAUDE.md           # Project context
│       │   ├── settings.json       # Permissions & hooks
│       │   ├── rules/              # Modular rule files
│       │   │   ├── code-style.md       # Always loaded
│       │   │   ├── git-workflow.md     # Always loaded
│       │   │   ├── testing.md          # Always loaded
│       │   │   ├── security.md         # Path-scoped
│       │   │   ├── api-rules.md        # Path-scoped
│       │   │   └── frontend-rules.md   # Path-scoped
│       │   ├── skills/              # Agent skills (model-invoked)
│       │   │   ├── commit-helper/
│       │   │   │   └── SKILL.md
│       │   │   └── code-reviewer/
│       │   │       └── SKILL.md
│       │   ├── commands/           # Slash commands
│       │   │   ├── dev/
│       │   │   │   ├── start.md
│       │   │   │   ├── test.md
│       │   │   │   └── lint.md
│       │   │   ├── git/
│       │   │   │   ├── branch.md
│       │   │   │   ├── commit.md
│       │   │   │   └── pr.md
│       │   │   ├── review.md
│       │   │   ├── debug.md
│       │   │   └── docs.md
│       │   └── agents/             # Subagents
│       │       ├── code-reviewer.md
│       │       ├── test-writer.md
│       │       └── security-scanner.md
│       └── CLAUDE.local.md.example # Personal overrides template
```

## Available Templates

| Stack | Directory | Status |
|-------|-----------|--------|
| React/TypeScript | `templates/react/` | Available |
| Python | `templates/python/` | Planned |
| Go | `templates/go/` | Planned |
| Node.js | `templates/node/` | Planned |

## Key Features

### Rules (`.claude/rules/`)
- **Always loaded**: `code-style.md`, `git-workflow.md`, `testing.md`
- **Path-scoped**: `security.md`, `api-rules.md`, `frontend-rules.md` - only activate for matching files

### Skills (`.claude/skills/`)
Model-invoked capabilities that Claude uses automatically based on context:
- `commit-helper` - Generates commit messages from diffs
- `code-reviewer` - Read-only code review (restricted tools)

### Commands (`.claude/commands/`)
- `/dev/start` - Initialize development session
- `/dev/test` - Run tests with analysis
- `/dev/lint` - Run linters
- `/git/branch` - Create feature branches
- `/git/commit` - Smart commits with conventional format
- `/git/pr` - Create pull requests
- `/review` - Comprehensive code review
- `/debug` - Systematic debugging

### Agents (`.claude/agents/`)
- `code-reviewer` - Thorough code reviews
- `test-writer` - Generate tests
- `security-scanner` - Security analysis

### Settings (`.claude/settings.json`)
- Pre-configured permissions (allow common dev tools, deny sensitive files)
- Prettier hook for auto-formatting

## Team Onboarding

### For DevOps/Team Leads

1. Copy template to your project
2. Customize placeholders
3. Adjust rules for your team's standards
4. Test with `claude` and `/memory`
5. Commit and share with team

### For Developers

1. Pull the project with `.claude/` directory
2. Run `claude` in the project
3. Verify with `/memory` and `/help`

## Customization Notes

All template files include `<!-- TODO: ... -->` comments indicating areas to customize. Review these after copying to your project.

### Path-Scoped Rules

Rules with `paths:` frontmatter only load when working on matching files:

```markdown
---
paths:
  - src/auth/**/*
  - src/payments/**/*
---

# These rules only apply to auth and payments code
```

### Permissions

The default `settings.json` allows common dev tools and denies access to:
- `.env` files and secrets
- Private keys (`.pem`, `.key`, `.p12`)
- Production configuration
- Dangerous bash commands (`rm -rf`, `sudo`)

Adjust based on your security requirements.

---

*Template Version: 1.1 | Compatible with Claude Code v2.0.74*

**Created by Jason Kellie | MIT License**

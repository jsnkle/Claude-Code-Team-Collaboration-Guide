# Claude Code Team Collaboration Templates

A practical template repository for deploying Claude Code across development teams. Copy these templates into your projects to establish consistent AI-assisted development workflows.

**Compatible with Claude Code v2.0.72**

## Quick Start

### 1. Copy the Template to Your Project

```bash
# Copy the React template to your project
cp -r templates/react/.claude /path/to/your-project/
cp templates/react/CLAUDE.md /path/to/your-project/  # Optional: root-level CLAUDE.md
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
│   └── full-guide.md         # Comprehensive reference guide
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
│       ├── CLAUDE.md               # Root-level alternative
│       └── CLAUDE.local.md.example # Personal overrides template
│
└── examples/
    └── user-level/           # Personal ~/.claude/ setup
        ├── CLAUDE.md
        ├── settings.json
        ├── rules/
        │   ├── preferences.md
        │   └── workflows.md
        ├── commands/
        │   └── standup.md
        └── agents/
            └── personal-assistant.md
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

## User-Level Setup

For personal preferences that apply to ALL your projects:

```bash
# Copy user-level examples to your home directory
cp -r examples/user-level/* ~/.claude/

# Customize with your preferences
# Edit ~/.claude/CLAUDE.md
# Edit ~/.claude/rules/preferences.md
```

## Documentation

- **[Full Guide](docs/full-guide.md)** - Comprehensive reference with all Claude Code features
- **[Claude Code Docs](https://code.claude.com/docs)** - Official documentation
- **[Changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)** - Latest features

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
4. Optionally set up personal `~/.claude/` preferences

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

*Template Version: 1.0 | Compatible with Claude Code v2.0.72*

**Created by Jason Kellie | MIT License**

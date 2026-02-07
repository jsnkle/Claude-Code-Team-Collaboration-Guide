# Part 7: Team Onboarding Checklist

## Pre-Onboarding (DevOps/Lead - You)

### Confirm developer access (pick one)

**Team Plan ($25–$125/seat, min 5):**
- [ ] Provision seats in admin console (standard or premium)
- [ ] Configure `managed-settings.json` for org-wide policies
- [ ] Set per-member spend caps if needed
- [ ] Share SSO login instructions

**Individual Plans (each dev on Pro $20/mo or Max $100–$200/mo):**
- [ ] Confirm each developer has an active subscription
- [ ] Note: Max recommended for heavy agentic workflows (5x–20x more usage than Pro)
- [ ] Note: No centralized admin — the `.claude/` project config committed to git is your only shared governance mechanism

### Set up project configuration (all plans)

- [ ] Create project repository with `.claude/` directory structure
- [ ] Create lean `CLAUDE.md` with project overview
- [ ] Set up `.claude/rules/` with modular rule files
- [ ] Configure path-scoped rules for security-critical areas
- [ ] Configure `.claude/settings.json` with team permissions
- [ ] Create initial slash commands for common workflows
- [ ] Create subagents for specialized tasks
- [ ] Set up any required MCP servers (GitHub, Jira, etc.)
- [ ] Test configurations work as expected
- [ ] Document onboarding steps for team

## Developer Onboarding Steps

### Step 1: Install Claude Code

**Native Install (Recommended):**
```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex

# Windows CMD
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

**Homebrew:**
```bash
brew install --cask claude-code
```

**pnpm (Node.js 18+):**
```bash
pnpm add -g @anthropic-ai/claude-code
```

```bash
# Verify installation
claude --version
```

### Step 2: Authenticate
```bash
# Start Claude Code and follow authentication prompts
claude

# Team Plan: Select "Claude account with subscription", choose your organization
# Individual Plans: Sign in with your personal Anthropic account
```

### Step 3: Clone Project & Initialize
```bash
# Clone your project repository
git clone <your-repo-url>
cd <your-project>

# Start Claude Code in your project
claude

# Claude will automatically load:
# - CLAUDE.md
# - .claude/rules/*.md
# - .claude/settings.json
```

### Step 4: Verify Configuration
```bash
# Inside Claude Code session:
/memory          # View all loaded memory files (CLAUDE.md + rules)
/config          # View current settings
/help            # See all available commands including custom ones
```

### Step 5: Set Up Personal Preferences (Optional)
```bash
# Create personal preferences file
mkdir -p ~/.claude/rules
echo "# My Preferences" > ~/.claude/rules/preferences.md

# Or create project-specific personal preferences
# (automatically gitignored)
echo "# My local settings" > CLAUDE.local.md
```

### Step 6: Test Custom Commands
```bash
# Try the team slash commands
/dev/start                      # Initialize dev session
/git/branch feature add-login   # Create feature branch
/review src/api/users.ts        # Code review
```

## Passive Feature Discovery

The common template includes a "what's-new" notification pattern that helps developers stay current with Claude Code features without meetings or email blasts.

**How it works:**
1. A `SessionStart` hook in `settings.json` runs `.claude/scripts/whats-new-check.sh` each time a developer opens Claude Code
2. The script checks whether the developer has already seen the latest update (tracked in `~/.claude/.whats-new-seen`)
3. If the content is new, it prints a one-liner: *"New Claude Code features available — run /whats-new to see what's changed"*
4. Running `/whats-new` shows the full feature highlights with "try it" tips

**Maintaining it:** When you update the highlights in `.claude/commands/whats-new.md`, bump the version marker in the HTML comment at the top (e.g., `<!-- Update: 2025-03 -->`). This causes the hook to re-notify all developers on their next session.

**Platform support:** The `SessionStart` hook script requires bash, so it works on macOS, Linux, and Windows via WSL or Git Bash. Native Windows (PowerShell/CMD) support is coming soon. The `/whats-new` command itself works on all platforms.

## Post-Onboarding Verification

- [ ] Developer can run Claude Code successfully
- [ ] Custom slash commands appear in `/help`
- [ ] Project rules load correctly (`/memory` shows all rule files)
- [ ] Permissions work correctly (can't read .env files)
- [ ] Git workflow commands function properly
- [ ] Developer knows how to ask Claude to edit CLAUDE.md for persistent memories
- [ ] Developer knows how to create personal preferences

---

[← Previous: Imports](08-imports.md) | [Back to Guide](../README.md) | [Next: Best Practices →](10-best-practices.md)

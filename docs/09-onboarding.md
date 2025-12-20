# Part 7: Team Onboarding Checklist

## Pre-Onboarding (DevOps/Lead - You)

- [ ] Ensure all developers have Claude Pro/Max subscription or premium seats
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

**NPM (Node.js 18+):**
```bash
npm install -g @anthropic-ai/claude-code
```

```bash
# Verify installation
claude --version
```

### Step 2: Authenticate
```bash
# Start Claude Code and follow authentication prompts
claude

# If using team/enterprise account:
# Select "Claude account with subscription" when prompted
# Choose your organization if prompted
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

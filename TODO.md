# Project TODOs

## Project Vision

**What this is:** A practical, working template repository that DevOps engineers and team leads can use to quickly deploy Claude Code configurations across their development teams.

**The problem it solves:** Setting up Claude Code for a team requires creating CLAUDE.md files, rules, commands, agents, settings, and hooks. This repository provides ready-to-use templates that can be copied into any project, customized with placeholders, and immediately used by the team.

**End goal:** A comprehensive toolkit containing:
1. **Stack-specific templates** (React, Python, Go, Node.js, etc.) with best-practice configurations
2. **User-level examples** showing developers how to set up their personal `~/.claude/` directory
3. **A quick-start README** that gets teams up and running in minutes
4. **A full reference guide** for deep dives into Claude Code features

**How it's meant to be used:**
1. DevOps/Lead clones this repo
2. Copies the appropriate stack template into their project
3. Replaces `{{PLACEHOLDER}}` values with project-specific info
4. Commits the `.claude/` directory to the project
5. Team members pull and immediately have Claude Code configured

**Current status:** Basic structure complete with React template. Templates contain example content with TODO comments indicating areas to refine based on real-world usage.

---

## Refinements Needed

Track refinements and improvements needed for this template repository.

## High Priority

- [ ] **Refine rules** - Review and customize rule files based on real project needs
- [ ] **Refine commands** - Test slash commands and adjust for actual workflows
- [ ] **Refine agents** - Tune agent prompts based on usage patterns
- [ ] **Refine hooks** - Add/adjust hooks based on tooling used

## Additional Stacks

- [ ] **Python stack** - Add templates/python/ with Django/FastAPI rules
- [ ] **Go stack** - Add templates/go/ with Go-specific rules
- [ ] **Node.js (non-React)** - Add templates/node/ for backend-only projects

## Enhancements

- [ ] **MCP server examples** - Add .mcp.json examples for common integrations
- [ ] **Output styles** - Add custom output style examples
- [ ] **Hooks examples** - More hook examples for different scenarios
- [x] **Skills examples** - Add example skill files (commit-helper, code-reviewer, daily-standup)

## Documentation

- [ ] **Video walkthrough** - Create setup video
- [ ] **FAQ section** - Add common questions and answers
- [ ] **Troubleshooting** - Expand troubleshooting section

---

*Last updated: December 2025*

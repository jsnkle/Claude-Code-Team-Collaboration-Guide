# Project TODOs

## Project Vision

**What this is:** A practical, working template repository that DevOps engineers and team leads can use to quickly deploy Claude Code configurations across their development teams.

**The problem it solves:** Setting up Claude Code for a team requires creating CLAUDE.md files, rules, commands, agents, settings, and hooks. This repository provides ready-to-use, composable templates that can be mixed and matched for any project.

**End goal:** A comprehensive toolkit containing:
1. **Common template** - Universal best practices that apply to any stack
2. **Stack-specific templates** - Focused configurations for React, Express, Hono, NestJS, Python, etc.
3. **Composable architecture** - Mix `common/` with one or more stack templates
4. **A quick-start README** that gets teams up and running in minutes
5. **A full reference guide** for deep dives into Claude Code features

**How it's meant to be used:**
1. DevOps/Lead clones this repo
2. Copies `common/` template first (universal best practices)
3. Copies stack-specific template(s) that merge with common
4. Replaces `{{PLACEHOLDER}}` values with project-specific info
5. Commits the `.claude/` directory to the project
6. Team members pull and immediately have Claude Code configured

**Current status:** Composable structure complete with `common/` and `react/` templates.

---

## Refinements Needed

Track refinements and improvements needed for this template repository.

## High Priority

- [ ] **Test composability** - Verify templates merge correctly in real projects
- [ ] **Refine common rules** - Validate universal rules work across stacks
- [ ] **Refine React template** - Test with real React projects

## Additional Stack Templates

- [ ] **Express** - Add templates/express/ with API-specific rules and security
- [ ] **Hono** - Add templates/hono/ for Hono framework
- [ ] **NestJS** - Add templates/nestjs/ for NestJS framework
- [ ] **Python** - Add templates/python/ with Django/FastAPI rules
- [ ] **Go** - Add templates/go/ with Go-specific rules

## Enhancements

- [ ] **MCP server examples** - Add .mcp.json examples for common integrations
- [ ] **Output styles** - Add custom output style examples
- [ ] **Hooks examples** - More hook examples for different scenarios
- [x] **Skills examples** - Add example skill files (commit-helper)

## Documentation

- [ ] **Update docs** - Ensure all 19 guide parts reflect composable templates
- [ ] **Video walkthrough** - Create setup video
- [ ] **FAQ section** - Add common questions and answers

---

*Last updated: December 2025*

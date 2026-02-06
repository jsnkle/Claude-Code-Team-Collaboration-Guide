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

**Current status:** Composable structure complete with `common/` and `react/` templates. Documentation synced to v2.1.33.

---

## Refinements Needed

Track refinements and improvements needed for this template repository.

## High Priority

- [ ] **Test composability** - Verify templates merge correctly in real projects
- [ ] **Refine common rules** - Validate universal rules work across stacks
- [ ] **Refine React template** - Test with real React projects
- [ ] **Automate changelog monitoring** - Set up CI/scheduled job to diff upstream changelog and post summaries to Slack/Teams (reduces manual `/sync-upstream` runs)

## Additional Stack Templates

- [ ] **Express** - Add templates/express/ with API-specific rules and security
- [ ] **Hono** - Add templates/hono/ for Hono framework
- [ ] **NestJS** - Add templates/nestjs/ for NestJS framework
- [ ] **Python** - Add templates/python/ with Django/FastAPI rules
- [ ] **Go** - Add templates/go/ with Go-specific rules

## Enhancements

- [ ] **MCP server examples** - Add .mcp.json examples for common integrations (GitHub, Linear, Sentry, etc.)
- [ ] **Output style examples** - Add example `.claude/output-styles/` files to common template (e.g., security-auditor.md, strict-review.md)
- [ ] **Hooks examples** - Add example hook configurations to common template (e.g., auto-format on write, lint on commit, setup bootstrap)
- [x] **Skills examples** - Add example skill files (commit-helper)
- [ ] **Plugin pinning example** - Add example of pinned plugin configuration for reproducible team setups (v2.1.14+)
- [ ] **Agent teams example** - Add agent team configuration example when feature stabilizes (currently research preview)
- [x] **What's-new rule** - Added `/whats-new` command + `SessionStart` hook for passive feature discovery

## Documentation

- [x] **Sync to v2.1.33** - Documentation updated to cover v2.1.5 through v2.1.33
- [ ] **Update docs** - Ensure all 19 guide parts reflect composable templates
- [ ] **Video walkthrough** - Create setup video
- [ ] **FAQ section** - Add common questions and answers
- [ ] **User-level examples** - Add `examples/user-level/` with personal config examples (~/.claude/ patterns)

## Team Adoption

- [ ] **Changelog digest automation** - Script or CI workflow that fetches upstream changelog, diffs against current documented version, and posts a team-friendly summary
- [ ] **Onboarding validation command** - Add a `/team/verify` command that checks whether a developer's environment has all expected rules, skills, and settings loaded correctly
- [x] **What's-new passive discovery** - Implemented via `SessionStart` hook + `/whats-new` command with version-gated notifications

---

*Last updated: February 2026*

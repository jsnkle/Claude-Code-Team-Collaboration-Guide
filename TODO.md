# Project TODOs

## Project Vision

**What this is:** A template repository and reference guide for standardizing Claude Code across development teams — whether on a centralized Team Plan or a group of developers on individual Pro/Max subscriptions.

**The problem it solves:** Setting up Claude Code for a team requires creating CLAUDE.md files, rules, commands, agents, settings, and hooks. Without shared configuration, each developer reinvents the wheel. This repository provides:

1. **Composable templates** — Ready-to-use `.claude/` configurations (common + stack-specific) that teams commit to git
2. **A 19-part reference guide** — Documentation covering Claude Code's team-relevant features, onboarding checklists, security practices, and best practices

**Who it's for:**

| Audience | Why they need this |
|---|---|
| **Team Plan** ($25–$125/seat) | Admin policies (`managed-settings.json`) handle org-wide guardrails. These templates and docs add project-specific context, commands, and agents beneath those guardrails. |
| **Individual Plans** (Pro/Max) | No centralized admin exists. The `.claude/` directory committed to git is the *only* shared governance mechanism. This repo is the primary way to standardize Claude Code across the team. |

The templates work identically in both scenarios. The difference is what sits above the project-level config.

**How it's meant to be used:**
1. Clone this repo (or browse the reference guide)
2. Copy `common/` template to your project (universal best practices)
3. Add stack-specific template(s) that merge with common
4. Replace `{{PLACEHOLDER}}` values with project-specific info
5. Commit the `.claude/` directory to your project
6. Team members pull and immediately have Claude Code configured

**Current status:** Composable template structure complete with `common/` and `react/` templates. 19-part reference guide synced to Claude Code v2.1.36. Plan-specific guidance (Team Plan vs. Individual Plans) documented across onboarding, hierarchy, and security docs.

---

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

- [ ] **MCP server configurations** - Add `.mcp.json` skeleton to common template with commented patterns for common integration categories (issue tracking, CI, monitoring) that teams uncomment and configure
- [ ] **Output style configurations** - Add `.claude/output-styles/` files to common template (e.g., security-auditor.md, strict-review.md)
- [ ] **Agent teams configuration** - Add agent team configuration to common template (blocked on upstream — currently research preview behind `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`)
- [ ] **Setup script** - Create an `init.sh` script (e.g., `./init.sh react`) that copies common + stack template, warns about existing `.claude/` directories, and runs placeholder validation
- [ ] **Template validation** - Add a `/validate` slash command to common template that checks for leftover `{{PLACEHOLDER}}` strings, missing required files, or misconfigured settings
- [ ] **"Create your own template" guide** - Document how to create a custom stack template that composes with `common/`, so adopters can extend the pattern to any stack

## Documentation

- [ ] **Update docs** - Ensure all 19 guide parts reflect composable templates
- [ ] **Version migration notes** - Lightweight migration guide when template versions bump, so adopters know what changed in their config files

## Team Adoption

- [ ] **Changelog digest automation** - Script or CI workflow that fetches upstream changelog, diffs against current documented version, and posts a team-friendly summary
- [ ] **Onboarding validation command** - Add a `/team/verify` command that checks whether a developer's environment has all expected rules, skills, and settings loaded correctly

---

*Last updated: February 2026*

# Part 6: CLAUDE.md Imports

CLAUDE.md files can import other files using `@path/to/import` syntax:

```markdown
# Project Overview
See @README.md for detailed project information.
See @docs/architecture.md for system design.

# Development Standards
See @docs/contributing.md for contribution guidelines.

# Individual Developer Preferences (each dev creates their own)
@~/.claude/my-project-preferences.md
```

## Import Features

- **Relative and absolute paths** supported
- **Recursive imports** up to 5 levels deep
- **Not evaluated** inside code blocks or backticks
- **Great for team members** to add individual preferences without committing to repo

## Import Syntax Examples

```markdown
@README.md                           # Relative path
@docs/architecture.md                # Subdirectory
@~/.claude/my-preferences.md         # Home directory
```

## CLAUDE.md from Additional Directories (v2.1.20+)

Load CLAUDE.md files from directories added with `--add-dir`:

```bash
export CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1
claude --add-dir /path/to/shared-config
```

This allows teams to maintain shared CLAUDE.md files in separate repositories.

## Agent Memory (v2.1.32+)

Claude Code now supports automatic memory recording and recall. Agent memory has three scopes:

| Scope | Persists Across | Use Case |
|-------|-----------------|----------|
| `user` | All sessions, all projects | Personal preferences and patterns |
| `project` | All sessions in this project | Project-specific knowledge |
| `local` | Current machine only | Machine-specific configuration |

Claude automatically records and recalls relevant memories during work, building knowledge across sessions.

## View Loaded Memories

Run `/memory` command to see all loaded memory files.

---

[← Previous: Skills](07-skills.md) | [Back to Guide](../README.md) | [Next: Onboarding →](09-onboarding.md)

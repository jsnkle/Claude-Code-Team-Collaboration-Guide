# Part 6: CLAUDE.md Imports

CLAUDE.md files can import other files using `@path/to/import` syntax:

```markdown
# Project Overview
See @README.md for detailed project information.
See @docs/architecture.md for system design.

# Development Standards
See @docs/contributing.md for contribution guidelines.

# Individual Developer Preferences (each dev creates their own)
@~/.claude/va-project-preferences.md
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

## View Loaded Memories

Run `/memory` command to see all loaded memory files.

---

[← Previous: Skills](07-skills.md) | [Back to Guide](../README.md) | [Next: Onboarding →](09-onboarding.md)

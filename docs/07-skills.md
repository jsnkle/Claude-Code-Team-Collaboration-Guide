# Part 5: Agent Skills

## Overview

**Agent Skills** are modular capabilities that extend Claude's functionality through organized folders. Unlike slash commands (which you invoke explicitly with `/command`), skills are **model-invoked** — Claude autonomously decides when to use them based on context and your request.

> **Note (v2.1+):** Slash commands and skills now share a unified model. Skills support **automatic hot-reload** — changes to skill files in `~/.claude/skills` or `.claude/skills` take effect immediately without restarting Claude Code.

## Skills vs Other Features

| Feature | Invocation | Trigger | Use Case |
|---------|-----------|---------|----------|
| **Skills** | Automatic (Claude decides) | Context matching | Complex capabilities with supporting files |
| **Slash Commands** | Manual (`/command`) | Explicit user request | Simple, frequently used prompts |
| **Subagents** | Delegated (auto or explicit) | Task delegation | Specialized AI personalities |
| **Hooks** | Event-triggered | Lifecycle events | Deterministic automation |

**When to use Skills:**
- When Claude should automatically discover and apply capabilities
- When you have multi-file reference materials (scripts, templates, examples)
- When you want consistent procedures applied without explicit invocation

**When to use Slash Commands:**
- When you want explicit control over when something runs
- For simple, single-file prompts

## Directory Structure

Skills are stored in a `skills/` directory with each skill in its own folder:

```
.claude/skills/                    # Project skills (team-shared)
├── commit-helper/
│   └── SKILL.md                   # Required - main skill file
├── code-reviewer/
│   └── SKILL.md
└── pdf-processing/
    ├── SKILL.md                   # Required - main skill file
    ├── FORMS.md                   # Optional - supplementary docs
    ├── REFERENCE.md               # Optional - API reference
    └── scripts/                   # Optional - helper scripts
        └── validate.py

~/.claude/skills/                  # User skills (personal)
├── my-workflow/
│   └── SKILL.md
└── personal-templates/
    └── SKILL.md
```

## SKILL.md File Format

Each skill requires a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
---

# Your Skill Name

## Instructions
Provide clear, step-by-step guidance for Claude.

## Examples
Show concrete examples of using this Skill.
```

### Required Fields

| Field | Requirements | Example |
|-------|--------------|---------|
| `name` | Lowercase letters, numbers, hyphens (max 64 chars) | `commit-helper`, `pdf-processing` |
| `description` | What it does + when to use it (max 1024 chars) | `Generate commit messages from diffs. Use when committing changes.` |

### Optional Fields

| Field | Purpose | Example |
|-------|---------|---------|
| `allowed-tools` | Restrict which tools Claude can use | `Read, Grep, Glob` |
| `context` | Execution context: `fork` runs in isolated sub-agent (v2.1+) | `fork` |
| `agent` | Which subagent type to use when `context: fork` is set | `Explore`, `Plan`, or custom agent name |
| `model` | Model to use when this skill is active | `sonnet`, `opus`, `haiku` |
| `argument-hint` | Hint shown during autocomplete for expected arguments | `[issue-number]`, `[filename] [format]` |
| `user-invocable` | Set to `false` to hide from the `/` menu (default: `true`) | `false` |
| `disable-model-invocation` | Set to `true` to prevent automatic loading (default: `false`) | `true` |
| `hooks` | Hooks scoped to this skill's lifecycle | See hooks documentation |

## Writing Effective Descriptions

The description is critical — it's how Claude decides when to use your skill.

**Too Vague (won't work well):**
```yaml
description: Helps with data
description: For files
```

**Specific and Actionable:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.

description: Generate clear commit messages from git diffs with proper formatting. Use when writing commit messages or reviewing staged changes.
```

**Include:**
- Action verbs describing capabilities
- Specific file types or formats handled
- Trigger keywords users might mention
- When the skill should activate

## Example Skills

### Simple Skill: Commit Message Helper

**File:** `.claude/skills/commit-helper/SKILL.md`

```markdown
---
name: commit-helper
description: Generates clear commit messages from git diffs. Use when writing commit messages or reviewing staged changes.
---

# Commit Message Helper

## Instructions

1. Run `git diff --staged` to see changes
2. Analyze the changes and suggest a commit message with:
   - Summary under 50 characters
   - Detailed description of what changed
   - List of affected components

## Best Practices

- Use present tense ("Add feature" not "Added feature")
- Explain what and why, not how
- Reference issue numbers when applicable

## Examples

Good:
```
Add user authentication with JWT tokens

- Implement JWT token generation and validation
- Add password hashing with bcrypt
- Create auth middleware for protected routes
- Fixes #123
```

Bad:
```
fixed stuff
```
```

### Read-Only Skill: Code Reviewer

**File:** `.claude/skills/code-reviewer/SKILL.md`

```markdown
---
name: code-reviewer
description: Review code for best practices and potential issues. Use when reviewing code, checking PRs, or analyzing code quality.
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

This skill provides code review capabilities with **read-only** file access.

## Review Checklist

1. **Code organization** - Clear structure, appropriate abstractions
2. **Error handling** - All paths covered, meaningful messages
3. **Performance** - No N+1 queries, efficient algorithms
4. **Security** - Input validation, no hardcoded secrets
5. **Test coverage** - Unit tests present, edge cases covered

## Instructions

1. Use Read to examine files
2. Use Grep to search for patterns
3. Use Glob to find related files
4. Provide detailed feedback organized by severity

## Feedback Format

**Critical (Must Fix)**
- Issue and location
- Suggested fix

**Warnings (Should Fix)**
- Issue and impact
- Suggested improvement

**Suggestions (Consider)**
- Enhancement idea
- Rationale
```

### Multi-File Skill: PDF Processing

**File:** `.claude/skills/pdf-processing/SKILL.md`

````markdown
---
name: pdf-processing
description: Extract text, fill forms, merge PDFs. Use when working with PDF files, forms, or document extraction. Requires pypdf and pdfplumber packages.
---

# PDF Processing

## Quick Start

### Extract Text from PDF

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    text = pdf.pages[0].extract_text()
    print(text)
```

### Extract Tables

```python
with pdfplumber.open("document.pdf") as pdf:
    table = pdf.pages[0].extract_table()
    for row in table:
        print(row)
```

### Fill PDF Forms

For form filling, see [FORMS.md](FORMS.md).

## Requirements

```bash
pip install pypdf pdfplumber
```

## Error Handling

- Handle corrupted PDFs gracefully
- Provide clear error messages
- Suggest alternatives if extraction fails
````

## Skill Discovery and Testing

**View available skills:**
```
What Skills are available?
List all available Skills
```

**Test skill activation:**
Ask questions that match your skill's description:
```
# If description mentions "PDF files"
Can you help me extract text from this PDF?

# If description mentions "commit messages"
Help me write a commit message for these changes
```

## Argument Syntax

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed when invoking the skill. If not present in content, arguments are appended as `ARGUMENTS: <value>` |
| `$ARGUMENTS[N]` | Access a specific argument by 0-based index (e.g., `$ARGUMENTS[0]` for the first) |
| `$N` | Shorthand for `$ARGUMENTS[N]` (e.g., `$0` for the first argument, `$1` for the second) |
| `${CLAUDE_SESSION_ID}` | The current session ID, useful for logging or session-specific files |

## Invocation Control

Control when and how skills are loaded using frontmatter combinations:

| Frontmatter | User can invoke (`/name`) | Claude auto-invokes | Context cost |
|-------------|--------------------------|--------------------|----|
| *(default)* | Yes | Yes | Description always loaded |
| `disable-model-invocation: true` | Yes | No | Description **not** loaded |
| `user-invocable: false` | No | Yes | Description always loaded |

Use `disable-model-invocation: true` for workflows you only want triggered manually. Use `user-invocable: false` for background knowledge that Claude applies automatically but users shouldn't invoke directly.

### Skill() Deny Rules

Control which skills Claude can invoke via permission rules:

```
# Deny specific skills
Skill(deploy *)

# Allow only specific skills
Skill(commit)
Skill(review-pr *)
```

Permission syntax: `Skill(name)` for exact match, `Skill(name *)` for prefix match with any arguments. Built-in commands like `/compact` and `/init` are not available through the Skill tool.

## Skill Enhancements (v2.1.6+)

### Nested Skill Discovery (v2.1.6+)

Skills are automatically discovered from nested `.claude/skills` directories, not just top-level ones.

### Session ID Substitution (v2.1.9+)

Use `${CLAUDE_SESSION_ID}` in skill content for session-aware behavior:

```markdown
---
name: session-logger
description: Log actions with session context. Use when tracking work across a session.
---

Log this action to the session audit trail.
Current session: ${CLAUDE_SESSION_ID}
```

### Skills from Additional Directories (v2.1.32+)

Skills auto-load from directories added with `--add-dir`, enabling shared skill libraries across projects:

```bash
claude --add-dir /path/to/shared-skills
```

### Skill Character Budget (v2.1.32+)

Skill content scales with the context window at 2% of total capacity, allowing larger skills on models with bigger context windows.

## Agent Skills Open Standard

Claude Code skills follow the [Agent Skills](https://agentskills.io) open standard, which works across multiple AI tools. Claude Code extends the standard with additional features: invocation control, subagent execution, and dynamic context injection.

## Best Practices

1. **Keep skills focused** - One capability per skill, not "utility functions"
2. **Use progressive disclosure** - Reference supporting files for advanced content
3. **Document dependencies** - List required packages in both description and content
4. **Use tool restrictions** - Add `allowed-tools` for read-only review skills
5. **Include working examples** - Show concrete, copy-pasteable code
6. **Test with your team** - Verify skills activate when expected

## Troubleshooting

**Claude doesn't use your skill:**
1. Make description more specific with trigger keywords
2. Check YAML is valid (no tabs, proper `---` delimiters)
3. Verify file is in correct location (`skills/name/SKILL.md`)

**Multiple skills conflict:**
Use distinct trigger terms in descriptions:
```yaml
# Skill 1
description: Analyze sales data in Excel files. Use for sales reports, revenue tracking.

# Skill 2
description: Analyze log files and system metrics. Use for debugging, performance monitoring.
```

---

[← Previous: Subagents](06-subagents.md) | [Back to Guide](../README.md) | [Next: Imports →](08-imports.md)

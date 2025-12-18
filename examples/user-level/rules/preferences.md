# My Personal Preferences

<!--
  This file goes in ~/.claude/rules/preferences.md
  These rules apply to ALL your projects but can be overridden by project rules.
-->

## Code Style Preferences
- Use early returns to reduce nesting
- Prefer const over let
- Use async/await over .then() chains
- Use destructuring when it improves readability

## Comment Style
- Only add comments for non-obvious logic
- Use TODO: for things to fix later
- Use FIXME: for known bugs

## Testing Preferences
- I prefer descriptive test names over short ones
- Group related tests in describe blocks
- Use meaningful variable names in tests, not foo/bar

## Error Handling
- Always provide meaningful error messages
- Log errors with context
- Use custom error classes for domain errors

# Testing Standards

## Requirements

- Minimum 80% code coverage for new code
- All business logic must have unit tests
- API endpoints require integration tests
- Critical user paths need E2E tests

## Test Structure

- Use `describe` blocks for grouping related tests
- Test names: "should [expected behavior] when [condition]"
- Follow AAA pattern: Arrange, Act, Assert
- One assertion per test when practical

## Mocking

- Mock external services (APIs, databases, third-party SDKs)
- Use dependency injection for testability
- Reset mocks between tests to ensure isolation
- Prefer minimal mocking - test real behavior when possible

## Best Practices

- Tests should be independent and idempotent
- Avoid testing implementation details
- Test edge cases and error conditions
- Keep test files close to the code they test

## Before Committing

- Run full test suite
- Check coverage hasn't decreased
- Verify no skipped tests (`.skip`, `.only`)

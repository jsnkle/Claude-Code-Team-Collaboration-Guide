# Testing Standards

<!-- TODO: Adjust coverage requirements and test commands for your project -->

## Requirements
- Minimum 80% code coverage for new code
- All business logic must have unit tests
- API endpoints require integration tests
- Critical paths need E2E tests

## Test Structure
- Use `describe` blocks for grouping
- Test names: "should [expected behavior] when [condition]"
- Follow AAA pattern: Arrange, Act, Assert

## Mocking
- Mock external services (APIs, databases)
- Use dependency injection for testability
- Reset mocks between tests

## Running Tests

```bash
npm test                      # Run all tests
npm test -- --coverage        # With coverage report
npx vitest run                # Vitest: run once
npx vitest --coverage         # Vitest: with coverage
```

> **Note:** Configure test scripts in package.json based on your test runner:
> - Vitest: `"test": "vitest"`, `"test:coverage": "vitest --coverage"`
> - Jest: `"test": "jest"`, `"test:coverage": "jest --coverage"`

## Before Committing
- Run full test suite
- Check coverage hasn't decreased
- Verify no skipped tests (.skip)

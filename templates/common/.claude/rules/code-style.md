# Code Style Standards

## Formatting

- Use 2-space indentation
- Maximum line length: 100 characters
- Use semicolons in JavaScript/TypeScript
- Use single quotes for strings
- Use trailing commas in multiline structures

## Naming Conventions

- Classes/Components: PascalCase (e.g., `UserProfile`, `OrderService`)
- Functions/methods: camelCase (e.g., `getUserById`, `processOrder`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `MAX_RETRY_COUNT`, `API_BASE_URL`)
- Files: kebab-case (e.g., `user-profile.ts`, `order-service.ts`)
- Interfaces/Types: PascalCase with descriptive names (e.g., `UserResponse`, `OrderItem`)

## Code Organization

- One primary export per file
- Group imports: external packages, internal modules, relative imports
- Keep files focused and under 300 lines when possible

## Documentation

- All public functions should have JSDoc comments
- Complex logic requires inline comments explaining "why"
- Update README when adding new features or changing behavior

---
model: haiku
---

Run linting and type checking: $ARGUMENTS

1. Run ESLint on React/TypeScript files
2. Run Prettier to check formatting
3. Run TypeScript compiler for type errors
4. Report issues and auto-fix what's possible

Lint: `npm run lint` or `npx eslint src/`
Fix: `npm run lint:fix` or `npx eslint src/ --fix`
Types: `npx tsc --noEmit`
Format: `npx prettier --check src/`

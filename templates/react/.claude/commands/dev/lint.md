---
model: haiku
---

Run linting and type checking: $ARGUMENTS

1. Run ESLint on React/TypeScript files
2. Run Prettier to check formatting
3. Run TypeScript compiler for type errors
4. Report issues and auto-fix what's possible

Lint: `pnpm lint` or `pnpm exec eslint src/`
Fix: `pnpm lint:fix` or `pnpm exec eslint src/ --fix`
Types: `pnpm exec tsc --noEmit`
Format: `pnpm exec prettier --check src/`

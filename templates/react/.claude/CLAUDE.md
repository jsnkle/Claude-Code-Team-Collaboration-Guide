# React Template

This template provides React-specific configuration for Claude Code. Use with `templates/common/` for a complete setup.

## Stack

- React 18+ with TypeScript
- Vite for build tooling
- Vitest for testing
- React Testing Library for component tests

## Key Directories

- `/src/components/` - Reusable UI components
- `/src/pages/` or `/src/routes/` - Page/route components
- `/src/hooks/` - Custom React hooks
- `/src/context/` - React context providers
- `/src/utils/` - Utility functions
- `/src/types/` - TypeScript type definitions

## Quick Commands

```bash
pnpm dev             # Start Vite dev server
pnpm build           # Production build
pnpm preview         # Preview production build
pnpm test            # Run Vitest
```

## Usage

Copy this template after copying `common/`:

```bash
cp -r templates/common/.claude ./
cp -r templates/react/.claude ./
```

Then customize the rules and settings for your project.

# Project: {{PROJECT_NAME}}

## Overview

{{PROJECT_DESCRIPTION}}

## Tech Stack

- Backend: Node.js with Express
- Frontend: React with TypeScript
- Database: {{DATABASE}}
- Infrastructure: {{INFRASTRUCTURE}}

## Quick Reference Commands

```bash
npm ci               # Install dependencies (use ci for reproducible builds)
npm run dev          # Start development server
npm run test         # Run test suite
npm run lint         # Run linting
npm run build        # Production build
```

## Key Directories

- `/src/api/` - API routes and controllers
- `/src/components/` - React components
- `/src/hooks/` - Custom React hooks
- `/src/utils/` - Utility functions
- `/src/types/` - TypeScript type definitions
- `/src/auth/` - Authentication **(SECURITY CRITICAL)**
- `/src/payments/` - Payment processing **(SECURITY CRITICAL)**

## Important Notes

- See `.claude/rules/` for detailed coding standards
- NEVER commit secrets or `.env` files to the repository
- Always run tests before pushing
- Security-critical code requires peer review

## Team Contacts

- Tech Lead: {{TECH_LEAD}}
- DevOps: {{DEVOPS_CONTACT}}

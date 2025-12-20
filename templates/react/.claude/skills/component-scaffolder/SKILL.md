---
name: component-scaffolder
description: Scaffolds new React components following feature-based architecture. Use when creating new components, pages, or features.
---

# React Component Scaffolding

## When to Use

Activate this skill when:
- Creating a new component from scratch
- Adding a new page/route
- Creating a new feature module

## Step 1: Determine Location

**Ask the user if unclear:**

| Type | Location | When to Use |
|------|----------|-------------|
| **Feature component** | `src/features/{feature}/components/` | Part of a specific domain |
| **Common component** | `src/common/` | Used by multiple features |
| **Page** | `src/pages/` | Route entry point |
| **New feature** | `src/features/{newFeature}/` | New domain area |

**Decision guidance:**
- Default to feature component unless explicitly shared
- If unsure whether to create new feature or add to existing, **ask the user**
- Components move to `common/` only when needed by multiple features

## Step 2: Create Component Directory

Every component gets its own directory:

```
ComponentName/
├── ComponentName.tsx      # Component implementation
├── ComponentName.css      # Styles (plain CSS, co-located)
├── ComponentName.test.tsx # Tests (optional but recommended)
├── index.ts               # Public export
└── README.md              # Documentation (for complex components)
```

## Step 3: Create Component File

**File:** `ComponentName.tsx`

```tsx
import './ComponentName.css'
import type { ComponentNameProps } from './types'

export function ComponentName({ prop1, prop2 }: ComponentNameProps) {
  return (
    <div className="component-name">
      {/* Component content */}
    </div>
  )
}
```

**Rules:**
- Named export (not default)
- Props interface imported from types or defined inline if simple
- Import styles at top
- Use semantic class names

## Step 4: Create Styles

**File:** `ComponentName.css`

```css
.component-name {
  /* Base styles */
}

.component-name__element {
  /* Child element styles */
}

.component-name--modifier {
  /* Variant styles */
}
```

Use BEM-like naming for clarity without CSS Modules.

## Step 5: Create Index (Public Export)

**File:** `index.ts`

```tsx
export { ComponentName } from './ComponentName'
export type { ComponentNameProps } from './types'
```

**Important:** This is the public API. Other code imports from here, not from internal files.

## Step 6: Create Tests

**File:** `ComponentName.test.tsx`

```tsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, it, expect } from 'vitest'
import { ComponentName } from './ComponentName'

describe('ComponentName', () => {
  it('renders correctly', () => {
    render(<ComponentName prop1="value" />)
    expect(screen.getByRole('...')).toBeInTheDocument()
  })
})
```

## Step 7: Update Feature Index (if feature component)

Add to feature's `index.ts` to expose via public API:

```tsx
// src/features/auth/index.ts
export { LoginForm } from './components/LoginForm'
export { SignupForm } from './components/SignupForm'
export { useAuth } from './hooks/useAuth'
```

**Rule:** Import from `@features/auth`, never from `@features/auth/components/LoginForm`

---

## Creating a New Feature

When creating an entirely new feature, scaffold this structure:

```
src/features/{featureName}/
├── api/              # API calls for this feature
├── components/       # UI components
├── hooks/            # Custom hooks
├── context/          # Context providers (if needed)
├── types/            # TypeScript types
├── utils/            # Feature-specific utilities
├── constants.ts      # Feature constants
└── index.ts          # Public API exports
```

Start with just what's needed - not all directories are required initially.

---

## Creating a Page

Pages are thin - they compose features:

**File:** `src/pages/DashboardPage.tsx`

```tsx
import { DashboardHeader } from '@features/dashboard'
import { RecentActivity } from '@features/activity'
import { useAuth } from '@features/auth'

export function DashboardPage() {
  const { user } = useAuth()

  return (
    <div className="dashboard-page">
      <DashboardHeader userName={user.name} />
      <RecentActivity userId={user.id} />
    </div>
  )
}
```

**Rules:**
- Suffix with "Page" (e.g., `DashboardPage`)
- Minimal logic - delegate to features
- Import from feature public APIs only

---

## Path Aliases

Use configured aliases for imports:

```tsx
import { Button } from '@common/Button'
import { useAuth } from '@features/auth'
import { formatDate } from '@utils/formatting'
import logo from '@assets/images/logo.svg'
```

---

## Verification Checklist

- [ ] Component in correct location (feature/common/pages)
- [ ] Named export (not default)
- [ ] Styles co-located in `.css` file
- [ ] Exported via `index.ts`
- [ ] Feature index updated (if feature component)
- [ ] Uses path aliases for imports
- [ ] No direct imports of feature internals from outside

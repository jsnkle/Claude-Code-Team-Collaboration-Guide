# React Development Rules

## Component Patterns

- Use functional components with hooks (no class components)
- Prefer composition over inheritance
- Keep components under 200 lines - split if larger
- Extract custom hooks for reusable stateful logic
- Co-locate related files (Component, styles, tests, types)

## Component Structure

```tsx
// 1. Imports (external, internal, relative)
// 2. Types/interfaces
// 3. Component definition
// 4. Styles (if co-located)

export function ComponentName({ prop1, prop2 }: Props) {
  // 1. Hooks (useState, useEffect, custom hooks)
  // 2. Derived state / computations
  // 3. Event handlers
  // 4. Effects
  // 5. Return JSX
}
```

## State Management

- **Local state**: Component-specific UI state (`useState`)
- **Shared UI state**: Theme, modals, toasts (`useContext`)
- **Server state**: API data with React Query or SWR
- **Form state**: React Hook Form or Formik for complex forms
- Avoid prop drilling beyond 2-3 levels - use context or composition

## Hooks Best Practices

- Follow the Rules of Hooks (top level, React functions only)
- Use `useMemo` for expensive calculations
- Use `useCallback` for functions passed as props
- Clean up effects that create subscriptions
- Extract complex logic into custom hooks

## Performance

- Lazy load routes with `React.lazy()` and `Suspense`
- Avoid inline object/array creation in JSX props
- Use `React.memo()` for components that render often with same props
- Virtualize long lists (react-window, react-virtualized)
- Profile with React DevTools before optimizing

## Accessibility

- All images need descriptive `alt` text
- Use semantic HTML (`button`, `nav`, `main`, `article`)
- Ensure keyboard navigation works (focus management)
- Use ARIA attributes only when HTML semantics aren't sufficient
- Test with screen reader and keyboard-only navigation

## Testing

- Use React Testing Library for component tests
- Test behavior, not implementation details
- Use `screen` queries in order: getByRole > getByLabelText > getByText
- Mock API calls with MSW (Mock Service Worker)
- Write integration tests for critical user flows

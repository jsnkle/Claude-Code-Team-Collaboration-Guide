# Git Workflow Standards

## Branch Naming

- Features: `feature/{{TICKET_PREFIX}}-short-description`
- Bugs: `bugfix/{{TICKET_PREFIX}}-short-description`
- Hotfixes: `hotfix/{{TICKET_PREFIX}}-short-description`
- Releases: `release/v1.2.3`

## Atomic Commits

Every commit should represent exactly one logical change. This makes history readable, reverts safe, and reviews focused.

- **One concern per commit** — don't mix a bug fix with a refactor or a feature with formatting cleanup
- **Self-contained** — each commit should leave the codebase in a buildable, testable state
- **Independently revertable** — reverting any single commit should undo one change cleanly without side effects
- **Right-sized** — if you can't describe the commit in a single subject line, it's probably too large

If staged changes span multiple logical units, split them into separate commits.

## Commit Messages

Follow Conventional Commits format:

- `feat(scope): add new feature`
- `fix(scope): fix bug description`
- `docs(scope): update documentation`
- `refactor(scope): refactor code`
- `test(scope): add tests`
- `chore(scope): maintenance task`

## Workflow

1. Create branch from `main`
2. Make changes with atomic commits (see above)
3. Run linting and tests before pushing
4. Push and create PR
5. Request review from at least 1 team member
6. Squash merge after approval

## Important

- Never commit directly to `main`
- Always rebase before merging
- Delete branch after merge

# Git Workflow Standards

## Branch Naming

- Features: `feature/{{TICKET_PREFIX}}-short-description`
- Bugs: `bugfix/{{TICKET_PREFIX}}-short-description`
- Hotfixes: `hotfix/{{TICKET_PREFIX}}-short-description`
- Releases: `release/v1.2.3`

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
2. Make changes with atomic commits
3. Run linting and tests before pushing
4. Push and create PR
5. Request review from at least 1 team member
6. Squash merge after approval

## Important

- Never commit directly to `main`
- Always rebase before merging
- Delete branch after merge

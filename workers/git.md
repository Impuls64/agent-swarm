# AGENTS — Git Workflow & Version Control

## Стек

- **VCS:** Git
- **Platforms:** GitHub, GitLab, GitFlic (РФ)
- **Tools:** git-flow, GitHub Flow, conventional commits
- **Hooks:** pre-commit, pre-push

## Commands

```bash
# Branches
git checkout -b feature/new-api    # Create feature branch
git push -u origin feature/new-api # Push and track

# History
git log --oneline --graph --all    # Pretty history

# Undo (safe)
git reset --soft HEAD~1            # Undo commit, keep changes
git stash push -m "WIP: refactor"  # Save WIP
git stash pop                      # Restore WIP

# Rebase
git rebase -i HEAD~3               # Interactive rebase
```

## Branching Strategies

### GitHub Flow (recommended)

```
main ─────●─────────────────●─────────────────
           \               /
feature/    ●──●──●──●──●
```

- Everything in main → deploy
- Feature branches → PR → review → merge
- Simple, fits CI/CD

### Gitflow (for releases)

```
main        ●────────●────────●────────
             \      / \      /
release       ●────●   ●────●
               \  /     \  /
develop   ─────●─────────●─────────
                 \       /
feature/          ●──●──●
```

- `main` — production
- `develop` — development
- `feature/*`, `release/*`, `hotfix/*`

## Conventional Commits

```
<type>(<scope>): <subject>

[body]

[footer]
```

Types:
- **feat:** new feature
- **fix:** bug fix
- **docs:** documentation
- **style:** formatting (no code change)
- **refactor:** refactoring
- **test:** tests
- **chore:** build, dependencies

Examples:
```
feat(auth): add JWT token validation
fix(api): handle null response from YDB
docs(readme): update deployment instructions
```

## Code Review Checklist

### Before PR
- [ ] Code passes linters
- [ ] Tests pass
- [ ] No `print()` / `console.log`
- [ ] Secrets in `.env`, not in code
- [ ] Documentation updated

### Review Process
1. **Author** creates PR with description
2. **Reviewer** checks code
3. **CI** runs tests
4. **Approve** → merge to main

## Do Not Modify

- `.gitignore` rules without team agreement
- `main` branch directly (use PR)
- Committed secrets (use BFG or filter-repo to clean)

## Prohibited

- `git push --force` on main (use `--force-with-lease`)
- Commits without messages
- Secrets in repository
- Large PRs (> 500 lines)
- Direct push to main without review

## Best Practices

- Small, atomic commits
- One feature = one PR
- Describe PR: what, why, how to test
- Use `.gitignore`
- Sign commits (GPG)
- Regular pull from main

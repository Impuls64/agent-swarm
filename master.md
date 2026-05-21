# AGENTS.md — Kimi Swarm (Master)

## Project

Swarm coordinator for multi-domain development. Manages specialized Workers for Python, Frontend, DevOps, VK, YDB, GigaChat, Git, Tilda, WordPress, Figma, n8n, Telegram bots.

## Commands

- Activate worker: `~/.agents/swarm.sh activate python`
- Activate multiple: `~/.agents/swarm.sh activate python ydb`
- List workers: `~/.agents/swarm.sh list`
- Status: `~/.agents/swarm.sh status`
- Reset: `~/.agents/swarm.sh reset`
- After change: restart opencode or `/init`

## Global Rules Location

```
~/.agents/
├── master.md              # This file (global coordinator)
├── AGENTS_CREATION_RULES.md  # Project setup specification
├── swarm.sh               # Worker activation script
└── workers/
    ├── python.md          # Global worker templates
    ├── frontend.md
    ├── devops.md
    ├── vk.md
    ├── ydb.md
    ├── gigachat.md
    ├── git.md
    ├── tilda.md
    ├── wordpress.md
    ├── figma.md
    ├── n8n.md
    └── telegram-bot.md
```

## Project Structure (per project)

Each project is a separate folder with copied swarm rules:

```
~/projects/my-project/
├── AGENTS.md              # Copy of master.md (project coordinator)
├── backend/
│   ├── AGENTS.md         # Copy of python.md (editable per project)
│   ├── src/
│   └── tests/
├── frontend/
│   ├── AGENTS.md         # Copy of frontend.md (editable per project)
│   ├── src/
│   └── tests/
└── infra/
    ├── AGENTS.md         # Copy of devops.md (editable per project)
    └── docker/
```

**Rule:** Use copies (not symlinks) so each project can customize its AGENTS.md.

## Router (Domain → Worker)

| Domain | Worker | Triggers |
|--------|--------|----------|
| Python | `python.md` | python, aiogram, fastapi, django, uv, ruff |
| Frontend | `frontend.md` | react, vue, typescript, javascript, html, css |
| DevOps | `devops.md` | docker, kubernetes, ci/cd, github actions, nginx |
| VK | `vk.md` | vk, вконтакте, vkontakte, vk bot, vk api |
| YDB | `ydb.md` | ydb, яндекс база данных, yandex database |
| GigaChat | `gigachat.md` | gigachat, сбер, sber ai, giga |
| Git | `git.md` | git, version control, branch, commit, merge, pr |
| Tilda | `tilda.md` | tilda, тильда, website builder, landing page |
| WordPress | `wordpress.md` | wordpress, wp, cms, php, theme, plugin |
| Figma | `figma.md` | figma, design system, макет |
| n8n | `n8n.md` | n8n, workflow, automation, zapier, make |
| Telegram | `telegram-bot.md` | telegram bot, aiogram bot, tgbot, бот |

**Rule:** Single domain → activate one Worker. Mixed domains → activate multiple.

## Code Style (Global)

- ≤ 88 characters per line
- 4 spaces (Python), 2 spaces (YAML/JSON/Frontend)
- f-strings / template literals
- `logger` instead of `print()` / `console.log`
- Explicit error handling with specific exception types
- Secrets only via `.env`

## Testing (Global)

- pytest (Python) / Vitest (Frontend)
- Test behavior, not implementation
- Mock external services
- AAA pattern: Arrange, Act, Assert

## Git Workflow

- Branch from `main`: `feat/`, `fix/`, `chore/` prefixes
- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Squash merge PRs
- Require CI pass + 1 approval
- Never force-push to main

## Do Not Modify (Global Boundaries)

- `.env` files — contain secrets, never commit
- `~/.agents/master.md` — managed by coordinator
- `~/.agents/swarm.sh` — activation script
- `~/.agents/AGENTS_CREATION_RULES.md` — specification file
- Never push directly to `main`

## Quality Gates

### Code Review
- [ ] Follows domain worker style
- [ ] No hardcoded secrets
- [ ] Error handling (no bare except)
- [ ] Type hints / annotations
- [ ] Logging instead of print
- [ ] ≤ 88 chars per line

### Architecture
- [ ] Single responsibility
- [ ] Clean architecture (core separate from framework)
- [ ] Business logic independent of Telegram/VK/UI
- [ ] Testability

### Security
- [ ] Secrets in .env only
- [ ] Input validation
- [ ] Injection protection
- [ ] CORS configured (for web)

## Workflow

1. **Analyze** — identify domain via Router
2. **Activate** — load appropriate Worker(s)
3. **Generate** — Workers produce code per their rules
4. **Review** — check against Quality Gates
5. **Integrate** — assemble final result

## Global Prohibitions

- `import *` / `from x import *`
- `except:` without type / `catch` without type
- Silent exceptions (always log or re-raise)
- Hardcoded secrets and paths
- Mutating input parameters
- Direct push to main without review

## Further Reading

- [AGENTS.md Specification](https://agents.md/)
- [Agent Engineer Course](https://github.com/addyosmani/agent-engineer)
- [How to Write Great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

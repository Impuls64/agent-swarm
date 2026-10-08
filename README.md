# Agent Swarm — Multi-Domain AI Agent System

> Professional swarm of specialized AI agents for software development

## What is Agent Swarm?

A **modular agent system** where each domain (Python, Frontend, DevOps, etc.) has its own specialized worker. A master coordinator routes tasks to the right expert.

**Inspired by:** Addy Osmani's [Agent Engineer](https://github.com/addyosmani/agent-engineer) course and [AGENTS.md specification](https://agents.md/)

## Architecture

```
master.md (Orchestrator)         # loaded globally via opencode "instructions"
    ├── Router → determines domain
    ├── Quality Gates → checks output
    └── workers/ (Domain Experts, read on demand)
        ├── python.md         # Python, aiogram, uv
        ├── frontend.md       # React, Vue, TypeScript
        ├── devops.md         # Docker, CI/CD, Nginx
        ├── vk.md             # VK API & bots
        ├── ydb.md            # Yandex Database
        ├── gigachat.md       # Sber GigaChat AI
        ├── git.md            # Git workflow
        ├── tilda.md          # Tilda website builder
        ├── wordpress.md      # WordPress CMS
        ├── figma.md          # Figma API & design
        ├── n8n.md            # n8n automation
        ├── osengine.md       # OsEngine trading
        └── telegram-bot.md   # Telegram bots
```

## Installation

One-command setup:

```bash
git clone https://github.com/yourusername/agent-swarm.git ~/.agents
cd ~/.agents
./install.sh
```
**That's it!** The installer will:

- Create `~/AGENTS.md` symlink to master (legacy; не обязателен — правила грузятся через `instructions` в opencode.jsonc)
- Create `~/AGENTS_*.md` symlinks for all workers
- Make scripts executable
- Configure git

Then restart opencode or run `/init`.

## Quick Start

```bash
# Список доступных workers (справочник)
~/.agents/swarm.sh list
```

Правила грузятся автоматически через `instructions` в `~/.config/opencode/opencode.jsonc`:
`master.md` (оркестратор) + `LESSONS.md` (грабли). Workers читаются по требованию
по Router-таблице в `master.md` — в контекст не загружаются.

После правки workers или конфига — перезапусти opencode или выполни `/init`.

## Creating New Projects

Each project gets its own `AGENTS.md` written from the template in `AGENTS_CREATION_RULES.md`:

```bash
mkdir ~/work/my-project
cd ~/work/my-project

# Write AGENTS.md: Commands → Stack → Structure → Boundaries (Always/Ask/Never)
# Then register the project in the workspace map in master.md
```

## Worker Structure

Each worker follows the **6-section format** from AGENTS.md specification:

1. **Commands** — exact build/test/lint commands
2. **Testing** — framework, structure, naming
3. **Project Structure** — directory layout
4. **Code Style** — examples (show, don't tell)
5. **Git Workflow** — branching, commits, PR
6. **Boundaries** — what NOT to touch

## Adding New Workers

1. Create `workers/<domain>.md`
2. Follow the 6-section format
3. Add to Router table in `master.md`
4. Run `./swarm.sh list` to verify

## Global Rules

### Quality Gates
- [ ] Code style follows domain conventions
- [ ] No hardcoded secrets
- [ ] Error handling (no bare except)
- [ ] Type hints / annotations
- [ ] Logging instead of print
- [ ] ≤88 chars per line

### Prohibited
- `import *`
- `except:` without type
- Silent exceptions
- Hardcoded secrets
- Direct push to main

## Project Structure

```
~/.agents/
├── master.md                   # Orchestrator: Router, карта воркспейса, глобальные грабли
├── LESSONS.md                  # Лог ошибок/решений (дописывать грабли)
├── AGENTS_CREATION_RULES.md    # Specification for creating agents
├── swarm.sh                    # Справочник workers (list)
├── README.md                   # This file
└── workers/                    # Domain experts (читать по Router'у в master.md)
    ├── python.md
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
    ├── osengine.md
    └── telegram-bot.md
```

## License

MIT — feel free to use and modify for your own agent systems.

## Credits

- **Addy Osmani** — [Agent Engineer course](https://github.com/addyosmani/agent-engineer)
- **AGENTS.md spec** — [agents.md](https://agents.md/)
- **Karpathy Guidelines** — Simple, readable, maintainable code

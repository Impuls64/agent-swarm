# Agent Swarm — Multi-Domain AI Agent System

> Professional swarm of specialized AI agents for software development

## What is Kimi Swarm?

A **modular agent system** where each domain (Python, Frontend, DevOps, etc.) has its own specialized worker. A master coordinator routes tasks to the right expert.

**Inspired by:** Addy Osmani's [Agent Engineer](https://github.com/addyosmani/agent-engineer) course and [AGENTS.md specification](https://agents.md/)

## Architecture

```
AGENTS.md (Master)
    ├── Router → determines domain
    ├── Quality Gates → checks output
    └── Workers (Domain Experts)
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
        └── telegram-bot.md   # Telegram bots
```

## Installation

One-command setup:

```bash
git clone https://github.com/yourusername/kimi-swarm.git ~/.agents
cd ~/.agents
./install.sh
```

**That's it!** The installer will:
- Create `~/AGENTS.md` symlink to master
- Create `~/AGENTS_*.md` symlinks for all workers
- Make scripts executable
- Configure git

Then restart opencode or run `/init`.

## Quick Start

```bash
# List available workers
~/.agents/swarm.sh list

# Activate Python worker
~/.agents/swarm.sh activate python

# Activate multiple workers
~/.agents/swarm.sh activate python devops

# Check status
~/.agents/swarm.sh status

# Reset to master only
~/.agents/swarm.sh reset

# Apply changes (restart opencode)
```

## Creating New Projects

Each project gets its own copy of swarm rules:

```bash
mkdir ~/projects/my-project
cd ~/projects/my-project

# Copy master
cp ~/.agents/master.md ./AGENTS.md

# Copy workers for your domains
mkdir backend frontend
cp ~/.agents/workers/python.md backend/AGENTS.md
cp ~/.agents/workers/frontend.md frontend/AGENTS.md

# Edit copies per project needs
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
├── master.md                   # Coordinator rules (≤150 lines)
├── AGENTS_CREATION_RULES.md    # Specification for creating agents
├── swarm.sh                    # Worker activation script
├── README.md                   # This file
└── workers/                    # Domain experts
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
    └── telegram-bot.md
```

## License

MIT — feel free to use and modify for your own agent systems.

## Credits

- **Addy Osmani** — [Agent Engineer course](https://github.com/addyosmani/agent-engineer)
- **AGENTS.md spec** — [agents.md](https://agents.md/)
- **Karpathy Guidelines** — Simple, readable, maintainable code

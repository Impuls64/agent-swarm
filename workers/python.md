# AGENTS — Python (uv + ruff + mypy + pytest + aiogram 3.x)

## Стек

- **Python:** 3.11+
- **Packages:** uv (replaces pip/poetry)
- **Lint:** ruff
- **Types:** mypy
- **Tests:** pytest
- **Framework:** aiogram 3.27+ (async Telegram bots)
- **Validation:** Pydantic
- **Docs:** Google-style docstrings

## Commands

```bash
# Environment
uv init project-name              # Create project
uv add requests                   # Add dependency
uv add --dev pytest mypy ruff     # Add dev dependency
uv sync                           # Sync from lock file

# Development
uv run python script.py
uv run pytest                     # Run all tests
uv run pytest tests/test_api.py -v # Run single test
uv run ruff check .               # Lint
uv run ruff check . --fix         # Lint + fix
uv run ruff format .              # Format
uv run mypy .                     # Type check
```

## Project Structure

```
project/
├── main.py              # Entry point
├── config.py            # .env + settings
├── database.py          # DB connection
├── core/                # Business logic (pure, no Telegram)
├── services/            # API clients, external services
├── handlers/            # Telegram handlers (thin!)
├── routers/             # aiogram Routers
├── keyboards/           # Reply/Inline keyboards
├── middlewares/         # Logging, DB injection
└── tests/
    ├── conftest.py      # Shared fixtures
    ├── test_core/       # Business logic tests
    └── test_services/   # Service tests
```

## Code Style

```python
# ✅ Good: explicit types, small function, early return
from __future__ import annotations
import logging
from pathlib import Path

logger = logging.getLogger(__name__)

async def process_user(
    user_id: int,
    email: str,
    db: AsyncSession,
) -> UserResult:
    """Process user registration.
    
    Args:
        user_id: Telegram user ID
        email: Validated email address
        db: Database session
        
    Returns:
        UserResult with status and message
    """
    if not email:
        raise ValueError("Email required")
    
    existing = await db.get(User, user_id)
    if existing:
        logger.info("User %s already exists", user_id)
        return UserResult(status="exists")
    
    user = User(id=user_id, email=email)
    db.add(user)
    await db.commit()
    
    logger.info("Created user %s", user_id)
    return UserResult(status="created")

# ❌ Bad: no types, print, mutable default
def process(user_id, email, db, cache={}):
    print(f"Processing {user_id}")
    ...
```

- `from __future__ import annotations`
- Type hints on all public functions
- snake_case / PascalCase
- f-strings
- `pathlib.Path` instead of string paths
- ≤ 88 characters per line
- 4 spaces indent

## Testing

```bash
# Run tests
uv run pytest
uv run pytest tests/test_api.py::test_create_user -v
uv run pytest --cov=src --cov-report=term-missing
```

- pytest + pytest-asyncio for async
- Test files: `test_*.py`
- Fixtures in `tests/conftest.py`
- Mock external services (HTTP, Telegram API)
- Test business logic in `core/`, not handlers
- Coverage > 80% for new code

## aiogram 3.x Rules

```python
# ✅ Good: Router, thin handler, service layer
from aiogram import Router, F
from aiogram.filters import Command
from aiogram.types import Message

router = Router()

@router.message(Command("start"))
async def cmd_start(message: Message) -> None:
    """Handle /start command."""
    result = await user_service.get_or_create(message.from_user.id)
    await message.answer(f"Welcome! Status: {result.status}")

# ❌ Bad: business logic in handler, global Bot
@router.message(Command("start"))
async def cmd_start(message: Message) -> None:
    # DON'T: business logic here
    user = await db.query(...).first()
    await bot.send_message(...)  # DON'T: use message.answer
```

- **All async** (`async def` + `await`)
- **Router** for modularity
- **Thin handlers**: validation + service call only
- **Magic Filters**: `F.text`, `F.photo`, `Command()`
- **FSM** for user scenarios only (not business logic)
- **Bot**: `DefaultBotProperties(parse_mode=ParseMode.HTML)`
- **Never** use `Bot.get_current()` — pass `bot: Bot` explicitly

## Do Not Modify

- `.env` — secrets, never commit
- `migrations/` — only via `alembic revision --autogenerate`
- `vendor/` / `node_modules/` — third-party code
- `requirements.txt` — managed by uv, edit `pyproject.toml`
- `.venv/` — auto-generated

## Best Practices

- Small functions, single responsibility
- Early return
- Context managers (`with`)
- `logger` instead of `print()`
- dataclasses for simple models, **Pydantic** for validation/API
- Business logic in `core/` — independent of Telegram
- Always handle errors explicitly

## Prohibited

- `import *`
- `except:` without type
- Silent exceptions
- `print()` in production
- Mutable default arguments
- Hardcoded secrets
- Synchronous code in handlers

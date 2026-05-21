# AGENTS — Telegram Bot (Architecture)

## Стек

- **Framework:** aiogram 3.27+
- **Language:** Python 3.11+
- **FSM:** aiogram.fsm
- **Middlewares:** BaseMiddleware, async callable

## Commands

```bash
# Install
pip install aiogram

# Run bot
python -m bot.main

# Test
pytest tests/ -v
```

## Project Structure

```
bot/
├── main.py              # Entry point (asyncio.run)
├── config.py            # .env + settings
├── database.py          # SQLite/PostgreSQL
├── core/                # Business logic (pure)
├── services/            # API clients
├── handlers/            # Telegram handlers (thin)
├── routers/             # aiogram Routers
├── keyboards/           # Reply/Inline keyboards
└── middlewares/         # Logging, DB injection
```

## Handler Pattern

```python
from aiogram import Router, F
from aiogram.filters import Command
from aiogram.types import Message
from aiogram.fsm.context import FSMContext

router = Router()

@router.message(Command("start"))
async def cmd_start(message: Message, state: FSMContext) -> None:
    """Handle /start. Thin handler: validate + call service."""
    await state.clear()
    result = await user_service.get_or_create(message.from_user.id)
    await message.answer(
        f"Welcome! Your status: {result.status}",
        reply_markup=get_main_keyboard()
    )

@router.callback_query(F.data == "order")
async def on_order(callback: CallbackQuery, state: FSMContext) -> None:
    """Handle inline button."""
    await state.set_state(OrderForm.waiting_for_item)
    await callback.message.edit_text("What would you like to order?")
```

## FSM Example

```python
from aiogram.fsm.state import State, StatesGroup

class OrderForm(StatesGroup):
    waiting_for_item = State()
    waiting_for_quantity = State()
    waiting_for_confirm = State()

@router.message(OrderForm.waiting_for_item)
async def process_item(message: Message, state: FSMContext) -> None:
    await state.update_data(item=message.text)
    await state.set_state(OrderForm.waiting_for_quantity)
    await message.answer("How many?")
```

## Middleware Example

```python
from aiogram import BaseMiddleware

class DatabaseMiddleware(BaseMiddleware):
    """Inject DB session into handler data."""
    
    async def __call__(self, handler, event, data):
        async with db_session() as session:
            data["db"] = session
            return await handler(event, data)
```

## Do Not Modify

- `.env` with BOT_TOKEN
- `core/` business logic without tests
- Migration files manually

## Best Practices

- Handlers are thin: validation + service call
- Business logic in `core/` — independent of Telegram
- Use dependency injection (middlewares)
- `message.answer()` instead of `bot.send_message()`
- Clear FSM states when flow ends
- Log all errors, don't swallow exceptions

## Prohibited

- Business logic in handlers
- `Bot.get_current()` — pass `bot: Bot` explicitly
- Synchronous code in handlers
- Hardcoded tokens
- Silent exceptions

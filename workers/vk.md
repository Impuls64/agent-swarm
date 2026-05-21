# AGENTS — VK (ВКонтакте) API & Bots

## Стек

- **API:** VK API 5.199+
- **Python:** `vk_api`
- **Node.js:** `vk-io`
- **Auth:** OAuth 2.0, Service Token, Group Token
- **Events:** Long Poll API, Callback API

## Commands

```bash
# Install
pip install vk-api

# Run bot
python bot.py

# Test with pytest
pytest tests/test_vk_bot.py -v
```

## Project Structure

```
vk-bot/
├── main.py              # Entry point
├── config.py            # .env + settings
├── handlers/            # Message handlers
├── keyboards/           # VK keyboards
├── middlewares/         # Logging, filters
└── services/            # VK API wrappers
```

## Code Style

```python
import vk_api
from vk_api.bot_longpoll import VkBotLongPoll, VkBotEventType
from vk_api.keyboard import VkKeyboard, VkKeyboardColor

# ✅ Good: explicit event handling
vk_session = vk_api.VkApi(token=GROUP_TOKEN)
longpoll = VkBotLongPoll(vk_session, group_id=123456789)

for event in longpoll.listen():
    if event.type == VkBotEventType.MESSAGE_NEW:
        message = event.message
        user_id = message.from_id
        
        if event.from_user:
            handle_private_message(user_id, message.text)
        elif event.from_chat:
            handle_chat_message(event.chat_id, user_id, message.text)

# Keyboard example
keyboard = VkKeyboard(one_time=True)
keyboard.add_button('Order', color=VkKeyboardColor.PRIMARY)
keyboard.add_button('Help', color=VkKeyboardColor.SECONDARY)
```

## Testing

- pytest + mocks for VK API
- Test handler logic, not VK API calls
- Mock `vk.messages.send`

## Do Not Modify

- Group token in `.env`
- `callback_confirmation` string (for Callback API)
- Rate limits: 20 req/sec for groups

## Best Practices

- Use `random_id` for message uniqueness
- Handle API errors (check error codes)
- Cache `users.get` requests
- Log all incoming events
- Verify permissions before API calls

## Prohibited

- Hardcoded tokens
- Ignoring rate limits
- Spam sending
- Storing tokens in code

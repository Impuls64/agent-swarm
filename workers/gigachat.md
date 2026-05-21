# AGENTS — GigaChat (Сбер)

## Стек

- **API:** GigaChat REST API
- **Python SDK:** `langchain-gigachat`, `gigachat`
- **Models:** GigaChat, GigaChat Pro, GigaChat Max
- **Auth:** OAuth 2.0, Authorization Key, mTLS

## Commands

```bash
# Install
pip install langchain-gigachat

# Test API
python test_gigachat.py
```

## Code Style

```python
import requests

# ✅ Good: token refresh, error handling, proper headers
class GigaChatClient:
    def __init__(self, auth_key: str):
        self.auth_key = auth_key
        self.token = None
        self.token_expires = 0
    
    def _get_token(self) -> str:
        if self.token and time.time() < self.token_expires:
            return self.token
        
        url = "https://ngw.devices.sberbank.ru:9443/api/v2/oauth"
        headers = {
            "Content-Type": "application/x-www-form-urlencoded",
            "RqUID": str(uuid.uuid4()),
            "Authorization": f"Bearer {self.auth_key}"
        }
        
        response = requests.post(url, data="scope=GIGACHAT_API_PERS", headers=headers)
        response.raise_for_status()
        
        data = response.json()
        self.token = data["access_token"]
        self.token_expires = time.time() + 25 * 60  # 25 min buffer
        return self.token
    
    def chat(self, message: str, model: str = "GigaChat") -> str:
        url = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"
        headers = {
            "Authorization": f"Bearer {self._get_token()}",
            "Content-Type": "application/json"
        }
        
        data = {
            "model": model,
            "messages": [
                {"role": "system", "content": "Ты — полезный ассистент."},
                {"role": "user", "content": message}
            ],
            "temperature": 0.7,
            "max_tokens": 512
        }
        
        response = requests.post(url, json=data, headers=headers)
        response.raise_for_status()
        return response.json()["choices"][0]["message"]["content"]
```

## Models

| Model | Description | Use Case |
|-------|-------------|----------|
| **GigaChat** | Basic | Simple tasks, chatbots |
| **GigaChat Pro** | Enhanced | Complex queries, analysis |
| **GigaChat Max** | Max quality | Critical tasks, code generation |

## Testing

- Mock token endpoint in tests
- Test token refresh logic
- Verify response parsing

## Do Not Modify

- Authorization key in `.env`
- Token caching logic (30 min lifetime)

## Best Practices

- Cache token, auto-refresh
- Use system prompt for context
- Handle rate limits (429)
- Log requests/responses
- Verify responses have content
- Use mTLS for production auth

## Prohibited

- Hardcoded Authorization Key
- Ignoring 30-min token expiry
- Sending PII without consent
- Medical/legal use without verification

## Additional Features

- **Embeddings:** `/embedding` — text vector representations
- **Vision:** Image support (some models)
- **Streaming:** Streamed responses

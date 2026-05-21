# AGENTS — n8n (Workflow Automation)

## Стек

- **Platform:** n8n (self-hosted or cloud)
- **Triggers:** Webhook, Schedule, Email, Telegram, HTTP
- **Logic:** IF, Switch, Loop Over Items, Wait, Code
- **Integrations:** 400+ nodes

## Commands

```bash
# Docker (self-hosted)
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n

# Export workflow
n8n export:workflow --id=WORKFLOW_ID --output=file.json
```

## Core Concepts

### Workflow

```
Trigger Node → Action Node → Logic Node → Action Node
```

### Trigger Nodes

- **Webhook** — HTTP endpoint
- **Schedule** — cron-like scheduling
- **Email (IMAP)** — incoming email trigger
- **Telegram Trigger** — bot messages
- **HTTP Request** — API polling

### Action Nodes

- **HTTP Request** — API calls
- **Function / Code** — JS/Python code
- **Set** — variable creation
- **Postgres / MySQL** — database operations
- **Google Sheets** — read/write
- **Send Email** — email sending
- **Telegram** — message sending

### Logic Nodes

- **IF** — conditional branching
- **Switch** — multiple branching
- **Loop Over Items** — array iteration
- **Wait** — delay
- **Merge** — data stream merging
- **Compare Datasets** — data comparison

## Webhook Response Modes

1. **Immediately** — instant HTTP 200
2. **When Last Node Finishes** — wait for completion
3. **Using 'Respond to Webhook' Node** — custom response
4. **Streaming Response** — real-time streaming

## Expressions

```javascript
// Access data
{{ $json.email }}

// Condition
{{ $json.status === "paid" }}

// Date formatting
{{ $now.format("YYYY-MM-DD") }}

// Array mapping
{{ $json.items.map(i => i.name) }}
```

## Project Structure

```
n8n-workflows/
├── workflows/
│   ├── telegram-bot.json
│   ├── order-processing.json
│   └── daily-reports.json
├── credentials/
│   └── (exported credentials without secrets)
├── scripts/
│   ├── backup.sh
│   └── import-workflows.sh
└── docker-compose.yml
```

## Do Not Modify

- Production workflows without testing
- Credential files directly (use UI)

## Best Practices

- Error handling: Error Trigger or catch branches
- Credentials in built-in storage, not hardcoded
- Meaningful workflow IDs (`Notify_New_Order`, not `Workflow 1`)
- Version control: export to JSON, store in git
- Use Test URL for webhook debugging
- Batch processing for large datasets

## Prohibited

- Hardcoded API keys / passwords
- Infinite loops without exit condition
- Synchronous webhooks without timeout (> 30s)
- PII processing without encryption

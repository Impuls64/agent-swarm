# AGENTS — YDB (Yandex Database)

## Стек

- **DB:** Yandex Database (YDB)
- **Python SDK:** `ydb`
- **Go SDK:** `ydb-go-sdk`
- **JS/TS SDK:** `@yandex-cloud/ydb-sdk`
- **Modes:** Serverless, Dedicated, Local

## Commands

```bash
# Install
pip install ydb

# Local development (with YDB Docker)
docker run -d --name ydb-local -p 2136:2136 -p 8765:8765 cr.yandex/yc/yandex-docker-local-ydb:latest
```

## Project Structure

```
project/
├── migrations/          # YDB schema migrations
├── models.py            # Pydantic models
├── repository.py        # YDB queries
└── tests/
    └── test_repository.py
```

## Code Style

```python
import ydb

# ✅ Good: proper driver, session pool, parameterized queries
endpoint = "grpcs://ydb.serverless.yandexcloud.net:2135"
database = "/ru-central1/b1g.../etn..."

credentials = ydb.iam.ServiceAccountCredentials.from_file(
    "service-account-key.json"
)

with ydb.Driver(endpoint=endpoint, database=database, credentials=credentials) as driver:
    driver.wait(timeout=5, fail_fast=True)
    
    with ydb.QuerySessionPool(driver) as pool:
        # Schema
        pool.execute_with_retries(
            "CREATE TABLE users (id Uint64, name Utf8, PRIMARY KEY (id))"
        )
        
        # Insert with transaction
        def insert(tx: ydb.QueryTxContext):
            tx.execute(
                "INSERT INTO users (id, name) VALUES (1, 'Alice')",
                commit_tx=True,
            )
        
        pool.retry_tx_sync(insert)
        
        # Read
        result = pool.execute_with_retries("SELECT id, name FROM users")
        for row in result[0].rows:
            print(row["id"], row["name"])
```

## Testing

- Test with local YDB Docker container
- Mock driver for unit tests
- Test transaction retry logic

## Do Not Modify

- `service-account-key.json` — credentials file
- Production database schemas without migration

## Data Types

- `Uint8/16/32/64` — unsigned integers
- `Int8/16/32/64` — signed integers
- `Float`, `Double`
- `Bool`
- `Utf8` — UTF-8 string
- `String` — binary data
- `Timestamp`
- `Optional<T>` — nullable

## Best Practices

- Parameterized queries (DECLARE)
- Indexes on frequently queried columns
- TTL for auto-cleanup
- BulkUpsert for mass loading
- Handle `PreconditionFailed` (transaction conflicts)

## Prohibited

- Full table scans without filters
- Large transactions (> 1000 operations)
- Hardcoded credentials
- Ignoring timeouts

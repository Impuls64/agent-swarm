# AGENTS — DevOps / Infrastructure (Docker / CI-CD / Nginx)

## Стек

- **Containers:** Docker + Docker Compose
- **CI/CD:** GitHub Actions / GitLab CI
- **Proxy:** Nginx / Traefik
- **DB:** PostgreSQL / Redis / YDB
- **Monitoring:** Prometheus + Grafana (optional)

## Commands

```bash
# Docker
docker-compose up -d              # Start all services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
docker build -t myapp:latest .
docker push registry/myapp:latest

# CI/CD (GitHub Actions)
# Triggered on push/PR automatically
# Check status: GitHub → Actions tab

# Nginx
nginx -t                          # Test config
systemctl reload nginx            # Reload
```

## Project Structure

```
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml          # Dev
│   ├── docker-compose.prod.yml     # Production
│   └── .dockerignore
├── .github/workflows/
│   ├── ci.yml                      # Tests + lint
│   └── deploy.yml                  # Deploy
├── scripts/
│   ├── deploy.sh
│   └── backup.sh
├── nginx/
│   └── nginx.conf
└── monitoring/
    ├── prometheus.yml
    └── alerts.yml
```

## Dockerfile Best Practices

```dockerfile
# ✅ Good: multi-stage, non-root, pinned versions
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY . .
USER nobody
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:8000/health || exit 1
CMD ["python", "-m", "app"]
```

- **Multi-stage builds**
- **Non-root user** (`USER nobody`)
- **Pinned versions** (no `latest`)
- **`.dockerignore`** present
- **Health checks** in every service
- **Minimize layers** (combine RUN)

## Docker Compose

```yaml
# docker-compose.yml
version: "3.8"
services:
  app:
    build: .
    env_file: .env
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    depends_on:
      db:
        condition: service_healthy
  db:
    image: postgres:15-alpine
    env_file: .env
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]

volumes:
  postgres_data:
```

## CI/CD (GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v1
      - run: uv sync
      - run: uv run pytest
      - run: uv run ruff check .
      - run: uv run mypy .
```

## Do Not Modify

- `.env` — secrets (in `.gitignore`)
- `secrets/` — vault files
- Production configs without review
- `latest` tags in production Dockerfiles
- Infrastructure state files (Terraform `.tfstate`)

## Prohibited

- Hardcoded passwords
- `latest` tag in production
- Direct work on production without CI/CD
- Secrets in logs
- Manual file copy to servers

## Principles

- Infrastructure as Code
- Secrets only in `.env` / vault / GitHub Secrets
- Version images via git tag / commit hash
- Health checks in all services
- Graceful shutdown (SIGTERM handling)
- Logs to stdout (not files)

## Workflow

1. Local → Docker Compose (`docker-compose up`)
2. PR → CI runs tests
3. Merge → Auto-deploy to staging
4. Tag → Manual approve → Deploy to production

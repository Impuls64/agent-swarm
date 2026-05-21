# Правила создания AGENTS.md

> Базируются на спецификации Addy Osmani (Agent Engineer, урок 15)
> и анализе 2500+ репозиториев с AGENTS.md

## Архитектура: Master + Workers

### Глобальные правила (репозиторий ~/.agents/)

```
~/.agents/
├── master.md              # Глобальный Master (не трогать)
├── AGENTS_CREATION_RULES.md  # Этот файл (спецификация)
├── swarm.sh               # Скрипт активации
└── workers/
    ├── python.md          # Глобальные Worker шаблоны
    ├── frontend.md
    ├── devops.md
    └── ...
```

### Правила на уровне проекта (каждый проект отдельно)

**Каждый новый проект создаётся в отдельной папке** с копиями swarm правил.

```
~/projects/
└── my-project/            # Корень проекта
    ├── AGENTS.md         # Копия master.md (локальный координатор)
    ├── backend/          # Python агент работает тут
    │   ├── AGENTS.md    # Копия python.md (редактируем под проект!)
    │   ├── src/
    │   └── tests/
    ├── frontend/         # Frontend агент работает тут
    │   ├── AGENTS.md    # Копия frontend.md (редактируем под проект!)
    │   ├── src/
    │   └── tests/
    └── infra/            # DevOps агент работает тут
        ├── AGENTS.md    # Копия devops.md (редактируем под проект!)
        └── docker/
```

**Важно:** Используются **копии** (не симлинки), чтобы можно было редактировать AGENTS.md под конкретный проект.

### Master (AGENTS.md)
- **Роль**: Tech Lead / Coordinator
- **Не пишет код** — определяет домен и активирует Workers
- **Проверяет качество** по Quality Gates
- **Собирает результат** от Workers
- **≤150 строк** (критически важно для context window)

### Workers (AGENTS.md в подпапках проекта)
- **Роль**: Domain Expert для конкретного проекта
- **Пишет код** по правилам домена
- **Следует Karpathy Guidelines**
- **Можно редактировать** под проект (добавлять специфичные правила)
- **≤200 строк** (по возможности)

## 6 основных областей (для каждого Worker)

### 1. Commands (Команды)
**Что**: Точные команды для сборки, тестов, линтинга.

**Плохо:**
```
- Линтинг: ruff
```

**Хорошо:**
```
- Линтинг: uv run ruff check . --fix
- Тест одного файла: uv run pytest tests/test_api.py::test_create -v
```

### 2. Testing (Тестирование)
**Что**: Фреймворк, структура, naming conventions.

**Плохо:**
```
- Используем pytest
```

**Хорошо:**
```
- pytest + pytest-asyncio для async
- Тесты зеркалят src: src/api/users.py → tests/api/test_users.py
- Fixtures: tests/conftest.py
- Покрытие: >80% для нового кода
```

### 3. Project Structure (Структура)
**Что**: Карта директорий. Где что находится.

**Плохо:**
```
- Код в src/
```

**Хорошо:**
```
- `src/api/` — REST endpoints (FastAPI)
- `src/core/` — бизнес-логика (чистая, без фреймворков)
- `src/db/` — SQLAlchemy + Alembic миграции
- `tests/` — зеркалит src/
```

### 4. Code Style (Стиль кода)
**Что**: Naming, форматирование, паттерны. **Примеры кода лучше слов.**

**Плохо:**
```
- Используй type hints
```

**Хорошо:**
```python
# Плохо
def process(data):
    ...

# Хорошо
def process_user_data(raw_data: dict[str, Any]) -> ProcessedResult:
    ...
```

### 5. Git Workflow (Git)
**Что**: Branching, commits, PR requirements.

**Пример:**
```
- Branch: feat/, fix/, chore/ префиксы от main
- Commits: conventional commits (feat:, fix:, docs:)
- PR: squash merge, CI проходит, 1 approval
```

### 6. Boundaries (Границы)
**Что**: Что НЕЛЬЗЯ трогать. **Самая важная секция.**

**Пример:**
```
## Do Not Modify
- `.env` — секреты, никогда не коммитить
- `migrations/` — только через alembic revision
- `vendor/` — third-party, managed externally
```

## Золотые правила

### 1. Лаконичность
- **Master (AGENTS.md)**: ≤150 строк
- **Workers**: ≤200 строк (по возможности)
- Длинные файлы теряют важную информацию в context window

### 2. Конкретика
- **Bad**: "Мы используем современный JavaScript"
- **Good**: "React 18.2 + TypeScript 5.3 + Vite 5.0"

### 3. Примеры кода
- Один пример стоит 10 абзацев текста
- Показывай **good** и **bad** варианты

### 4. Итеративность
- Начни с минимума (Commands + Structure)
- Добавляй правила, когда агент ошибается
- Лучший AGENTS.md растёт через итерации, не планирование

### 5. Как код
- Обновляй в том же PR, что и изменения
- Устаревшие инструкции хуже, чем их отсутствие

### 6. Объясняй "почему"
- Для неочевидных правил добавь пояснение
- Пример: "Не используй datetime.now() напрямую → используй src/core/clock.py для контроля времени в тестах"

## Иерархия для монорепо

```
repo/
  AGENTS.md              # Shared (Git, CI, общие правила)
  services/
    api/
      AGENTS.md          # Python-specific (pytest, FastAPI)
    frontend/
      AGENTS.md          # TS-specific (Vitest, React)
```

Агент читает ближайший AGENTS.md + родительский.

## Quality Gates (чеклисты Master)

### Code Review
- [ ] Код соответствует стилю домена
- [ ] Нет хардкода секретов
- [ ] Обработка ошибок (не silent except)
- [ ] Type hints / аннотации
- [ ] Логирование вместо print
- [ ] ≤88 символов в строке

### Architecture
- [ ] Разделение ответственности
- [ ] Чистая архитектура (core отделён от фреймворка)
- [ ] Тестируемость
- [ ] Нет циклических зависимостей

### Security
- [ ] Секреты в .env
- [ ] Валидация входных данных
- [ ] Защита от инъекций
- [ ] CORS настроен (для web)

## Workflow создания нового проекта

### Шаг 1: Создать папку проекта

```bash
mkdir -p ~/projects/my-project
cd ~/projects/my-project
```

### Шаг 2: Скопировать Master в корень проекта

```bash
cp ~/.agents/master.md ./AGENTS.md
```

Это глобальный координатор для проекта. Можно отредактировать под проект (добавить специфичные команды, структуру).

### Шаг 3: Создать подпапки под домены

```bash
mkdir -p backend frontend infra
```

### Шаг 4: Скопировать Workers в подпапки

```bash
cp ~/.agents/workers/python.md    backend/AGENTS.md
cp ~/.agents/workers/frontend.md  frontend/AGENTS.md
cp ~/.agents/workers/devops.md    infra/AGENTS.md
```

### Шаг 5: Редактировать под проект

Каждый `AGENTS.md` в подпапке можно редактировать:
- Добавить проект-специфичные команды
- Уточнить структуру
- Добавить специфичные правила
- Убрать ненужное

### Пример: Иерархия AGENTS.md в проекте

```
~/projects/my-project/
├── AGENTS.md              # Master (глобальные правила проекта)
│   # Можно добавить:
│   # - Общие команды проекта
│   # - Общую структуру
│   # - Git workflow для этого проекта
│
├── backend/
│   ├── AGENTS.md         # Python специфично для этого проекта
│   │   # Можно добавить:
│   │   # - uv run python -m backend.main
│   │   # - Специфичные модели БД
│   │   # - API endpoints проекта
│   ├── src/
│   └── tests/
│
├── frontend/
│   ├── AGENTS.md         # Frontend специфично для этого проекта
│   │   # Можно добавить:
│   │   # - npm run dev -- --port 3001
│   │   # - Специфичные компоненты
│   │   # - API base URL
│   ├── src/
│   └── tests/
│
└── infra/
    ├── AGENTS.md         # DevOps специфично для этого проекта
    │   # Можно добавить:
    │   # - docker-compose -f docker-compose.prod.yml
    │   # - Специфичные сервисы
    │   # - Deploy скрипты
    └── docker/
```

### Как opencode читает AGENTS.md

Opencode автоматически находит ближайший `AGENTS.md` в текущей директории или родителях.

```
# Если я в ~/projects/my-project/backend/
# opencode читает:
# 1. ~/projects/my-project/backend/AGENTS.md (python)
# 2. ~/projects/my-project/AGENTS.md (master)

# Если я в ~/projects/my-project/
# opencode читает:
# 1. ~/projects/my-project/AGENTS.md (master)
```

**Правило:** Работая в `backend/`, агент следует правилам `backend/AGENTS.md`. Для глобальных вещей смотрит в корень проекта.

## Формат секций

### Стандартная структура Worker'а

```markdown
# AGENTS — [Домен] ([стек])

## Стек
- **X**: version
- **Y**: version

## Команды
- Build: `...`
- Test: `...`

## Структура
- `dir/` — description

## Стиль кода
```python
# Пример
```

## Тестирование
- Framework: ...

## Запрещено
- item

## Best Practices
- item with explanation
```

## Примеры хороших файлов

### Master (AGENTS.md) — ~100 строк
```markdown
# AGENTS.md — Kimi Swarm

## Роль
Tech Lead. Не пишу код — координирую Workers.

## Router
| Домен | Worker |
|-------|--------|
| Python | python.md |
| Frontend | frontend.md |

## Quality Gates
- [ ] Code Review: стиль, ошибки, типы
- [ ] Architecture: чистота, тестируемость
- [ ] Security: секреты, валидация

## Workflow
1. Определи домен → Router
2. Активируй Workers
3. Workers генерируют код
4. Master проверяет Quality Gates
5. Интегрируй результат

## Запрещено (глобально)
- `import *`
- `except:` без типа
- Хардкод секретов
```

## Обновление существующих файлов

При обновлении Worker'ов:
1. Добавить секцию **Commands** с точными командами
2. Добавить секцию **Testing** с конкретикой
3. Добавить секцию **Boundaries** (Do Not Modify)
4. Убрать абстрактные описания, заменить примерами
5. Сократить до ≤200 строк
6. Добавить "почему" для неочевидных правил

## Ссылки
- [agents.md specification](https://agents.md/)
- [Agent Engineer by Addy Osmani](https://github.com/addyosmani/agent-engineer)
- [How to write a great AGENTS.md](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

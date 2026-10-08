# AGENTS.md — agent-swarm (репозиторий базы правил)

Это репозиторий **единой базы инструкций** для OpenCode-сессий в `/home/bob`.
Публикуется в `https://github.com/Impuls64/agent-swarm` (origin = `main`).

## Что где — источник истины

| Файл | Роль | Как грузится |
|------|------|--------------|
| `master.md` | Оркестратор: Router, карта воркспейса, грабли, качество | `instructions` в `~/.config/opencode/opencode.jsonc` → **во всех сессиях** |
| `LESSONS.md` | Лог ошибок/решений по датам | там же, через `instructions` |
| `workers/*.md` | 13 доменных модулей | **не грузятся автоматически**, читаются по Router'у из `master.md` по требованию |
| `AGENTS_CREATION_RULES.md` | Спецификация: как писать AGENTS.md | по надобности |
| `swarm.sh` | Справочник `list` | вручную |
| `install.sh` | Установка на новую машину | вручную |

Нет CI, тестов, линтера, pre-commit — проверка изменений = `bash -n *.sh` + чтение diff'а.

## Инварианты (нарушение ломает базу)

- **Router-таблица в `master.md` = список `workers/*.md` 1:1.** Новый worker = файл + строка в Router. Проверка: `grep -oP 'workers/\K[a-z0-9-]+(?=\.md)' master.md | sort` против `ls workers/*.md`.
- **Workers не подключать через `instructions`** — постоянный раздув контекста (`osengine.md` = 528 строк / 18 КБ). Только `master.md` + `LESSONS.md`.
- **`~/AGENTS.md` не существует и не должен появляться.** Раньше `swarm.sh`/`install.sh` его генерировали (`cp master.md ~/AGENTS.md`) — отсюда рассинхрон. `install.sh` теперь только удаляет легаси.
- **`~/bin/use-project` устарел** — он копирует `master.md` в проект как `AGENTS.md` и создаёт `~/AGENTS.md`→проект, возвращая сломанный codegen. `~/bin` стоит первым в `PATH`, поэтому скрипт вызывается легко — не запускать без явного запроса пользователя.
- **13 симлинков `AGENTS_*.md` в корне репо — легаси `install.sh`, и они закоммичены** (git mode `120000`, абсолютные пути `/home/bob/.agents/workers/*.md` → на другой машине битые). Правь `workers/<name>.md`; не редактируй и не перезаписывай файл по имени `AGENTS_<name>.md` (это симлинк, замена разорвёт связь).

## Правки

1. Правишь `master.md` / `workers/*.md` / `LESSONS.md` → сообщи пользователю, что нужен **перезапуск opencode** (`/init`): инструкции читаются только на старте. Правка `master.md` меняет поведение всех сессий на этой машине.
2. Новую граблю — сразу в `LESSONS.md` секцией `## <дата> — <тема>`, не в правило: грабли — факт, правило — следствие.
3. Коммиты: conventional (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`), одна тема — один коммит. Стиль репо: `refactor: single orchestrator base, drop swarm codegen`.
4. Пушить в `main` — только по явной просьбе. Force-push запрещён.
5. `.gitattributes`: принудительный LF для `*.md` и `*.sh` — не меняй на CRLF.

## Границы

- ✅ Всегда: правки инструкций = правка в этом репо + коммит; секретов в репо нет и быть не должно (ключи — только в `.env` проектов).
- ⚠️ Спросить перед: изменением формата `master.md`/секций Router, удалением worker'а, изменением имени файла-источника (`master.md`, `LESSONS.md`) — на них завязаны `instructions` и `swarm.sh`.
- 🚫 Никогда: не дублировать `master.md` в `AGENTS.md` (это и был источник рассинхрона), не возвращать codegen-механику, не хардкодить секреты.

## Ссылки

- `master.md` — правила оркестрации (читать первым при правках)
- `AGENTS_CREATION_RULES.md` — шаблон AGENTS.md проекта, Always/Ask/Never границы
- `LESSONS.md` — грабли окружения (LiteLLM, geo-block, DPI, Context7 MCP, symlink-история)
- `~/.config/opencode/opencode.jsonc` — где подключены `instructions`
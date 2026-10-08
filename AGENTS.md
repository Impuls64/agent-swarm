# AGENTS.md — agent-swarm (репозиторий базы правил)

Это репозиторий **единой базы инструкций** для OpenCode-сессий в домашней папке
(`~`, на всех ОС). Пути в этих файлах записываются как `~/...` — не хардкодь
`/home/<user>`, иначе инструкции сломаются на другой машине.
Публикуется в `https://github.com/Impuls64/agent-swarm` (origin = `main`).

## Что где — источник истины

| Файл | Роль | Как грузится |
|------|------|--------------|
| `master.md` | Оркестратор: Router, карта воркспейса, грабли, качество | `instructions` в `~/.config/opencode/opencode.jsonc` → **во всех сессиях** |
| `LESSONS.md` | Лог ошибок/решений по датам | там же, через `instructions` |
| `workers/*.md` | 13 доменных модулей | **не грузятся автоматически**, читаются по Router'у из `master.md` по требованию |
| `AGENTS_CREATION_RULES.md` | Спецификация: как писать AGENTS.md | по надобности |
| `swarm.sh` | Справочник `list` | вручную |
| `install.sh` | Установка на новую машину | вручную; **после неё обязательно** прописать `instructions` в `~/.config/opencode/opencode.jsonc` — скрипт только печатает готовый блок |

Нет CI, тестов, линтера, pre-commit. Порядок проверки изменений:

```bash
bash -n install.sh swarm.sh                     # 1. синтаксис скриптов
grep -oE 'workers/[a-z0-9-]+\.md' master.md | cut -d/ -f2 | cut -d. -f1 | sort -u > /tmp/router.txt
ls workers/*.md | xargs -n1 basename | sed 's/\.md$//' | sort -u > /tmp/files.txt
diff /tmp/router.txt /tmp/files.txt             # 2. Router == workers
for f in AGENTS_*.md; do [ -L "$f" ] && readlink "$f"; done | grep '^/' && echo "ABSOLUTE LINKS!" || echo "links ok"
# 3. установка в песочнице с чужим HOME (реальный ~/.agents не трогаем)
rm -rf /tmp/opencode/swarmtest && mkdir -p /tmp/opencode/swarmtest/fakehome
cp -r . /tmp/opencode/swarmtest/fakehome/.agents
( cd /tmp/opencode/swarmtest/fakehome/.agents && HOME=/tmp/opencode/swarmtest/fakehome bash ./install.sh </dev/null )
for f in /tmp/opencode/swarmtest/fakehome/.agents/AGENTS_*.md; do [ -e "$f" ] || echo "BROKEN: $f"; done
```

## Инварианты (нарушение ломает базу)

- **Router-таблица в `master.md` = список `workers/*.md` 1:1.** Новый worker = файл + строка в Router. Проверка (POSIX, работает и на macOS/BSD grep):
  ```bash
  grep -oE 'workers/[a-z0-9-]+\.md' master.md | cut -d/ -f2 | cut -d. -f1 | sort -u \
    > /tmp/router.txt
  ls workers/*.md | xargs -n1 basename | sed 's/\.md$//' | sort -u > /tmp/files.txt
  diff /tmp/router.txt /tmp/files.txt
  ```
- **Workers не подключать через `instructions`** — постоянный раздув контекста (`osengine.md` = 325 строк, исключение из лимита ≤200: это справочник + upstream-правила). Только `master.md` + `LESSONS.md`.
- **`~/AGENTS.md` не существует и не должен появляться.** Раньше `swarm.sh`/`install.sh` его генерировали (`cp master.md ~/AGENTS.md`) — отсюда рассинхрон. `install.sh` теперь только удаляет легаси.
- **`~/bin/use-project` устарел** — он копирует `master.md` в проект как `AGENTS.md` и создаёт `~/AGENTS.md`→проект, возвращая сломанный codegen. `~/bin` стоит первым в `PATH`, поэтому скрипт вызывается легко — не запускать без явного запроса пользователя.
- **13 симлинков `AGENTS_*.md` в корне репо — легаси `install.sh`, и они закоммичены** (git mode `120000`). Цели **относительные** (`workers/<name>.md`) — не переводи на абсолютные и не заменяй файлом: правка идёт в `workers/<name>.md`, а запись по имени `AGENTS_<name>.md` разорвёт связь.

## Пути: `~`, `$HOME`, абсолютные

`~` — не путь, а раскрытие оболочкой (`$HOME`). Файловая система его не знает.

- В тексте инструкций — `~/...`; в скриптах — `"$HOME/..."` (работает и без интерактивного шелла); в путях внутри Docker — как есть (`/home/node/.n8n`, `/usr/local/...` — это пути **внутри** контейнера, их не «переносить»).
- **В вызовах инструментов (read/glob/grep) — абсолютный путь.** `~` там не раскрывается: проверено, `read("~/.agents/swarm.sh")` ищет `/home/<user>/~/.agents/swarm.sh` и не находит файл.
- В WSL `~` = Linux-юзер *внутри* WSL (`/home/<user>`), Windows-дерево — в `/mnt/c/...`. `~` ≠ `C:\Users\<user>`.
- opencode расширяет `~` в поле `instructions` (проверено на этой машине) — на этом держится подключение `master.md`/`LESSONS.md`. В скриптах на это не полагаться.

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

- `master.md` — правила оркестрации (читать первым при правках); там же раздел «RU-документация: fetch → LLM»
- `AGENTS_CREATION_RULES.md` — шаблон AGENTS.md проекта, Always/Ask/Never границы
- `LESSONS.md` — грабли окружения (LiteLLM, geo-block, DPI, Context7 MCP, symlink-история, парсинг RU-доков)
- `~/.config/opencode/opencode.jsonc` — где подключены `instructions`
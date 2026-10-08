# LESSONS.md — Ошибки и решения

## Правило

Каждый агент ДОЛЖЕН:
1. Читать этот файл перед началом работы
2. Добавлять свои ошибки и решения по окончании
3. Проверять — не решалась ли уже эта проблема

---

## GitHub Pages

### Ошибка: index.html не отображается (404)
**Контекст:** Статический сайт на GitHub Pages
**Причина:** GitHub Pages по умолчанию использует Jekyll, который игнорирует файлы/папки с подчеркиванием
**Решение:** Создать файл `.nojekyll` в корне репозитория
```bash
touch .nojekyll
git add .nojekyll
git commit -m "chore: disable jekyll"
```
**Время потеряно:** 15 минут

---

## Локальные HTTP-серверы

### Ошибка: Playwright не может подключиться к localhost
**Контекст:** Скриншоты сайтов через Playwright
**Причина:** `python -m http.server` в фоне через `&` не успевает запуститься
**Решение 1 (быстрое):** Использовать `file://` протокол
```python
await page.goto('file:///absolute/path/to/index.html')
```
**Решение 2 (правильное):** Запускать сервер через `nohup` с задержкой
```bash
nohup python3 -m http.server 8080 > /dev/null 2>&1 &
sleep 2  # дать серверу время стартовать
```
**Время потеряно:** 20 минут

### Ошибка: порт 8080 занят / connection refused
**Контекст:** Повторный запуск сервера
**Причина:** Процесс из прошлого запуска ещё висит
**Решение:** Использовать уникальные порты или убивать старые процессы
```bash
pkill -f "http.server"  # убить все серверы
python3 -m http.server 8081  # другой порт
```

---

## Figma API

### Ошибка: Нельзя загрузить изображения через REST API
**Контекст:** Автоматическая загрузка скриншотов в Figma
**Причина:** Figma REST API позволяет только читать файлы, не писать
**Решение:** 
- Для демо использовать GitHub Pages (живой сайт)
- Для презентаций — ручная загрузка через браузер
- Альтернатива: Figma Widget API (сложнее)
**Время потеряно:** 10 минут

---

## Python / Playwright

### Ошибка: pip install не работает без sudo
**Контекст:** Установка Playwright в системный Python
**Причина:** PEP 668 — защита системного Python
**Решение:** Использовать `--break-system-packages` (ок для контейнеров/dev) или venv
```bash
pip install playwright --break-system-packages
```
**Время потеряно:** 5 минут

---

## Файловая система / Симлинки

### Ошибка: Путаница с AGENTS.md
**Контекст:** Проектный AGENTS.md и глобальный
**Причина:** Симлинк `~/AGENTS.md` указывал на проект, при перемещении проекта симлинк сломался
**Решение:** 
- Для проектов: `use-project` скрипт пересоздаёт симлинк
- Для глобальных правил: не файл в home, а `"instructions"` в `~/.config/opencode/opencode.jsonc` (см. запись 2026-10-08 ниже)
```bash
# Проверка симлинка
ls -la ~/AGENTS.md
# Если сломан — удалить и скопировать
rm ~/AGENTS.md
cp ~/.agents/master.md ~/AGENTS.md
```
**Время потеряно:** 10 минут

---

## Git

### Ошибка: git push без remote
**Контекст:** Новый репозиторий
**Причина:** Репозиторий создан локально, remote не добавлен
**Решение:**
```bash
git remote add origin https://github.com/USER/REPO.git
git push -u origin main
```
**Время потеряно:** 5 минут

---

## Общие рекомендации

### Всегда проверять:
1. **Пути** — после перемещения файлов проверить симлинки
2. **Порты** — при запуске серверов использовать `sleep 2`
3. **GitHub Pages** — добавлять `.nojekyll` для статики
4. **Права** — `chmod 600` для файлов с секретами

### Не делать:
- Не догадываться об API — читать документацию сразу
- Не использовать `localhost` в автоматизации без проверки
- Не коммитить `.env` файлы

---

---

## Bing News RSS

### Ошибка: Bing RSS возвращает пустой ответ на русские запросы
**Контекст:** Универсальный парсер новостей, генерация Bing RSS URL
**Причина:** Bing не принимает кириллицу в URL без URL-кодирования
**Решение:** Кодировать запрос через `urllib.parse.quote()`
```python
import urllib.parse
query = urllib.parse.quote("искусственный интеллект Москва")
url = f"https://www.bing.com/news/search?q={query}&format=rss"
```
**Время потеряно:** 10 минут

### Ошибка: Bing RSS блокирует запросы без User-Agent
**Контекст:** curl запросы к Bing News
**Причина:** Bing требует заголовок User-Agent
**Решение:** Добавлять `-A "Mozilla/5.0"`
```bash
curl -s -A "Mozilla/5.0" "https://www.bing.com/news/search?q=...&format=rss"
```
**Время потеряно:** 5 минут

---

## HTML Парсинг / Cheerio

### Ошибка: Cheerio возвращает 0 элементов на популярных новостных сайтах
**Контекст:** Парсинг Хабр, РБК, Лента, VC.ru через cheerio
**Причина:** Современные сайты рендерят контент через JavaScript (React/Vue), cheerio парсит только серверный HTML
**Решение:**
1. Использовать RSS-фиды где возможно (Лента, Хабр — есть RSS)
2. Для JS-сайтов — headless browser (Puppeteer/Playwright)
3. Проверять через `view-source:` перед написанием селекторов

**Проверенные работающие сайты:**
- Хабр (частично, серверный рендер)
- РИА Новости (серверный рендер)

**Требуют JS:**
- РБК, Лента.ру, VC.ru, TJournal
**Время потеряно:** 15 минут

---

## Формат добавления новых ошибок

```markdown
### Ошибка: [краткое описание]
**Контекст:** [где/когда]
**Причина:** [почему случилось]
**Решение:** [код или команды]
**Время потеряно:** [N минут]
```

## 2026-10-06 — OpenCode + Kimi
- Ключ `sk-kimi-*` из Kimi Code Console валиден только на `https://api.kimi.com/coding/v1` (или `api.kimi.ai/coding/v1`), НЕ на `api.moonshot.cn` — там 401 Invalid Authentication.
- Провайдер opencode `moonshotai` (`api.moonshot.ai`) виснет из РФ в opencode (Bun HTTP): `ProviderHeaderTimeoutError` через 300с, хотя curl работает. Решение: использовать встроенные провайдеры `kimi-code-plan-cn` / `kimi-code-plan-global` с ключом `sk-kimi-*`.
- Дефолтная модель: `kimi-code-plan-global/kimi-for-coding` (поле `model` в `~/.config/opencode/opencode.jsonc`).
- Ключи Moonshot (`sk-*` без префикса kimi) — это platform.moonshot.ai, для Kimi Code не подходят.

## 2026-10-08 — LiteLLM free-LLM pool для opencode
- Прокси: `~/work/opencode-llm` (LiteLLM, порт 4000, autostart через cron @reboot `start.sh`, `restart.sh` регенерирует config из `.env`).
- Geo-block из РФ без VPN: OpenRouter, Groq, Google AI Studio (страница и API). Работают: GigaChat (Сбер), Mistral API, api.github.com.
- `models.github.ai` DPI-подменяет ВСЕ ответы на `200 OK text/plain` — признак блокировки, не рабочий API. Проверять настоящесть API: валидный токен должен давать JSON-ответ, а не "OK".
- GigaChat TLS удостоверяется «Russian Trusted Root CA» (Минцифры) — не в системном хранилище. Решение: bundle из цепочки, которую присылает сам сервер (`openssl s_client -showcerts`), положить в `certs/`, экспорт `SSL_CERT_FILE`/`REQUESTS_CA_BUNDLE` в start.sh. Публичные зеркала корневого серта (gosuslugi/diadoc/kontur) недоступны или отдают HTML.
- GigaChat Authorization Key = base64 `client_id:client_secret`; OAuth: POST `ngw.devices.sberbank.ru:9443/api/v2/oauth` (Basic key, scope=GIGACHAT_API_PERS, RqUID uuid). Работает тариф Старт (бесплатный). LiteLLM: `model: gigachat/GigaChat-2-Max`, `api_key: os.environ/GIGACHAT_AUTH_KEY`.
- LiteLLM fallback-цепочку генерировать ТОЛЬКО из существующих моделей: fallback на отсутствующую в config модель даёт BadRequestError и рвёт цепочку.
- LiteLLM proxy требует `pip install 'litellm[proxy]'` (websockets и др.).
- `pkill -f <pattern>` внутри `bash -c` убивает сам себя, если pattern есть в cmdline (self-match). Безопасно: `pgrep -f 'pattern[x]'` (трюк с квадратной скобкой).
- Фоновые процессы, запущенные в bash-инструменте, умирают при timeout'е команды — длинные операции держать в пределах лимита или перезапускать отдельным вызовом.
- Безключевой Pollinations (`text.pollinations.ai/openai`, anonymous) работает, но общая квота нестабильна: окна `402`/`500 ENOSPC` со стороны сервера — это не баг конфигурации.

## 2026-10-08 — Context7 MCP
- Локальный `@upstash/context7-mcp` падает на Node 20.19 (`webidl.util.markAsUncloneable is not a function`, конфликт jose ↔ встроенный undici). Решение: remote MCP `https://mcp.context7.com/mcp` в `opencode.jsonc` (`type: remote`) — работает без API-ключа, инструменты `resolve-library-id`, `query-docs`. Сервер stateless (MCP-Session-Id не выдаёт).

## 2026-10-08 — Реорганизация базы: 1 оркестратор без codegen
- `swarm.sh activate/reset` делал `cp master.md ~/AGENTS.md` — файл молча перезаписывался, а `.active` расходился с реальным содержимым (`~/AGENTS.md` содержал одну строку при активных frontend/wordpress/tilda). Решение: удалить codegen, правила грузятся через `"instructions"` в `~/.config/opencode/opencode.jsonc` (`master.md` + `LESSONS.md`), workers читаются по Router-таблице по требованию.
- OpenCode читает ТОЛЬКО ближайший `AGENTS.md` вверх по дереву + глобальный `~/.config/opencode/AGENTS.md`. Вложенные `backend/AGENTS.md` (паттерн монорепо из спецификации agents.md) НЕ читаются — это поведение Cursor/Copilot. Один проект = один AGENTS.md в корне.
- Все 13 workers (~58 КБ, `osengine.md` — 18 КБ) в `instructions` подключать нельзя: постоянный раздув контекста. Router в master.md + чтение файла по требованию.
- Дубли источников (master.md vs AGENTS.md vs ~/AGENTS.md) — источник рассинхрона. Решено разделением ролей: `master.md` = глобальные правила (через `instructions`), `~/.agents/AGENTS.md` = инструкции по работе в этом репо, `~/AGENTS.md` удалён.

## 2026-10-08 — MCP fetch: парсинг RU-документации для LLM
- Инструмент: `mcp-server-fetch` v2026.8.18 через `uv tool install`, битарь `~/.local/bin/mcp-server-fetch`. Подключён в `~/.config/opencode/opencode.jsonc` с `--ignore-robots-txt` (обязателен: RU-доки без этого режут по robots).
- Проверено 200 OK и корректный markdown-вывод: `developers.sber.ru/docs/...`, `yandex.cloud/ru/docs/...`, `dadata.ru/api/clean/`, `mcs.mail.ru/docs/`. Недоступен: `cloud.tech/mfc/doc` (DNS/сеть мёртвые).
- `context7` для RU не помогает: у него нет GigaChat/Yandex Cloud/Дадаты — это зарубежные базы. Для РФ-доков цепочка: fetch → текст → LLM (см. правила «RU-документация» в master.md).
- Голая очистка HTML регексами (curl + regex) теряет контент: sber выдал 243 КБ HTML, из которых 3.3 КБ текста — таблицы параметров и примеры грузятся JS. Не писать свой парсер: mcp-fetch даёт нормальный markdown сразу.
- Страницы Sber отдают `text/html` даже на `Accept: text/markdown` — забирать обычным режимом `format: "markdown"`, `html`-режим нужен только если нужна навигация со ссылками.

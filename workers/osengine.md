# OsEngine Worker (upstream rules)

Алгориттическая торговля на C# (WPF/WinForms), open-source платформа OsEngine.

**Триггеры:** `osengine`, `os engine`, `осэнжин`, `trading bot`, `торговый робот`,
`алготрейдинг`, `c# trading`, `оптимизатор`, `bot panel`, `MOEX connector`,
`crypto exchange connector`, `технический индикатор`, `backtest`, `walk-forward`

**Источник правил:** [`project/AGENTS.md`](https://github.com/AlexWan/OsEngine/blob/master/project/AGENTS.md)
репозитория `AlexWan/OsEngine` (1033⭐, ветка `master`, синхронизировано 2026-10-08).
Блок ниже — **дословно**, он главный: при конфликте правил выигрывает он.
Обновлять только пересинхронизацией с upstream, иначе разойдётся.

**Отличия окружения (opencode/WSL2, не Kimi Shell):**
- `WriteFile` / `StrReplaceFile` → инструменты `write` / `edit`; `Shell` → `bash`; `Agent(...)` → task tool.
- В этом окружении .NET SDK нет; сборка идёт на машине с проектом. Отсюда (WSL2) видны только
  копии в `~/Engine` и бэкапы в `~/osengine_backups` — править их как рабочие файлы нельзя.
- Собрать Windows-бинарь через WSL: `"/mnt/c/Program Files/dotnet/dotnet.exe" build OsEngine/OsEngine.csproj`
  (пути — относительно `project/`, как требует «Среда» в правилах).
- Перед работой читать `CONTEXT.md` и доменный `CONTEXT_*.md` из upstream — их даром в файле
  не переписать, но ссылки в правилах на них реальны.

---

# AGENTS.md — Правила для ИИ-агентов

> Действует на корень проекта и подкаталоги. Собственный `AGENTS.md` в подкаталоге имеет приоритет.

## Перед работой

1. [`CONTEXT.md`](CONTEXT.md) — карта проекта.
2. [`CONTEXT_CODING_GUIDELINES.md`](CONTEXT_CODING_GUIDELINES.md) — стиль кода.
3. Доменный `CONTEXT_*.md` по задаче.
4. Работа с коннекторами (`OsEngine/Market/Servers/`) → [`CONTEXT_CONNECTORS.md`](CONTEXT_CONNECTORS.md).

## Принципы

- Код изменяется только через инструменты (`WriteFile`, `StrReplaceFile`, `Shell`). Показать код в чате — не замена.
- Минимальные изменения. Сохраняй стиль и сигнатуры.
- Не ломай обратную совместимость без необходимости.
- Сохраняй кодировку файлов: не снимай UTF-8 BOM, если он был, и не меняй CRLF на LF — это засоряет дифф.
- Собирай и тестируй после правок.

## Сборка и тесты

```bash
# Завершить процесс, если запущен
taskkill /F /IM OsEngine.exe

# Сборка основного проекта (обычный случай)
dotnet build OsEngine/OsEngine.csproj

# Полная сборка решения — только если тронуты Tests/*
# (DividendsUpdater, McpTestStand и т.п.) или перед релизом
dotnet build OsEngine.sln

# Тестовый стенд MCP
cd Tests/McpTestStand/OsEngine.McpApi.TestStand/bin/Debug/net10.0
./OsEngine.McpApi.TestStand.exe

# Только выбранные модули: номер или подстрока имени, через запятую
# (1 Protocol, 2 Logs, 3 Settings, 4 Config, 5 ServerManagement,
#  6 ServerInstance, 7 SSE, 8 Errors, 9 WikiRobots, 10 WikiIndicators,
#  11 WikiSecurities, 12 WikiDividends, 13 Data, 14 Tester, 15 Terminal,
#  16 SystemLoad, 17 ComparePositions, 18 Proxy, 19 Optimizer, 20 Encryption)
./OsEngine.McpApi.TestStand.exe --module Tester
./OsEngine.McpApi.TestStand.exe --module 5,6
```

Цель стенда: **200/200 passed** (`--transport v2`) и **191/191 passed** (`--transport v1`).

**Важно:** тестовый стенд MCP API (`OsEngine.McpApi.TestStand.exe`) запускать только с **явного разрешения пользователя**.

Стенд работает в foreground. При запуске из Kimi Shell он создаёт собственное видимое консольное окно; вывод дублируется в это окно, в исходный stdout и в лог-файл `mcp-test-stand-yyyyMMdd-HHmmss.log` рядом с `.exe`. Запрещено использовать `run_in_background=true`. Длительность прогона — около 4 минут; дожидаться завершения через `TaskOutput(block=true)` или автоматическое уведомление.

## Исследование кода

- Известный путь / 1–2 запроса: `ReadFile`, `Grep`.
- Больше 3 запросов или незнакомый модуль: `Agent(subagent_type="explore")`.
- Планирование: `Agent(subagent_type="plan")`.
- Сложная задача: `Agent(subagent_type="coder")`.

## Запрещено без разрешения пользователя

- `git commit`, `git push`, `git reset`, `git rebase`.
- Изменения файлов за пределами рабочей директории.
- Установка ПО за пределами рабочей директории.
- Операции с правами администратора.

## Обновляй документацию

Если меняешь:

- MCP API (V2, рекомендуемая) → `CONTEXT_MCP_V2.md`, `TempContext/CONTEXT_MCP_API_DEVELOPMENT.md`.
- MCP API (V1, легаси) → `CONTEXT_MCP_V1.md`.
- Сценарии MCP → `CONTEXT_MCP_SCENARIO_V2.md` (V2) / `CONTEXT_MCP_SCENARIO_V1.md` (V1, легаси).
- Соглашения → `CONTEXT_CODING_GUIDELINES.md`.
- Карту проекта → `CONTEXT.md`.
- Правила агентов → этот файл.

## Среда

- Windows, Git Bash.
- Пути в Shell: используй относительные пути от рабочей директории проекта (`./OsEngine/...`, `./Tests/...`).
- Долгие операции — с `run_in_background=true`.

## Спрашивай пользователя

- Несколько валидных подходов.
- Неясный масштаб или требования.
- Нужны реальные учётные данные для тестов.

## Чек-лист перед ответом

- [ ] Код записан в файловую систему.
- [ ] Сборка успешна (`dotnet build OsEngine/OsEngine.csproj`; для `Tests/*` — `dotnet build OsEngine.sln`).
- [ ] Релевантные тесты пройдены.
- [ ] Документация обновлена при необходимости.
- [ ] Git не мутировал без разрешения.

---

# Локальная справка (НЕ из upstream)

Всё, что ниже — справочные знания про код проекта. Правилами остаётся блок
«AGENTS.md — Правила для ИИ-агентов» выше; при расхождении он главный.
Этот файл — исключение из лимита ≤200 строк на worker (справочник, не регламент).

## Структура проекта

```
./                          # корень клона AlexWan/OsEngine; рабочая директория — ./project
├── project/
│   ├── OsEngine.sln
│   └── OsEngine/
│       ├── OsEngine.csproj          (SDK-style; TFM смотреть в файле, не угадывать)
│       ├── App.xaml / App.xaml.cs   (Application entry point)
│       ├── MainWindow.xaml / .cs    (Main menu with buttons)
│       │
│       ├── OsTrader/                (Bot station, trading UI)
│       │   ├── Gui/                 (RobotUi, RobotUiLight)
│       │   ├── Panels/
│       │   │   ├── BotPanel.cs      (Base class for all robots)
│       │   │   ├── Tab/             (BotTabSimple, BotTabScreener, etc.)
│       │   │   └── Tab.Internal/
│       │   ├── RiskManager/
│       │   └── Grids/
│       │
│       ├── OsOptimizer/             (Strategy optimizer)
│       │   ├── OptimizerMaster.cs   (Main controller)
│       │   ├── OptimizerExecutor.cs (Execution engine)
│       │   ├── OptimizerUi.xaml / .cs
│       │   ├── OptimizerReport.cs   (Results data structures)
│       │   ├── SmartOptimizerUi.xaml / .cs
│       │   └── OptEntity/
│       │
│       ├── OsData/                  (Historical data downloader)
│       ├── OsConverter/             (Data converter)
│       │
│       ├── Robots/                  (built-in strategies)
│       │   ├── BotFactory.cs        (Robot factory / reflection)
│       │   ├── Trend/  CounterTrend/  MarketMaker/
│       │   ├── Screeners/  OnScriptIndicators/  Grids/  FuturesTrend/  IndexArbitrage/
│       │
│       ├── Market/                  (Exchange connectors)
│       │   ├── Servers/
│       │   │   ├── IServer.cs
│       │   │   ├── AServer.cs
│       │   │   ├── Tinkoff/  ByBit/  Binance/  Transaq/  QuikLua/  [60+ more]
│       │   └── Connectors/
│       │
│       ├── Entity/                  (Domain models: Security, Portfolio, Order, MyTrade,
│       │                            Position, Candle/CandleSeries, MarketDepth, Trade)
│       ├── Candles/                 (CandleManager, CandleFactory, TimeFrameBuilder)
│       ├── Charts/                  (IChartPainter, WinFormsChartPainter)
│       ├── Indicators/              (IIndicator, Aindicator, IndicatorsFactory,
│       │                            AindicatorCacheServer)
│       ├── Journal/                 (Journal, PositionController, DealStatisticGenerator)
│       ├── Logging/                 (Log, MessageSender, ServerTelegram, ServerMail,
│       │                            ServerWebhook)
│       ├── Language/                (Ru/En localization: OsLocalization.cs)
│       ├── Alerts/  PrimeSettings/  Layout/
├── related projects/                (TInvestApi, TinkoffInvestmentsApi, Tinkoff_Router,
│                                    FinamApi — submodule)
└── doc/                             (Documentation, manuals)
```

## Ключевые абстракции

| Компонент | Класс/интерфейс | Файл |
|-----------|-----------------|------|
| Робот (база) | `BotPanel` (abstract) | `OsTrader/Panels/BotPanel.cs` |
| Сервер | `IServer` + `AServer` | `Market/Servers/` |
| Security | `Security` | `Entity/Security.cs` |
| Order | `Order` / `MyTrade` | `Entity/Order.cs` |
| Position | `Position` | `Entity/Position.cs` |
| Candle | `Candle` / `CandleSeries` | `Candles/` |
| Indicator | `Aindicator` / `IIndicator` | `Indicators/` |
| Chart | `IChartPainter` → `WinFormsChartPainter` | `Charts/` |
| Journal | `Journal` / `PositionController` | `Journal/` |
| Log | `Log` / `MessageSender` | `Logging/` |

## BotPanel API

```csharp
public MyBot(string name, StartProgram startProgram) : base(name, startProgram)
{
    TabCreate(BotTabType.Simple);
    _tab = TabsSimple[0];
    _tab.CandleFinishedEvent += OnCandleFinished;
}
```

Типы табов: `Simple`, `Index`, `Screener`, `Pair`, `Polygon`, `Cluster`, `News`, `Options`, `SyntheticBond`.

```csharp
_tab.CandleFinishedEvent += OnCandleFinished;      // свеча закрыта
_tab.CandleUpdateEvent += OnCandleUpdate;          // обновление свечи
_tab.MarketDepthUpdateEvent += OnMarketDepth;      // стакан
_tab.NewTickEvent += OnNewTick;                    // новый тик
_tab.PositionOpeningSuccesEvent += OnPositionOpen; // позиция открыта
_tab.PositionClosingSuccesEvent += OnPositionClose;// позиция закрыта

_tab.BuyAtMarket(volume, "Comment");
_tab.SellAtMarket(volume, "Comment");
_tab.BuyAtLimit(volume, price, "Comment");
_tab.SellAtLimit(volume, price, "Comment");
_tab.BuyAtStop(volume, price, stopPrice, "Comment");
_tab.CancelAllOrders();
_tab.CloseAllAtMarket();
_tab.CloseAllAtLimit(price);

// Параметры робота
StrategyParameterInt period = CreateParameter("Period", 14, 5, 50, 1);
StrategyParameterDecimal sl = CreateParameter("StopLoss", 0.5m, 0.1m, 5m, 0.1m);
StrategyParameterBool useTrailing = CreateParameter("UseTrailing", false);
StrategyParameterString mode = CreateParameter("Mode", "Trend", new List<string> { "Trend", "Flat" });
StrategyParameterDecimalCheckBox filter = CreateParameter("Filter", 100m, 10m, 1000m, 10m);
```

## Optimizer API

- `OptimizerMaster` — контроллер процесса оптимизации
- `OptimizerExecutor` — выполнение тестов в потоках
- `OptimizerReport` — результат одного теста
- `OptimizerFazeReport` — результат фазы (InSample/OutOfSample)

Smart Search (`SmartSearchIsOn = true`): крупный шаг → отбор лучших по
`Score = Profit × PF × Sharpe` → сужение диапазона и шаг вдвое → до сходимости.
Результаты: `Engine/SmartOptimizerResults/`.

## Конфигурационные файлы

| Файл | Назначение |
|------|------------|
| `Engine/OptimizerSettings.txt` | настройки оптимизатора |
| `Engine/telegramSet.txt` | Telegram: 4 строки `Token / ChatId / Processing / Proxy` |
| `Engine/*.txt` | настройки компонентов |
| `bin/Debug/Custom/Robots/` | пользовательские роботы |
| `bin/Debug/Custom/Indicators/` | пользовательские индикаторы |

## Конвенции кода

- Стиль OsEngine: смешанные Ru/En комментарии допустимы
- Логирование: `SendNewLogMessage(msg, LogMessageType)`
- Параметры: `CreateParameter(name, default, start, stop, step)`
- Не хардкодить абсолютные пути — только `Engine/` и `Custom/` внутри приложения
- Исключения — с try/catch и логированием, не глотать

## Типовые задачи

**Новый робот:** унаследовать `BotPanel` → `TabCreate(BotTabType.Simple)` в конструкторе →
подписаться на `_tab.CandleFinishedEvent` → реализовать вход/выход → переопределить `GetNameStrategyType()`.

**Новый коннектор биржи:** папка в `Market/Servers/` → реализовать `IServerRealization` →
связать события (`NewCandleIncomeEvent`, `NewTradeEvent` и др.).

**Telegram из РФ (блокировка):** в `Engine/telegramSet.txt` 4-й строкой добавить
`socks5://proxy:port`; альтернатива — правка `Logging/ServerTelegram.cs`.

**Ускорить Optimizer:** `AindicatorCacheServer.IsOn = true`, `ThreadsCount` по числу ядер,
`SmartSearchIsOn` включён по умолчанию.

## XAML и пересборка

XAML компилируется в BAML и встраивается в сборку: правка `.xaml` не меняет
уже запущенный `.exe` — обязательна пересборка.

## Quality Gates

- Нет `catch` без логирования
- Нет хардкода секретов (`.env` или конфиги)
- Тест на Tester перед реальной торговлей
- Walk-forward для оптимизированных параметров
- RiskManager настроен

## Проверки после обновления проекта (git pull / распаковка архива)

1. **Дубли `.cs`:** `find OsEngine/Market/Servers -name "*.cs" | xargs -n1 basename | sort | uniq -d`
   — удалять старую копию, оставлять новую структуру (напр. `BitMartSpot/BitMartSpotServer.cs`).
2. **CS0535** (не реализован член интерфейса): типичные — `Connect(WebProxy)`,
   `Subscribe(Security)`, `SetLeverage()`, `GetActiveOrders()`, `GetActiveOrders()` +
   новые свойства `IServerPermission`. Лечение: обновить файл сервера или удалить сервер.
3. **CS0101** (дубль типа): чаще всего `Pagination` в разных `CoinEx/Entity` — переименовать
   (`PaginationFutures`, `CoinExPagination`).
4. **CS0111** (дубль члена) / **CS0246** (тип не найден): следы удалённых/переехавших классов.
5. **CS0579**: удалить `Properties/AssemblyInfo.cs`, если рядом автогенерация.
6. **Удалённые сервера:** убрать `else if` блоки из `ServerMaster.cs` и `FixMessage.cs`.
7. **Runtime:** `concurrent update` / `NullReferenceException` в `ChartClusterPainter.cs` —
   проверять `InvokeRequired` и null перед `.Points`; `MissingMethodException` — чистить `obj/`/`bin/`;
   `FileNotFoundException` на `Engine/*.txt` — создать с дефолтами.
8. **Чистая сборка:** `rm -rf obj bin/Debug/OsEngine.exe` → пересборка → проверить наличие `.exe`.
9. **Чек-лист:** 0 ошибок сборки → `OsEngine.exe` запускается → открываются Main,
   Optimizer и Tester без падений.

## Справочник C#

Для языка и API — Context7 `/dotnet/docs`; версию TFM смотреть в `OsEngine.csproj`
(стенд тестов в upstream собирается под `net10.0` — не угадывать по старой памяти).

## Локальные пути

- Бэкап перед правками: `~/osengine_backups/current/`
- Связанные заметки проекта: `~/Engine/OsEngine_QuickReference.md`,
  `~/Engine/OsEngine_RobotCreationGuide.md`, `~/Engine/OsEngine_ChangeLog.md`

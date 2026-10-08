# OsEngine Worker Rules

## Domain

Algorithmic trading platform development with OsEngine (C#, WPF/WinForms, .NET 9).

## Triggers

Activate this worker when the user mentions:
- `osengine`, `os engine`, `осэнжин`
- `trading bot`, `торговый робот`, `алготрейдинг`
- `c# trading`, `csharp trading`, `си шарп трейдинг`
- `optimizer`, `оптимизатор`
- `bot panel`, `botpanel`, `ботпанель`
- `MOEX connector`, `crypto exchange connector`
- `technical indicator`, `технический индикатор`
- `backtest`, `бэктест`, `walk-forward`

## Project Location

```
D:\OsEngine-master\
  project\
    OsEngine.sln
    OsEngine\
      OsEngine.csproj
```

## Technology Stack

- **Language:** C# 12 (.NET 9)
- **UI:** WPF + WinForms (hybrid, WindowsFormsHost)
- **Platform:** Windows x64
- **Build:** MSBuild SDK-style project
- **Data:** LiteDB (NoSQL), text files (`Engine/*.txt`)
- **Network:** HttpClient, WebSocket4Net, Grpc.Net.Client
- **Serialization:** Newtonsoft.Json, Google.Protobuf
- **Scripting:** Roslyn (Microsoft.CodeAnalysis.CSharp)

## Compilation Rules (CRITICAL)

**Important:** OsEngine is a compiled application. Changes to `.cs` or `.xaml` files do NOT take effect until the project is rebuilt.

### Rebuilding Without Visual Studio

If you don't have Visual Studio installed, use the .NET CLI:

```bash
# Navigate to project directory
cd "D:\OsEngine-master\project\OsEngine"

# Build the project
dotnet build

# Or rebuild completely (clean + build)
dotnet build --no-incremental

# For Release mode
dotnet build -c Release
```

**Prerequisites:** .NET 9 SDK must be installed. Download from https://dotnet.microsoft.com/download

### Automatic Build (AI can build for you)

The AI can trigger Windows `dotnet.exe` directly from the Linux environment via WSL:
```bash
"/mnt/c/Program Files/dotnet/dotnet.exe" build "D:\OsEngine-master\project\OsEngine\OsEngine.csproj"
```

Or use the provided PowerShell script:
```powershell
# One-click build & run
D:\OsEngine-master\build.ps1
```

The script (`build.ps1`) will:
1. Build the project
2. Show errors if any
3. Automatically launch `OsEngine.exe` on success

### XAML Compilation

XAML files are compiled into BAML and embedded in the assembly. Simply editing `.xaml` files will NOT update the running `.exe`. You MUST rebuild the project.

### Running After Build

After building, the executable is at:
```
D:\OsEngine-master\project\OsEngine\bin\Debug\OsEngine.exe
```

## Complete Project Structure

```
D:\OsEngine-master/
├── project/
│   ├── OsEngine.sln
│   └── OsEngine/
│       ├── OsEngine.csproj          (SDK-style, net9.0-windows)
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
│       │   ├── SmartOptimizerUi.xaml / .cs  (NEW: Smart Optimizer)
│       │   └── OptEntity/
│       │       ├── AsyncBotFactory.cs
│       │       └── OptimizerDataStorage.cs
│       │
│       ├── OsData/                  (Historical data downloader)
│       ├── OsConverter/             (Data converter)
│       │
│       ├── Robots/                  (~158 built-in strategies)
│       │   ├── BotFactory.cs        (Robot factory / reflection)
│       │   ├── Trend/               (Trend strategies)
│       │   ├── CounterTrend/        (Counter-trend strategies)
│       │   ├── MarketMaker/         (MM strategies)
│       │   ├── Screeners/           (Multi-security screeners)
│       │   ├── OnScriptIndicators/  (Indicator-based bots)
│       │   ├── Grids/               (Grid trading)
│       │   ├── FuturesTrend/        (Futures-specific)
│       │   ├── IndexArbitrage/      (Index arbitrage)
│       │   └── [30+ more folders]
│       │
│       ├── Market/                  (Exchange connectors)
│       │   ├── Servers/
│       │   │   ├── IServer.cs
│       │   │   ├── AServer.cs
│       │   │   ├── [Exchange folders:]
│       │   │   ├── Tinkoff/
│       │   │   ├── ByBit/
│       │   │   ├── Binance/
│       │   │   ├── Transaq/
│       │   │   ├── QuikLua/
│       │   │   └── [60+ more]
│       │   └── Connectors/
│       │
│       ├── Entity/                  (Domain models)
│       │   ├── Security.cs
│       │   ├── Portfolio.cs
│       │   ├── Order.cs / MyTrade.cs
│       │   ├── Position.cs
│       │   ├── Candle.cs / CandleSeries.cs
│       │   ├── MarketDepth.cs
│       │   └── Trade.cs
│       │
│       ├── Candles/                 (Candle engine)
│       │   ├── CandleManager.cs
│       │   ├── CandleFactory.cs
│       │   └── TimeFrameBuilder.cs
│       │
│       ├── Charts/                  (Charting)
│       │   ├── IChartPainter.cs
│       │   └── WinFormsChartPainter.cs
│       │
│       ├── Indicators/              (Indicator factory)
│       │   ├── IIndicator.cs
│       │   ├── Aindicator.cs
│       │   ├── IndicatorsFactory.cs
│       │   └── AindicatorCacheServer.cs
│       │
│       ├── Journal/                 (Trade journal)
│       │   ├── Journal.cs
│       │   └── Internal/
│       │       ├── PositionController.cs
│       │       └── DealStatisticGenerator.cs
│       │
│       ├── Logging/                 (Logs & notifications)
│       │   ├── Log.cs
│       │   ├── MessageSender.cs
│       │   ├── ServerTelegram.cs    (Telegram bot integration)
│       │   ├── ServerMail.cs
│       │   └── ServerWebhook.cs
│       │
│       ├── Language/                (Ru/En localization)
│       │   └── OsLocalization.cs
│       │
│       ├── Alerts/                  (Price alerts)
│       ├── PrimeSettings/           (Global settings)
│       └── Layout/                  (Window layout manager)
│
├── related projects/
│   ├── TInvestApi/                  (Tinkoff gRPC API)
│   ├── TinkoffInvestmentsApi/
│   └── Tinkoff_Router/
│
└── doc/                             (Documentation, manuals)
```

## Key Abstractions

| Component | Class/Interface | File |
|-----------|----------------|------|
| Robot base | `BotPanel` (abstract) | `OsTrader/Panels/BotPanel.cs` |
| Server | `IServer` + `AServer` | `Market/Servers/` |
| Security | `Security` | `Entity/Security.cs` |
| Order | `Order` / `MyTrade` | `Entity/Order.cs` |
| Position | `Position` | `Entity/Position.cs` |
| Candle | `Candle` / `CandleSeries` | `Candles/` |
| Indicator | `Aindicator` / `IIndicator` | `Indicators/` |
| Chart | `IChartPainter` → `WinFormsChartPainter` | `Charts/` |
| Journal | `Journal` / `PositionController` | `Journal/` |
| Log | `Log` / `MessageSender` | `Logging/` |

## BotPanel API

### Constructor
```csharp
public MyBot(string name, StartProgram startProgram) : base(name, startProgram)
{
    TabCreate(BotTabType.Simple);
    _tab = TabsSimple[0];
    _tab.CandleFinishedEvent += OnCandleFinished;
}
```

### Tab Types
- `BotTabType.Simple` - Single instrument
- `BotTabType.Index` - Index from multiple instruments
- `BotTabType.Screener` - Multi-instrument screener
- `BotTabType.Pair` - Pair trading
- `BotTabType.Polygon` - Currency arbitrage
- `BotTabType.Cluster` - Cluster chart
- `BotTabType.News` - News feed
- `BotTabType.Options` - Options
- `BotTabType.SyntheticBond` - Synthetic bonds

### Events
```csharp
_tab.CandleFinishedEvent += OnCandleFinished;      // Candle closed
_tab.CandleUpdateEvent += OnCandleUpdate;            // Candle updated (tick)
_tab.MarketDepthUpdateEvent += OnMarketDepth;        // Market depth update
_tab.NewTickEvent += OnNewTick;                      // New tick
_tab.PositionOpeningSuccesEvent += OnPositionOpen;   // Position opened
_tab.PositionClosingSuccesEvent += OnPositionClose;  // Position closed
```

### Trading Methods
```csharp
// Market orders
_tab.BuyAtMarket(volume, "Comment");
_tab.SellAtMarket(volume, "Comment");

// Limit orders
_tab.BuyAtLimit(volume, price, "Comment");
_tab.SellAtLimit(volume, price, "Comment");

// Stop orders
_tab.BuyAtStop(volume, price, stopPrice, "Comment");
_tab.SellAtStop(volume, price, stopPrice, "Comment");

// Close positions
_tab.CloseAllAtMarket();           // Close all at market
_tab.CloseAllAtLimit(price);       // Close all at limit
_tab.CancelAllOrders();            // Cancel active orders
```

### Parameters
```csharp
// Integer
StrategyParameterInt period = CreateParameter("Period", 14, 5, 50, 1);

// Decimal
StrategyParameterDecimal sl = CreateParameter("StopLoss", 0.5m, 0.1m, 5m, 0.1m);

// Bool
StrategyParameterBool useTrailing = CreateParameter("UseTrailing", false);

// String/Enum
StrategyParameterString mode = CreateParameter("Mode", "Trend", new List<string> { "Trend", "Flat" });

// Decimal + CheckBox
StrategyParameterDecimalCheckBox filter = CreateParameter("Filter", 100m, 10m, 1000m, 10m);
```

## Optimizer API

### Key Classes
- `OptimizerMaster` - Main controller, manages optimization process
- `OptimizerExecutor` - Executes tests in threads
- `OptimizerReport` - Single test result
- `OptimizerFazeReport` - Results for one phase (InSample/OutOfSample)

### Smart Search (NEW)
- Enabled by default: `SmartSearchIsOn = true`
- Iterative adaptive refinement:
  1. Iteration 1: Coarse search with large step
  2. Select best by Score = Profit × PF × Sharpe
  3. Narrow range around best, halve step
  4. Repeat until convergence (step = 1 for int, 0.01 for decimal)
- Results saved to: `Engine\SmartOptimizerResults\`

## Configuration Files

| File | Purpose |
|------|---------|
| `Engine\OptimizerSettings.txt` | Optimizer configuration |
| `Engine\telegramSet.txt` | Telegram bot settings (4 lines: Token, ChatId, Processing, Proxy) |
| `Engine\*.txt` | Component settings (various) |
| `bin\Debug\Custom\Robots\` | Custom robot scripts |
| `bin\Debug\Custom\Indicators\` | Custom indicators |

## Code Conventions

- Follow existing OsEngine style (mixed Ru/En comments accepted)
- Use `SendNewLogMessage(msg, LogMessageType)` for logging
- Parameters: `CreateParameter(name, default, start, stop, step)`
- Events: `CandleFinishedEvent`, `PositionOpeningSuccesEvent`
- Tab access: `TabsSimple[0]` after `TabCreate(BotTabType.Simple)`
- Never hardcode paths; use `Engine\` or `Custom\` relative paths
- Handle exceptions with try/catch; log errors

## Common Tasks

### Create a new robot
1. Inherit from `BotPanel`
2. Call `TabCreate(BotTabType.Simple)` in constructor
3. Subscribe to `_tab.CandleFinishedEvent`
4. Implement entry/exit logic
5. Override `GetNameStrategyType()`

### Add a new exchange connector
1. Create folder in `Market/Servers/`
2. Implement `IServerRealization`
3. Wire up events: `NewCandleIncomeEvent`, `NewTradeEvent`, etc.

### Fix Telegram (Russia block)
- Edit `Engine\telegramSet.txt` — add proxy URL line 4
- Format: `BotToken\nChatId\nTrue\nsocks5://proxy:port`
- Or edit `Logging/ServerTelegram.cs` directly

### Speed up Optimizer
- Enable `AindicatorCacheServer.IsOn = true`
- Increase `ThreadsCount` (up to CPU cores)
- Enable `SmartSearchIsOn` (enabled by default now)

## .NET 9 Reference

Use Context7 library `/dotnet/docs` for C# language and API reference.
Key topics:
- `HttpClient` / `HttpClientHandler` / proxy configuration
- `Task` / `async await` / `Parallel.ForEach`
- `LINQ` / `Collections.Generic`
- `Memory<T>` / `Span<T>` performance
- `Unsafe` blocks (project has `AllowUnsafeBlocks=true`)

## Quality Gates

- No bare `catch` without logging
- No hardcoded secrets (use `.env` or config files)
- Test on Tester before real trading
- Walk-forward validation for optimized parameters
- RiskManager must be configured

## Backup

Before editing: backup to `/home/bob/osengine_backups/current/`

## Error Checking & Verification Rules

### After Project Update (CRITICAL)

When OsEngine project is updated (git pull, zip extract, etc.), ALWAYS run these checks:

#### 1. Duplicate Files Check
```bash
# Find duplicate .cs files across server folders
find project/OsEngine/Market/Servers -name "*.cs" | xargs -I {} basename {} | sort | uniq -d

# Find duplicate class definitions
grep -r "class .*ServerRealization" project/OsEngine/Market/Servers/ | awk '{print $3}' | sort | uniq -d
```

**Common duplicates after update:**
- Old root files vs new subfolder files (e.g., `BitMart.cs` vs `BitMartSpot/BitMartSpotServer.cs`)
- Old `Entity/` folders vs new `Entity/` folders
- Old `Json/` folders vs new `Json/` folders
- `*ServerPermission.cs` files moved to subfolders

**Fix:** Remove OLD files, keep NEW structure.

#### 2. Missing Interface Implementation Check
```bash
# Build and look for CS0535 errors
# Common missing members after update:
# - IServerRealization: Connect(WebProxy), Subscribe(Security), SetLeverage(), GetActiveOrders(), GetHistoricalOrders()
# - IServerPermission: new bool properties
```

**Fix:** Update old server files or remove deprecated servers.

#### 3. Namespace / Class Name Conflicts
```bash
# Look for CS0101 errors (duplicate type names)
grep -r "class .*" project/OsEngine/Market/Servers/*/Entity/*.cs | grep -v "/bin/"
```

**Common conflicts:**
- `Pagination` class in multiple CoinEx Entity folders
- `ResponseRestMessage` classes with same namespace
- `Signer` utility class missing

**Fix:** Rename classes (e.g., `Pagination` → `PaginationFutures`, `CoinExPagination`) or merge files.

#### 4. Removed Server References Check
```bash
# Check ServerMaster.cs for references to deleted servers
grep -n "ExmoSpotServer\|LmaxServer\|TinkoffServer" project/OsEngine/Market/ServerMaster.cs
```

**Fix:** Remove `else if` blocks for deleted servers from `ServerMaster.cs` and `FixProtocolEntities/FixMessage.cs`.

#### 5. Build Verification
```bash
# Must show "Ошибок: 0" (0 errors)
"/mnt/c/Program Files/dotnet/dotnet.exe" build "D:\OsEngine-master\project\OsEngine\OsEngine.csproj"
```

**Build command from WSL:**
```bash
"/mnt/c/Program Files/dotnet/dotnet.exe" build "D:\OsEngine-master\project\OsEngine\OsEngine.csproj" 2>&1 | tail -5
```

#### 6. Runtime Error Checking

After successful build, launch `OsEngine.exe` and watch for:

**Common runtime errors:**

| Error | File | Fix |
|-------|------|-----|
| `InvalidOperationException: concurrent update` | `ChartClusterPainter.cs` | Ensure UI thread creation; add null checks |
| `NullReferenceException` | `ChartClusterPainter.cs` | Add null checks before accessing `.Points.Count` |
| `MissingMethodException` | Various | Old binary cached; clean `obj/` and `bin/` folders |
| `FileNotFoundException` | `Engine/*.txt` | Create missing config files with defaults |
| `DllNotFoundException` | Native DLLs | Ensure `libcrypto-3-x64.dll`, `libssl-3-x64.dll` in output |

**ChartClusterPainter fixes:**
```csharp
// In CreateChart() - ensure UI thread
if (_chart == null)
{
    _chart = new Chart();  // Don't recreate if exists
}

// In ClearDataPointsAndSizeValue() - null check
Series oldcandleSeries = FindSeriesByNameSafe("SeriesCluster");
if (oldcandleSeries != null && oldcandleSeries.Points.Count != 0)
{
    oldcandleSeries.Points.ClearFast();
}
```

#### 7. Clean Build Procedure

If build has persistent errors:
```bash
# 1. Clean everything
rm -rf "D:\OsEngine-master\project\OsEngine\obj"
rm -rf "D:\OsEngine-master\project\OsEngine\bin\Debug\OsEngine.exe"

# 2. Rebuild
"/mnt/c/Program Files/dotnet/dotnet.exe" build "D:\OsEngine-master\project\OsEngine\OsEngine.csproj"

# 3. Verify executable exists
ls -la "D:\OsEngine-master\project\OsEngine\bin\Debug\OsEngine.exe"
```

#### 8. Post-Update Checklist

- [ ] No CS0111 (duplicate member) errors
- [ ] No CS0535 (missing interface) errors  
- [ ] No CS0101 (duplicate type) errors
- [ ] No CS0246 (type not found) errors
- [ ] Build: 0 errors, 0 warnings ideally
- [ ] `OsEngine.exe` launches without crash
- [ ] Main window opens (no XAML errors)
- [ ] Can open Optimizer window
- [ ] Can open Tester window

### Common Error Patterns & Solutions

**Pattern 1: `CS0111 — Type already defines member`**
- Cause: Duplicate method from old + new file
- Fix: Remove older file version

**Pattern 2: `CS0535 — Does not implement interface member`**
- Cause: Old server file missing new interface methods
- Fix: Update file from GitHub or delete deprecated server

**Pattern 3: `CS0101 — Namespace already contains definition`**
- Cause: Same class name in two files
- Fix: Rename one class or remove duplicate file

**Pattern 4: `CS0246 — Type or namespace not found`**
- Cause: Referenced class was deleted/moved
- Fix: Remove using directive or update reference

**Pattern 5: `CS0579 — Duplicate attribute`**
- Cause: `AssemblyInfo.cs` exists + auto-generated
- Fix: Delete `Properties/AssemblyInfo.cs`

**Pattern 6: Runtime `NullReferenceException` in Charts**
- Cause: Series/Points accessed without null check
- Fix: Add `!= null` checks before accessing chart elements

**Pattern 7: Runtime `InvalidOperationException` in FontCache**
- Cause: Chart created on non-UI thread
- Fix: Ensure `InvokeRequired` check covers null case; don't recreate Chart if exists

## Related Files

- `D:\OsEngine-master\OsEngine_QuickReference.md`
- `D:\OsEngine-master\OsEngine_RobotCreationGuide.md`
- `D:\OsEngine-master\OsEngine_ChangeLog.md`

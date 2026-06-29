# DPI Switch

Минималистичное iOS-приложение для обхода DPI-блокировок.  
Основано на [SwByeDPI](https://github.com/mIwr/SwByeDPI) / [byedpi](https://github.com/hufrea/byedpi).

---

## Требования

- Mac с macOS 12.0+ (Monterey или новее)
- Xcode 15.0+
- iPhone с iOS 16.0+
- Apple ID (бесплатного достаточно для запуска на своём устройстве)

---

## Установка на Mac (пошагово)

### Шаг 1 — Открыть Xcode

Запусти Xcode. Если не установлен — скачай из App Store.

### Шаг 2 — Создать новый Xcode проект

```
File → New → Project...
```

Выбери:
- **iOS** → **App**
- Product Name: `DPISwitch`
- Interface: **SwiftUI**
- Language: **Swift**
- Minimum Deployments: **iOS 16.0**

Сохрани проект в папку `DPISwitch/` (рядом с этим README).

### Шаг 3 — Заменить файлы

Удали автоматически созданные файлы (ContentView.swift, Assets.xcassets и т.д.)  
Добавь все файлы из папки `DPISwitch/DPISwitch/`:

```
File → Add Files to "DPISwitch"...
```

Выбери всю папку `DPISwitch/DPISwitch/` и добавь рекурсивно.

### Шаг 4 — Добавить зависимость SwByeDPI

```
File → Add Package Dependencies...
```

Введи URL:
```
https://github.com/mIwr/SwByeDPI.git
```

Выбери версию: **0.17.3 or later**

Добавь в target два модуля:
- `SwByeDPI`
- `ByeDPIKit`

### Шаг 5 — Настроить подпись

В настройках проекта:
```
Signing & Capabilities → Team → [Выбери свой Apple ID]
```

Bundle Identifier можно любой уникальный, например:
```
com.yourname.DPISwitch
```

### Шаг 6 — Запустить на iPhone

Подключи iPhone, выбери его как target device.  
Нажми **Run** (⌘R).

На iPhone появится запрос доверия разработчику:
```
Settings → General → VPN & Device Management → [Твой Apple ID] → Trust
```

---

## Использование

1. Открой приложение
2. Зайди в **Settings** и включи нужные сервисы (YouTube / TikTok / Discord)
3. Нажми большую кнопку — прокси запустится
4. Настрой HTTP-прокси на устройстве:
   ```
   Settings → Wi-Fi → [Твоя сеть] → Configure Proxy → Manual
   Server: 127.0.0.1
   Port: 10800
   ```

---

## Архитектура

```
DPISwitch/
├── App/
│   └── DPISwitchApp.swift          # @main
├── Views/
│   ├── HomeView.swift              # Главный экран
│   └── SettingsView.swift          # Настройки
├── ViewModels/
│   ├── ConnectionViewModel.swift   # Логика подключения
│   └── SettingsViewModel.swift     # Управление пресетами
├── Core/
│   └── ByeDPI/
│       └── ByeDPIService.swift     # Обёртка над ByeDPI API
├── Models/
│   ├── ServicePreset.swift         # Модель пресета
│   └── ConnectionState.swift       # Enum состояния
├── Settings/
│   └── PresetLibrary.swift         # Встроенные пресеты
├── Utilities/
│   └── AppStorageKeys.swift        # UserDefaults ключи
└── Extensions/
    ├── Color+DPISwitch.swift        # Цвета
    └── View+PulseAnimation.swift    # Анимации
```

### MVVM

- **Views** — только отображение, никакой логики
- **ViewModels** — логика, состояние, `@Published`
- **Core** — сервисный слой (ByeDPI API)
- **Models** — чистые структуры данных

---

## Добавление нового пресета

Открой `Settings/PresetLibrary.swift` и добавь новую запись:

```swift
static let instagram = ServicePreset(
    id: "instagram",
    name: "Instagram",
    systemIconName: "camera.fill",
    cmdArgs: ["-s1", "-d1", "-r1+s", "-a1"],
    strategyDescription: "Split для Meta CDN"
)

// И добавь в массив all:
static let all: [ServicePreset] = [
    youtube,
    tiktok,
    discord,
    instagram  // ← новый пресет
]
```

---

## На основе

- [hufrea/byedpi](https://github.com/hufrea/byedpi) — ядро обхода DPI (MIT)
- [mIwr/SwByeDPI](https://github.com/mIwr/SwByeDPI) — Swift wrapper (MIT)

---

## Лицензия

MIT License. Подробности в LICENSE файле.

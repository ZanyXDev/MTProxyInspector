# Аудит кода MTProxyInspector — Сводка

## Общая оценка

Проект находится в ранней стадии разработки. Архитектурный каркас (C++ синглтоны, QML UI, Android-интеграция) заложен корректно, но ключевая бизнес-логика (проверка MTProxy, сохранение результатов) не реализована. Присутствуют 2 критические ошибки времени выполнения, множественные нарушения DRY и остатки кода от другого проекта.

## Сводка проблем по критичности

### 🔴 КРИТИЧЕСКИЕ (crash / неработоспособность)

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 1 | Утечка соединений сигнала (duplicate connect) | `plugins/core/core.cpp` | 86-111 |
| 2 | Несуществующие идентификаторы в MListView | `app/qml/MListView.qml` | 8-12 |

### 🟠 ВЫСОКИЕ (логические ошибки, нарушение DRY)

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 3 | Дублирование switch reachability→message | `core.cpp:66` / `networkmanager.cpp:191` | — |
| 4 | Cross-thread сигнал без qRegisterMetaType | `plugins/core/networkmanager.cpp` | 173 |
| 5 | Незакрытый QFutureWatcher при повторе | `plugins/core/networkmanager.cpp` | 173-181 |
| 6 | Dead code: MainTest.qml (опечатка QT_DEBUG1) | `app/main.cpp` | 126 |
| 7 | Дублирование Main.qml / MainTest.qml (~50 строк) | `app/qml/` | — |
| 8 | NavigationPane — все onClicked пишут "Россия" | `app/qml/NavigationPane.qml` | 104, 125 |
| 9 | Несуществующее свойство isDebugModeOFF | `plugins/ui/MemoCard.qml`, `SimpleFlip.qml` | 28, 27 |

### 🟡 СРЕДНИЕ

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 10 | Stub-методы: проверка прокси не реализована | `appcontroller.cpp`, `networkmanager.cpp` | — |
| 11 | Hardcoded 360×720 — нет адаптивности | `app/qml/Main.qml` | 90-91 |
| 12 | Нет runtime-запроса BLUETOOTH_SCAN | `plugins/androidutils/` | — |
| 13 | AndroidUtils.create() — thread-safety | `plugins/androidutils/androidutils.cpp` | 8-22 |
| 14 | Неиспользуемый enum SenderTypes | `plugins/core/sendertypes.h` | — |
| 15 | Отсутствует `#include <QTime>` | `core.cpp`, `androidutils.cpp` | — |
| 16 | Тесты из другого проекта (BoardGenerator, ImageDataManager) | `tests/auto/` | — |

### 🟢 НИЗКИЕ

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 17 | Опечатка "Unknow" → "Unknown" | `app/qml/MDelegate.qml` | 167 |
| 18 | Избыточные комментарии в заголовке | `plugins/androidutils/androidutils.h` | 31-43 |
| 19 | Неиспользуемые QML-компоненты (MemoCard, SimpleFlip) | `plugins/ui/` | — |

## Сводка по критериям SKILS_REV.md

### C++ & QML Интеграция
- ✅ Регистрация типов: `QML_ELEMENT` + `QML_SINGLETON` — корректно
- ✅ `Q_PROPERTY` с NOTIFY сигналами — все присутствуют
- ❌ **Проблема:** отсутствует `qRegisterMetaType<ProxyResult>()` для跨-поточных сигналов
- ❌ **Проблема:** дублирование connect к `QNetworkInformation` — утечка соединений

### Специфика Android/Linux Qt6
- ✅ AndroidManifest.xml через шаблоны Qt — корректно
- ✅ Использование `QNativeInterface::QAndroidApplication` — корректно
- ❌ **Проблема:** нет runtime-запроса разрешений (BLUETOOTH_SCAN на API 31+)
- ❌ **Проблема:** hardcoded размер экрана 360×720
- ✅ SafeArea.margins используется — корректно

### DRY и Чистота
- ❌ **Проблема:** дублирование reachability→message switch в двух C++ классах
- ❌ **Проблема:** дублирование 50+ строк между Main.qml и MainTest.qml
- ❌ **Проблема:** copy-paste логов в NavigationPane
- ⚠️ Комментарии на русском — приемлемо для команды
- ❌ Мёртвый код: `sendertypes.h`, `plugins/ui/`, тесты из другого проекта

## Рекомендации по приоритету

1. **Немедленно:** Исправить `QT_DEBUG1` → `QT_DEBUG` в `main.cpp`
2. **Немедленно:** Вынести `connect(QNetworkInformation...)` из `checkInternetConnectivity()` в конструктор `Core`
3. **Немедленно:** Определить недостающие идентификаторы в `MListView.qml`
4. **До релиза:** Реализовать `checkSingleProxy()` (основная функция приложения)
5. **До релиза:** Добавить `qRegisterMetaType<ProxyResult>()` перед использованием
6. **До релиза:** Вынести общий код стилей из Main.qml/MainTest.qml
7. **До релиза:** Удалить/заменить тесты из MemoPvP

# Аудит кода MTProxyInspector — Сводка

## Общая оценка

Проект находится в ранней стадии разработки. Архитектурный каркас (C++ синглтоны, QML UI, Android-интеграция) заложен корректно, но ключевая бизнес-логика (проверка MTProxy, сохранение результатов) не реализована. Присутствуют критические ошибки времени выполнения (undefined identifiers в QML, dead code), множественные нарушения DRY, а также мёртвый код (4 из 5 QML-компонентов не используются).

**Существующая документация в `docs/` устарела:** ссылается на удалённые файлы (`core.cpp`, `plugins/ui/`, `MainTest.qml`, `sendertypes.h`). Ниже — актуальный аудит.

## Сводка проблем по критичности

### 🔴 КРИТИЧЕСКИЕ (crash / неработоспособность)

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 1 | Несуществующие идентификаторы в MListView (darkMode, solarizedBase03...) | `app/qml/MListView.qml` | 8-12 |

### 🟠 ВЫСОКИЕ (логические ошибки, нарушение DRY)

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 2 | Dead code — MainTest.qml (опечатка QT_DEBUG1) | `app/main.cpp` | 129 |
| 3 | NavigationPane — все onClicked пишут "Россия" | `app/qml/NavigationPane.qml` | 44, 65, 85, 105, 125 |
| 4 | NavigationPane ссылается на appWnd вне области видимости | `app/qml/NavigationPane.qml` | 16 |
| 5 | Cross-thread сигнал без qRegisterMetaType | `plugins/core/networkmanager.cpp` | 162-177 |
| 6 | Незакрытый QFutureWatcher при повторном вызове | `plugins/core/networkmanager.cpp` | 158-177 |

### 🟡 СРЕДНИЕ

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 7 | Stub-методы: проверка прокси, сохранение не реализованы | `appcontroller.cpp`, `networkmanager.cpp`, `storagemanager.cpp` | — |
| 8 | normalizeProxyKey — мёртвая ветка copy-paste | `plugins/core/networkmanager.cpp` | 223-224 |
| 9 | Debug-режим перезаписывает sourceProxyLists | `plugins/core/appcontroller.cpp` | 64-65 |
| 10 | saveSettings() / saveFile() — пустые, настройки не сохраняются | `plugins/core/storagemanager.cpp` | 53-56, 87-90 |
| 11 | initialize() вызывает refreshServerLists() преждевременно | `plugins/core/appcontroller.cpp` | 53-54 |
| 12 | Нет runtime-запроса разрешений (BLUETOOTH_SCAN, ACCESS_COARSE_LOCATION) | `plugins/androidutils/` | — |
| 13 | AndroidUtils.create() — thread-safety (QAtomicPointer без блокировки) | `plugins/androidutils/androidutils.cpp` | 8-22 |
| 14 | RoundButton (cloud-refresh) без onClicked | `app/qml/Main.qml` | 242-253 |
| 15 | MButton — dual animation (states + Behavior conflict) | `app/qml/MButton.qml` | 41-71 |
| 16 | Hardcoded 360×720 — нет адаптивности | `app/qml/Main.qml` | 90-91 |
| 17 | Missing `#include <QTime>` | `appcontroller.cpp`, `androidutils.cpp` | — |
| 18 | Missing `#include <QDir>` | `plugins/core/storagemanager.cpp` | 33 |

### 🟢 НИЗКИЕ

| # | Проблема | Файл | Строка |
|---|----------|------|--------|
| 19 | Неиспользуемые QML-компоненты (MButton, MCard, MListView, NavigationPane) | `app/qml/` | — |
| 20 | assets/settings.json не используется (мёртвый файл) | `assets/settings.json` | — |
| 21 | MButton — опечатка antimationTime → animationTime | `app/qml/MButton.qml` | 9 |
| 22 | Redundant enum OR: Text.AlignVCenter | Qt.AlignVCenter | `app/qml/Main.qml` | 288 |
| 23 | handleCommonResult смешивает toast и debug-инфо | `plugins/core/appcontroller.cpp` | 114-117 |
| 24 | Закомментированный код (onProxyUrlListChanged, Core.proxyUrlList) | `app/qml/Main.qml` | 346-349 |
| 25 | Избыточные комментарии в androidutils.h | `plugins/androidutils/androidutils.h` | 7-11 |

## Сводка по критериям SKILS_REV.md

### C++ & QML Интеграция
- ✅ Регистрация типов: `QML_ELEMENT` + `QML_SINGLETON` — корректно
- ✅ `Q_PROPERTY` с NOTIFY сигналами — все присутствуют
- ✅ `reachabilityChanged` connect один раз в конструкторе (исправлено)
- ❌ Отсутствует `qRegisterMetaType<ProxyResult>()` для跨-поточных сигналов
- ❌ Незакрытый QFutureWatcher при повторе
- ❌ copy-paste в normalizeProxyKey (мёртвая ветка)

### Специфика Android/Linux Qt6
- ✅ AndroidManifest.xml через шаблоны Qt — корректно
- ✅ Использование `QNativeInterface::QAndroidApplication` — корректно
- ❌ Нет runtime-запроса разрешений (BLUETOOTH_SCAN на API 31+)
- ❌ Hardcoded размер экрана 360×720
- ✅ SafeArea.margins используется — корректно
- ❌ AndroidUtils.create() — thread-safety (QAtomicPointer без блокировки)

### DRY и Чистота
- ❌ MListView — undefined identifiers (должны быть свойства)
- ❌ NavigationPane — copy-paste логов + out-of-scope ссылка
- ❌ Мёртвый код: 4 неиспользуемых QML-компонента, assets/settings.json
- ❌ Dual animation в MButton (states vs Behavior)
- ✅ Комментарии на русском — приемлемо для команды
- ⚠️ Образовательные комментарии в androidutils.h — избыточны

## Рекомендации по приоритету

1. **Немедленно:** Исправить `QT_DEBUG1` → удалить блок в `main.cpp` (или исправить логику)
2. **Немедленно:** Определить недостающие идентификаторы в `MListView.qml` или удалить файл
3. **Немедленно:** Исправить copy-paste логов в `NavigationPane.qml` + ссылку на `appWnd`
4. **До релиза:** Реализовать `checkSingleProxy()` (основная функция приложения)
5. **До релиза:** Реализовать `saveSettings()` (сохранение настроек пользователя)
6. **До релиза:** Добавить `qRegisterMetaType<ProxyResult>()`
7. **До релиза:** Добавить runtime-запрос Android-разрешений
8. **До релиза:** Исправить `normalizeProxyKey` (мёртвая ветка)
9. **До релиза:** Добавить onClicked на RoundButton (cloud-refresh)
10. **До релиза:** Удалить неиспользуемые QML-компоненты и assets/settings.json

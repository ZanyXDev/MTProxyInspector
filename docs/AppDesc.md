# Архитектура

    Использовать `QAbstractListModel` вместо `QAbstractItemModel` — `ListView` работает только с ним.
    
## 1.Разделить ответственность на отдельные классы-менеджеры (SRP):
    - StorageManager — файловая система
    - NetworkManager — загрузка URL-листов
    - ServerParser — парсинг
    - ServerCheckerPool — пул проверок
    - PermissionsManager — Android-разрешения
## 2.Единый AppController как facade для QML.
## 3.Все тяжёлые операции — в воркерах (QThread + QObject::moveToThread или QThreadPool + QRunnable).
## 4. Обновление модели — только через сигналы в main thread (Qt автоматически маршалит cross-thread сигналы через QueuedConnection).

# Android-специфичные особенности
    - Использовать `QStandardPaths::AppDataLocation` (внутреннее хранилище приложения) — ** разрешения НЕ нужны вообще
Если всё-таки нужен внешний storage — запрашивать MANAGE_EXTERNAL_STORAGE (Android 11+) или WRITE_EXTERNAL_STORAGE (Android ≤10) через QtAndroidPrivate::requestPermission.
ICMP ping заменить на TCP connect с таймаутом — работает без root.
В AndroidManifest.xml:
xml
12
🎯 Логические
Добавить статусы сервера (enum):
cpp
1
Кэшировать результаты в servers_cache.json — при следующем запуске показывать сразу.
Валидировать URL перед добавлением в модель (QUrl::isValid + схема http/https/tcp).
Дедупликация серверов (по url+port).
Ограничить concurrency пула проверок (8-16 потоков, иначе Android убьет за сеть).
Таймаут на проверку — 3-5 секунд, не больше.
Debounce на pull-to-refresh — не чаще раза в 10 секунд.
Прогресс проверки — сигнал progressChanged(current, total).
Отмена проверки — флаг cancellationRequested.
Сортировка по пингу (онлайн сначала, потом по пингу).
🎨 UX
Индикатор загрузки при скачивании URL-листов.
Прогресс-бар при проверке серверов.
Pull-to-refresh с визуальным фидбеком.
Skeleton-карточки во время загрузки.
Toast/Snackbar при ошибках (нет сети, нет доступа).
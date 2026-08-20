# Архитектура

> Интерактивная диаграмма архитектуры и панель потоков: [`architecture.html`](./architecture.html)
> (SVG, без внешних зависимостей, Solarized-тема). Машиночитаемая модель для ИИ-агентов:
> [`architecture.json`](./architecture.json) — `{nodes, edges, flows:[{steps}]}`.

```mermaid
graph TB
    subgraph "QML Frontend"
        Main["Main.qml"]
        MDelegate["MDelegate<br/>(delegate)"]
        MButton["MButton<br/>(не используется)"]
        MCard["MCard<br/>(не используется)"]
        MListView["MListView<br/>(сломан)"]
        NavPane["NavigationPane<br/>(сломан)"]

        Main --- MDelegate
    end

    subgraph "C++ Backend"
        AC["AppController<br/>(Facade, QML_SINGLETON)<br/>Координирует всё"]

        subgraph "Managers"
            Storage["StorageManager"]
            Network["NetworkManager<br/>QNetworkAccessManager<br/>QtConcurrent"]
        end

        subgraph "Models"
            ProxyModel["ProxyListModel<br/>(GenericListModel)"]
            SourceModel["SourceLinkModel<br/>(GenericListModel)"]
        end

        subgraph "Data structs"
            ProxyResult["ProxyResult<br/>(ping, port, server, secret)"]
            ProxyLink["ProxySourceLink<br/>(url_title, url_server)"]
        end
    end

    subgraph "Android"
        AndroidUtils["AndroidUtils<br/>(QML_SINGLETON)<br/>Toast via JNI"]
    end

    Main -->|Q_PROPERTY / Q_INVOKABLE| AC
    Main -->|Connections| AC
    Main --> AndroidUtils

    AC --> Storage
    AC --> Network
    AC --> ProxyModel
    AC --> SourceModel

    Storage -->|accessChecked| AC
    Storage -->|appSettings| AC
    Network -->|connectivityChecked| AC
    Network -->|proxyChecked| AC
    Network -->|proxyListChanged| AC

    ProxyResult ..-> ProxyModel
    ProxyLink ..-> SourceModel

    classDef qml fill:#e1f5fe,stroke:#01579b
    classDef cpp fill:#f3e5f5,stroke:#4a148c
    classDef data fill:#fff3e0,stroke:#e65100
    classDef broken fill:#ffcdd2,stroke:#c62828

    class Main,MDelegate qml
    class AC,Storage,Network,ProxyModel,SourceModel cpp
    class ProxyResult,ProxyLink data
    class MButton,MCard,MListView,NavPane broken
```

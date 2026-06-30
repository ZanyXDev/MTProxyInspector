```mermaid
graph TB
    subgraph "QML Frontend"
        Main["Main.qml"]
        Card["ServerCard<br/>(delegate)"]
        Pull["PullToRefreshHandler"]
        
        Main --- Card
        Main --- Pull
        Card -.->|signals/slots| Pull
    end
    
    subgraph "C++ Backend"
        Controller["AppController<br/>(Facade)<br/>Координирует всё<br/>владеет временем жизни"]
        
        subgraph "Managers"
            Perms["PermsMgr"]
            Storage["StorageMgr"]
            Network["NetworkMgr"]
            Parser["Parser"]
            CheckerPool["Checker Pool"]
        end
        
        subgraph "Cache & Processing"
            Files["Files<br/>(cache)"]
            ServerChecker["ServerChecker<br/>(в QThreadPool)<br/>TCP connect"]
            ServerModel["ServerModel<br/>(ListModel)"]
        end
    end
    
    QML["QML view"] -->|roleNames| ServerModel
    
    Main -->|Q_PROPERTY / Q_INVOKABLE| Controller
    
    Controller --> Perms
    Controller --> Storage
    Controller --> Network
    Controller --> Parser
    Controller --> CheckerPool
    
    Storage --> Files
    Network --> Files
    Parser --> Files
    
    CheckerPool --> ServerChecker
    ServerChecker -.->|signal (queued)| ServerModel
    
    classDef qml fill:#e1f5fe,stroke:#01579b
    classDef cpp fill:#f3e5f5,stroke:#4a148c
    classDef data fill:#fff3e0,stroke:#e65100
    
    class Main,Card,Pull qml
    class Controller,Perms,Storage,Network,Parser,CheckerPool,ServerChecker,ServerModel cpp
    class Files data
```
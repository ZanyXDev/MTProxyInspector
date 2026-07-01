#pragma once
#include <QObject>
#include <QtQml>
// appcontroller.h

class StorageManager;
class NetworkManager;
// class ServerModel;
// class ServerParser;
// class ServerCheckerPool;
// class PermissionsManager;

class AppController : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    //Q_PROPERTY(ServerModel* servers READ servers CONSTANT)
    Q_PROPERTY(bool isReady READ isReady NOTIFY isReadyChanged)
    Q_PROPERTY(bool storageAvailable READ storageAvailable NOTIFY storageAvailableChanged)
    Q_PROPERTY(bool internetAvailable READ internetAvailable NOTIFY internetAvailableChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(int checkProgress READ checkProgress NOTIFY checkProgressChanged)
    Q_PROPERTY(int checkTotal READ checkTotal NOTIFY checkTotalChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)

public:
    explicit AppController(QObject *parent = nullptr);
    ~AppController() override = default; // Явное определение по умолчанию

    Q_INVOKABLE void initialize();          // старт приложения
    Q_INVOKABLE void refreshServerLists();  // скачать URL-листы
    Q_INVOKABLE void checkAllServers();     // проверить доступность
    Q_INVOKABLE void cancelCheck();         // отменить проверку
    Q_INVOKABLE void clearCache();

    //ServerModel *servers() const;

    bool isReady() const;
    bool storageAvailable() const;
    bool internetAvailable() const;
    bool isLoading() const;
    int checkProgress() const;
    int checkTotal() const;
    QString statusMessage() const;

signals:
    void isReadyChanged();
    void storageAvailableChanged();
    void internetAvailableChanged();
    void isLoadingChanged();
    void checkProgressChanged();
    void checkTotalChanged();
    void statusMessageChanged();
    void errorOccurred(const QString &message);
    void showToastMessage(const QString &message);

private:
    void onListsDownloaded();
    void onParsed();    
    void handleCommonResult(bool ok, const QString &message);

    StorageManager        *m_storage = nullptr;
    NetworkManager        *m_network = nullptr;

    // ServerModel           *m_servers = nullptr;
    // ServerParser       *m_parser;
    // ServerCheckerPool  *m_checkerPool;
    // PermissionsManager *m_permissions;

    bool m_isReady = false;
    bool m_storageAvailable  = false;
    bool m_internetAvailable  = false;
    bool m_isLoading = false;
    int m_checkProgress = -1;
    int m_checkTotal = -1;
    QString m_statusMessage = QString();
};
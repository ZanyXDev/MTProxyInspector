#pragma once
#include <QObject>
#include <QtQml>
#include "proxyresult.h"
#include "proxylistmodel.h"
#include "sourcelinkmodel.h"

// appcontroller.h

class StorageManager;
class NetworkManager;

class AppController : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(ProxyListModel* servers READ servers CONSTANT)
    Q_PROPERTY(SourceLinkModel* proxySourceLinksModel READ servers CONSTANT)
    Q_PROPERTY(bool storageAvailable READ storageAvailable NOTIFY storageAvailableChanged)
    Q_PROPERTY(bool internetAvailable READ internetAvailable NOTIFY internetAvailableChanged)
    Q_PROPERTY(int checkProgress READ checkProgress NOTIFY checkProgressChanged)
    Q_PROPERTY(int checkTotal READ checkTotal NOTIFY checkTotalChanged)
    Q_PROPERTY(QString sourceProxyLists READ sourceProxyLists WRITE setSourceProxyLists NOTIFY sourceProxyListsChanged FINAL)
public:
    explicit AppController(QObject *parent = nullptr);
    ~AppController() override = default; // Явное определение по умолчанию

    Q_INVOKABLE void initialize();          // старт приложения
    Q_INVOKABLE void refreshServerLists();  // скачать URL-листы
    Q_INVOKABLE void checkAllServers();     // проверить доступность
    Q_INVOKABLE void cancelCheck();         // отменить проверку

    ProxyListModel *servers() const;
    bool storageAvailable() const;
    bool internetAvailable() const;
    int checkProgress() const;
    int checkTotal() const;

    QString sourceProxyLists() const;
    void setSourceProxyLists(const QString &newSourceProxyLists);

signals:
    void storageAvailableChanged();
    void internetAvailableChanged();
    void checkProgressChanged();
    void checkTotalChanged();

    void errorOccurred(const QString &message);
    void showToastMessage(const QString &message);

    void sourceProxyListsChanged();
    void proxyListChanged(const int serversCount);

private slots:
    void onProxyChecked(const ProxyResult &result);
private:
    void onListsDownloaded();
    void onParsed();    
    void handleCommonResult(bool ok, const QString &message);

    StorageManager        *m_storage = nullptr;
    NetworkManager        *m_network = nullptr;
    ProxyListModel        *m_proxyListModel = nullptr;
    // ServerParser       *m_parser;
    // ServerCheckerPool  *m_checkerPool;
    // PermissionsManager *m_permissions;

    bool m_storageAvailable  = false;
    bool m_internetAvailable  = false;
    int m_checkProgress = -1;
    int m_checkTotal = -1;
    QString m_sourceProxyLists;
    SourceLinkModel *m_proxySourceLinksModel = nullptr;
};
#include <QDebug>
#include <QVariantMap>
#include <QVariantList>
#include "appcontroller.h"
#include "storagemanager.h"
#include "networkmanager.h"


AppController::AppController(QObject *parent)
    : QObject(parent)
{
#ifdef QT_DEBUG
    qDebug() << "[INIT_ORDER] >>> AppController created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;
#endif
    m_proxyListModel = new ProxyListModel(this);
    m_sourceLinksModel = new SourceLinkModel(this);

    m_storage = new StorageManager(this);
    // Логика для хранилища
    connect(m_storage, &StorageManager::accessChecked, this, [this](bool ok, const QString &msg) {
        this->handleCommonResult(ok, msg);
        if (m_storageAvailable != ok) {
            m_storageAvailable = ok;
            m_storage->loadSettings();
            emit storageAvailableChanged();
        }
    });

    connect(m_storage, &StorageManager::appSettingsChanged, this, [this](const QVariantMap &appSettings) {
        qDebug() << "Received: appSettingsChanged:" <<appSettings;
    });

    connect(m_storage, &StorageManager::proxyLinksChanged, m_sourceLinksModel, &SourceLinkModel::setFromList );

    m_network = new NetworkManager(this);
    // Логика для сети
    connect(m_network, &NetworkManager::connectivityChecked, this, [this](bool ok, const QString &msg) {
        this->handleCommonResult(ok, msg);
        if (m_internetAvailable != ok) {
            m_internetAvailable = ok;
            emit internetAvailableChanged();
        }
    });
    connect(m_network, &NetworkManager::proxyChecked,
            this, &AppController::onProxyChecked);
    connect(m_network, &NetworkManager::proxyListChanged,
            this, &AppController::proxyListChanged);    
}

void AppController::initialize()
{
    m_storage->checkAccess();
    m_network->checkConnectivity();
    ///TODO Перенсти в блок обработки сигнала что настройки загружены
    this->refreshServerLists();
}

void AppController::refreshServerLists()
{
    if (!(m_storageAvailable && m_internetAvailable)) return;

    // if (m_sourceProxyLists.isEmpty()) {
    //     return;
    // }else{
    //     m_network->refreshProxyLists( m_sourceProxyLists );
    // }

}

void AppController::checkAllServers()
{

}

void AppController::cancelCheck()
{

}

void AppController::saveSetting()
{
    m_storage->saveSettings();
}

ProxyListModel *AppController::servers() const
{
    return m_proxyListModel;
}

bool AppController::storageAvailable() const
{
    return m_storageAvailable;
}

bool AppController::internetAvailable() const
{
    return m_internetAvailable;
}

int AppController::checkProgress() const
{
    return m_checkProgress;
}

int AppController::checkTotal() const
{
    return m_checkTotal;
}

void AppController::handleCommonResult(bool ok, const QString &message) {
    if (ok) emit showToastMessage(message);
    else emit errorOccurred(message);
}

void AppController::onProxyChecked(const ProxyResult &result)
{

}

SourceLinkModel *AppController::sourceLinksModel() const
{
    return m_sourceLinksModel;
}

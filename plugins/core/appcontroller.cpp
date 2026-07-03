#include <QDebug>
#include "appcontroller.h"
#include "storagemanager.h"
#include "networkmanager.h"
#include "proxylistmodel.h"

AppController::AppController(QObject *parent)
    : QObject(parent)
{
#ifdef QT_DEBUG
    qDebug() << "[INIT_ORDER] >>> AppController created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;
#endif
    m_storage = new StorageManager(this);
    // Логика для хранилища
    connect(m_storage, &StorageManager::accessChecked, this, [this](bool ok, const QString &msg) {
        this->handleCommonResult(ok, msg);
        if (m_storageAvailable != ok) {
            m_storageAvailable = ok;
            emit storageAvailableChanged();
        }
    });

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

    m_proxyListModel = new ProxyListModel(this);
}

void AppController::initialize()
{
    m_storage->checkAccess();
    m_network->checkConnectivity();
#ifdef QT_DEBUG
    m_sourceProxyLists= "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/refs/heads/main/proxy_ru.txt";
    this->refreshServerLists();
#endif
}

void AppController::refreshServerLists()
{
    if (!(m_storageAvailable && m_internetAvailable)) return;
    if (m_sourceProxyLists.isEmpty()) {
        return;
    }else{
        m_network->refreshProxyLists( m_sourceProxyLists );
    }

}

void AppController::checkAllServers()
{

}

void AppController::cancelCheck()
{

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

QString AppController::sourceProxyLists() const
{
    return m_sourceProxyLists;
}

void AppController::setSourceProxyLists(const QString &newSourceProxyLists)
{
    if (m_sourceProxyLists == newSourceProxyLists)
        return;
    m_sourceProxyLists = newSourceProxyLists;
    emit sourceProxyListsChanged();
}

void AppController::onProxyChecked(const ProxyResult &result)
{

}

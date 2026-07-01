#include <QDebug>
#include "appcontroller.h"
#include "storagemanager.h"

AppController::AppController(QObject *parent)
    : QObject(parent)
{
#ifdef QT_DEBUG
    qDebug() << "[INIT_ORDER] >>> AppController created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;
#endif
    m_storage = new StorageManager(this);
    connect(m_storage, &StorageManager::accessChecked, &AppController::onCheckResult);

    m_network = new NetworkManager(this);
    connect(m_network, &NetworkManager::connectivityChecked, &AppController::onCheckResult);
}

void AppController::initialize()
{
    m_storage->checkAccess();
    m_network->checkConnectivity();
}

void AppController::refreshServerLists()
{

}

void AppController::checkAllServers()
{

}

void AppController::cancelCheck()
{

}

void AppController::clearCache()
{

}


// ServerModel *AppController::servers() const
// {
//     return m_servers;
// }

bool AppController::isReady() const
{
    return m_isReady;
}

bool AppController::storageAvailable() const
{
    return m_storageAvailable;
}

bool AppController::internetAvailable() const
{
    return m_internetAvailable;
}

bool AppController::isLoading() const
{
    return m_isLoading;
}

int AppController::checkProgress() const
{
    return m_checkProgress;
}

int AppController::checkTotal() const
{
    return m_checkTotal;
}

QString AppController::statusMessage() const
{
    return m_statusMessage;
}

void AppController::onCheckResult( bool ok, const QString &message,SenderTypes senderType)
{
#ifdef QT_DEBUG
    qDebug() << "[AppController]:Recive [ok: "<<ok<< " message:" << message << " ] from: senderType:"<<senderType;
#endif
    if (ok) {
        emit showToastMessage( message );
    } else {
        emit errorOccurred( message );
    };
    switch (senderType) {
    case SenderTypes::StorageManager:
        if (m_storageAvailable != ok){
            m_storageAvailable = ok;
            emit storageAvailableChanged();
        }
        break;
    case SenderTypes::NetworkManager:
        if (m_internetAvailable != ok){
            m_internetAvailable = ok;
            emit internetAvailableChanged();
        }
        break;
    default:
        break;
    }

}

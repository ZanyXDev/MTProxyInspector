#include <QDebug>
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

void AppController::handleCommonResult(bool ok, const QString &message) {
    if (ok) emit showToastMessage(message);
    else emit errorOccurred(message);
}

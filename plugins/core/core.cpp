#include <QDebug>
#include <QString>
#include <QUrl>
#include <QUrlQuery>
#include <QStandardPaths>
#include <QDir>
#include <QFileInfo>
#include <QNetworkInformation>

#include "core.h"


Core::Core(QObject *parent)
    : QObject(parent)
    , m_externalStorageWritable(false)
{
    qDebug() << "[INIT_ORDER] >>> CorePlugin created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;

    checkExternalStorageWritable();
    checkInternetConnectivity();

}

void Core::checkExternalStorageWritable()
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QFileInfo fi(path);

    bool newExternalStorageWritable = false;

    if (fi.exists() && fi.isDir()) {
        if (fi.isWritable()) {
            qDebug() << "[STORAGE] AppDataLocation is writable:" << path;
            newExternalStorageWritable = true;
        } else {
            qWarning() << "[STORAGE] AppDataLocation is NOT writable:" << path;            
        }
    } else {
        QDir dir(path);
        if (dir.mkpath(".")) {
            qDebug() << "[STORAGE] AppDataLocation created and writable:" << path;
            newExternalStorageWritable = true;
        } else {
            qWarning() << "[STORAGE] Cannot create AppDataLocation:" << path;            
        }
    }

    if (m_externalStorageWritable == newExternalStorageWritable)
        return;
    m_externalStorageWritable = newExternalStorageWritable;
    emit externalStorageWritableChanged();
}

void Core::checkInternetConnectivity()
{
    if (QNetworkInformation::instance()) {
        auto reachability = QNetworkInformation::instance()->reachability();
        bool newInternetConnectivity = (reachability == QNetworkInformation::Reachability::Online);
        QString msg;
        if (newInternetConnectivity) {
            qDebug() << "[NETWORK] Device is online";
            msg = tr("Устройство онлайн!");
        } else {            
            switch (reachability) {
            case QNetworkInformation::Reachability::Disconnected:
                msg = tr("Устройство офлайн!");
                break;
            case QNetworkInformation::Reachability::Local:
                msg = tr("Устройство подключено к локальной сети, без доступа в Интернет!");
                break;
            case QNetworkInformation::Reachability::Site:
                msg = tr("Устройство подключено к интранет сети, без доступа в Интернет!");
                break;
            default:
                msg = tr("Сетевое подключение недоступно!");
                break;
            }
            qWarning() << "[NETWORK]" << msg;
        }
        if (m_internetConnectivity != newInternetConnectivity){
            m_internetConnectivity = newInternetConnectivity;
            emit showToastMessage(msg);
        }
        connect(QNetworkInformation::instance(), &QNetworkInformation::reachabilityChanged,
                this, [this](QNetworkInformation::Reachability newReachability) {
                    bool newInternetConnectivity = (newReachability == QNetworkInformation::Reachability::Online);
                    QString msg;
                    switch (newReachability) {
                    case QNetworkInformation::Reachability::Online:
                        msg = tr("Устройство онлайн!");
                        break;
                    case QNetworkInformation::Reachability::Disconnected:
                        msg = tr("Устройство офлайн!");
                        break;
                    case QNetworkInformation::Reachability::Local:
                        msg = tr("Устройство подключено к локальной сети, без доступа в Интернет!");
                        break;
                    case QNetworkInformation::Reachability::Site:
                        msg = tr("Устройство подключено к интранет сети, без доступа в Интернет!");
                        break;
                    }
                    qDebug() << "[NETWORK] Reachability changed:" << msg;

                    if (m_internetConnectivity == newInternetConnectivity)
                        return;
                    m_internetConnectivity = newInternetConnectivity;
                    emit showToastMessage(msg);

                });



    } else {
        qDebug() << "[NETWORK] QNetworkInformation not available on this platform";
    }
}

bool Core::externalStorageWritable() const
{
    return m_externalStorageWritable;
}

bool Core::internetConnectivity() const
{
    return m_internetConnectivity;
}

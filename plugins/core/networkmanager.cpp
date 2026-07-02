#include <QNetworkInformation>
#include <QUrl>
#include <QUrlQuery>
#include "networkmanager.h"

NetworkManager::NetworkManager(QObject *parent)
    : QObject(parent)
{
    if (QNetworkInformation::instance()) {

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
                    emit connectivityChecked(newInternetConnectivity, msg);
                });
    } else {
        qDebug() << "[NETWORK] QNetworkInformation not available on this platform";
    }
}

void NetworkManager::checkConnectivity()
{
    QString  msg = tr("Сетевое подключение недоступно!");
    bool newInternetConnectivity = false;
    if (QNetworkInformation::instance()) {
        auto reachability = QNetworkInformation::instance()->reachability();
        newInternetConnectivity = (reachability == QNetworkInformation::Reachability::Online);

        if (newInternetConnectivity) {
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
    }
    emit connectivityChecked(newInternetConnectivity, msg);
}

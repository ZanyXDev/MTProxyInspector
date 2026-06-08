#include <QDebug>

#include "core.h"
#include "itester.h"

Core::Core(QObject *parent)
    : QObject(parent)
    , m_boardModel (new QStandardItemModel( this) )
    , m_networkManager(new QNetworkAccessManager(this))
    , m_itester (new ITester (this) )
{
    qDebug() << "[INIT_ORDER] >>> CorePlugin created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;
    QHash<int, QByteArray> roleNames = m_boardModel->roleNames();
    roleNames[Qt::UserRole + 1] = "pictureId";
    roleNames[Qt::UserRole + 2] = "cardVisible";
    m_boardModel->setItemRoleNames(roleNames);
#ifdef QT_DEBUG
    m_boardModel->setColumnCount(1);
    const int N = 16;
    m_boardModel->setRowCount(N);
    for (int r = 0; r < N; ++r)
    {
        QStandardItem* item = new QStandardItem();

        item->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
        item->setData( r ,Qt::UserRole +1);
        item->setData( true, Qt::UserRole +2);

        m_boardModel->setItem(r, 0, item);
    }
#endif
    if (QNetworkInformation::instance()) {
        // Check if the device has internet reachability
        bool isOnline = QNetworkInformation::instance()->reachability() >= QNetworkInformation::Reachability::Online;

        // Get transport medium (e.g., Cellular, WiFi, Ethernet)
        QNetworkInformation::TransportMedium medium = QNetworkInformation::instance()->transportMedium();
        qDebug() << "Is Online:" << isOnline << "Medium:" << static_cast<int>(medium);

        connect(QNetworkInformation::instance(), &QNetworkInformation::reachabilityChanged,
                this, [this](QNetworkInformation::Reachability reachability) {
                    bool l_success = false;
                    QString l_message = QString();
                    QString l_errorType = QString();

                    switch (reachability) {
                    case QNetworkInformation::Reachability::Online:
                        l_message = tr("Device is online!");
                        l_success = true;
                        break;
                    case QNetworkInformation::Reachability::Disconnected:
                        l_message = tr("Device is disconnected!");
                        break;
                    case QNetworkInformation::Reachability::Local:;
                        l_message = tr("Local");
                        break;
                    case QNetworkInformation::Reachability::Site:;
                        l_message = tr("Site");
                        break;
                    default:
                        qDebug() << "Reachability changed to partial state.";
                        break;
                    }
                    emit currentStatusChanged(l_success, l_message );
                });
    }
}


QStandardItemModel *Core::boardModel() const
{
    return m_boardModel;
}

void Core::setProxyUrlList(const QString &newProxyUrlList)
{
    if (m_proxyUrlList == newProxyUrlList)
        return;
    m_proxyUrlList = newProxyUrlList;
    emit proxyUrlListChanged();
    fetchProxyList( m_proxyUrlList );
}

QString Core::proxyUrlList() const
{
    return m_proxyUrlList;
}

void Core::onReplyFinished(QNetworkReply *reply)
{

}

void Core::fetchProxyList(const QString &url)
{

}

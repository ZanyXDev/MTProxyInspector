#include <QDebug>
#include <QString>
#include <QUrl>
#include <QUrlQuery>

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
        connect(QNetworkInformation::instance(), &QNetworkInformation::reachabilityChanged,
                this, [this](QNetworkInformation::Reachability reachability) {
                   bool state = false;
                    QString l_message = QString();                   

                    switch (reachability) {
                    case QNetworkInformation::Reachability::Online:
                        l_message = tr("Устройство онлайн!");
                        state = true;
                        break;
                    case QNetworkInformation::Reachability::Disconnected:
                        l_message = tr("Устройство офлайн!");
                        break;
                    case QNetworkInformation::Reachability::Local:;
                        l_message = tr("Устройство подключено к локальной сети, без доступа в Интернет!");
                        break;
                    case QNetworkInformation::Reachability::Site:;
                        l_message =  tr("Устройство подключено к интранет сети, без доступа в Интернет!");
                        break;
                    default:
                        qDebug() << "Reachability changed to partial state.";
                        break;
                    }

                    if (state != m_onlineState){
                        m_onlineState = state;
                        emit onlineStateChanged();
                    }

                    emit showToastMessage(l_message );    
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

QString Core::convertToTlgFormat(const QString &urlString) const
{
    QUrl url(urlString);

    if (url.scheme() == "https" && url.host() == "t.me") {
        QString path = url.path();
        QUrlQuery query(url);

        if (path == "/proxy") {
            QString tgUrl = "tg://proxy?" + query.toString();
            return tgUrl;
        }
        else if (path == "/socks") {
            QString tgUrl = "tg://socks?" + query.toString();
            return tgUrl;
        }
    }

    return urlString;
}



void Core::fetchProxyList(const QString &url)
{

}

bool Core::onlineState() const
{
    return m_onlineState;
}

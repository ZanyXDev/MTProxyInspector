#pragma once
#include <QObject>
#include <QtQml>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include "proxyresult.h"

// networkmanager.h
class NetworkManager : public QObject {
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);
    void checkConnectivity();
    void refreshProxyLists(const QString &urlSourceList);

signals:
    void connectivityChecked(bool ok, const QString &message);
    void parseProxyListStatus(bool ok, const QString &message);
    // Сигнал отправляется, когда один прокси проверен
    void proxyChecked(const ProxyResult &result);
    void batchProxyChecked(const QList<ProxyResult> &results);
    void proxyListChanged(const int serversCount);
    void loadingStatusChanged(bool ok, const QString &message, const QString &errorType = QString());

private slots:
    void onReplyFinished();
private:
    QNetworkAccessManager *m_networkAccessManager = nullptr;
    QNetworkReply *m_currentReply = nullptr;

    bool m_internetConnectivity;
    bool m_proxyListLoaded;
    bool m_loadingStatus;
    QStringList m_currentProxyList;

    // Структура для возврата двух значений
    struct Status {
        bool isOnline;
        QString message;
    };
    ProxyResult checkSingleProxy(const QString &proxyUrl) const;
    void refreshProxyLists(const QStringList &sources);
    Status parseReachability(QNetworkInformation::Reachability reachability) const;
};
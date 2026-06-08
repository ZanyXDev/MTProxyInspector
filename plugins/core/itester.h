#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QTcpSocket>

class ITester : public QObject {
    Q_OBJECT
public:
    explicit ITester(QObject *parent = nullptr);

    void checkNetworkAvailability();

    bool isNetworkAvailable() const;
    bool isResourceAvailable() const;
private:
    // проверка через QNetworkInterface
    bool checkNetworkInterfaceAvailability();

    //  пинг через TCP socket
    /// TODO host, port, timeout должны быть настраивамыми
    bool checkSocketConnection(const QString &host = "8.8.8.8",
                               int port = 53, int timeoutMs = 1500);

    bool m_isNetworkAvailable = false;
    bool m_hasActiveInternet = false;
    QNetworkAccessManager *m_networkManager;
    QTcpSocket *m_tcpSocket = nullptr;
    QDateTime m_lastCheck;
};
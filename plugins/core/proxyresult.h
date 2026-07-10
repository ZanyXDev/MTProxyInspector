#pragma once
#include <QMetaType>
#include <QString>

struct ProxyResult {
    Q_GADGET
    Q_PROPERTY(int ping MEMBER ping)
    Q_PROPERTY(int port MEMBER port)
    Q_PROPERTY(QString server MEMBER server)
    Q_PROPERTY(QString secret MEMBER secret)

public:
    int     ping = 0;
    int     port = 0;
    QString server;
    QString secret;
};

Q_DECLARE_METATYPE(ProxyResult)

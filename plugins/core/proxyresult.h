#pragma once
#include <QMetaType>

struct ProxyResult {
    int     ping = 0;
    int     port = 0;
    QString server;
    QString secret;
};

Q_DECLARE_METATYPE(ProxyResult)

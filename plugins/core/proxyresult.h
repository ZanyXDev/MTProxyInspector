#pragma once
#include <QMetaType>
struct ProxyResult {
    QString url;
    int latency;
    int port;
    QString typeProxy;
    QString typeCiphers;
    QString desc;
};
// Регистрируем тип, чтобы Qt мог передавать его между потоками
Q_DECLARE_METATYPE(ProxyResult)

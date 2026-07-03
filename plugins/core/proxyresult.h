#pragma once
#include <QMetaType>

struct ProxyResult {
    QString server;
    int     latency    = 0;
    int     port       = 0;
    QString secret;
    int     mType      = 0;
    bool    isFavorite = false;
};

Q_DECLARE_METATYPE(ProxyResult)

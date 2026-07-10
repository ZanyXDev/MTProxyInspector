#pragma once
#include <QMetaType>

struct ProxySourceLink {
    QString title;
    QString server;
    bool selected = false;
};

Q_DECLARE_METATYPE(ProxySourceLink)
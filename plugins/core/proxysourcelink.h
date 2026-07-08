#pragma once
#include <QMetaType>

struct ProxySourceLink {   
    QString url_title;
    QString url_server;
    bool selected;
};

Q_DECLARE_METATYPE(ProxySourceLink)
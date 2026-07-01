#pragma once
#include <QObject>
#include <QtQml>
#include "sendertypes.h"

// storagemanager.h
class NetworkManager : public QObject {
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr,SenderTypes senderType);
    void checkConnectivity();
signals:
    void connectivityChecked(bool ok, const QString &message,m_senderType);
private:
    SenderTypes m_senderType;
};
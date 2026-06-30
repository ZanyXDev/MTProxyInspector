#pragma once
#include <QObject>
#include <QtQml>

// storagemanager.h
class NetworkManager : public QObject {
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);
    void checkConnectivity();
signals:
    void connectivityChecked(bool ok,const QString &error);
};
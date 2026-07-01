#pragma once
#include <QObject>
#include <QtQml>
#include "sendertypes.h"

// storagemanager.h
class StorageManager : public QObject {
    Q_OBJECT
public:
    explicit StorageManager(QObject *parent = nullptr,SenderTypes senderType);

    void checkAccess();
    QString dataDir() const;             // QStandardPaths::AppDataLocation
    QString cacheDir() const;
    bool saveFile(const QString &fileName, const QByteArray &data);
    QByteArray loadFile(const QString &fileName) const;

    bool fileExists(const QString &fileName) const;
    qint64 fileAge(const QString &fileName) const;  // для кэша

signals:
    void accessChecked(bool ok, const QString &message,m_senderType);

private:
    QString m_dataDir;
    QString m_cacheDir;
    SenderTypes m_senderType;
};
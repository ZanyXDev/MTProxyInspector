#pragma once
#include <QObject>
#include <QtQml>

// storagemanager.h
class StorageManager : public QObject {
    Q_OBJECT
public:
    explicit StorageManager(QObject *parent = nullptr);

    void checkAccess();
    QString dataDir() const;             // QStandardPaths::AppDataLocation

    bool saveFile(const QString &fileName, const QByteArray &data);
    QByteArray loadFile(const QString &fileName) const;

signals:
    void accessChecked(bool ok, const QString &message);

private:
    QString m_dataDir;    
};
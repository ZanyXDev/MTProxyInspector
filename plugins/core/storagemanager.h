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
    QString cacheDir() const;
    bool saveFile(const QString &fileName, const QByteArray &data);
    QByteArray loadFile(const QString &fileName) const;

    bool fileExists(const QString &fileName) const;
    qint64 fileAge(const QString &fileName) const;  // для кэша

signals:
    void accessChecked(bool ok, const QString &error);

private:
    QString m_dataDir;
    QString m_cacheDir;
};
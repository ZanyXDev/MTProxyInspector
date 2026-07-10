#pragma once
#include <QObject>
#include <QtQml>
#include <QVariantMap>
#include <QVariantList>
#include <QUrl>
#include "proxysourcelink.h"

// storagemanager.h
class StorageManager : public QObject {
    Q_OBJECT
public:
    explicit StorageManager(QObject *parent = nullptr);
    void checkAccess();
    void loadSettings();
    void saveSettings();
signals:
    ///TODO переименовать сигнал он возвращает информационное сообщение
    void accessChecked(bool ok, const QString &message);
    void errorMessage( const QString &message );

    void appSettingsChanged(const QVariantMap &appSettings);
    void proxyLinksChanged(const QVariantList &proxyLinks);

private:
    bool m_checkAccess{false};
    QString m_dataDir;
    QVariantMap m_appSettings;             // DarkMode, PingTest, MtProxyTest
    QVariantList m_proxyLinks;

    void setDefaults();
    void setDefaultsApp();
    void setDefaultsLinks();
    QByteArray loadFile(const QString &fileName) const;
    void parseJson(const QByteArray &data);
    void applyAppSettings(const QJsonObject &appObj);
    void applyProxyLinks(const QJsonObject &proxyObj);

};

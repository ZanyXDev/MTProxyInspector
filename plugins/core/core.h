#pragma once
#include <QObject>
#include <QtQml>
#include <QStandardItemModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class ITester;

class Core : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QStandardItemModel* boardModel READ boardModel CONSTANT)    
    Q_PROPERTY(QString proxyUrlList READ proxyUrlList WRITE setProxyUrlList NOTIFY proxyUrlListChanged FINAL)
    Q_PROPERTY(bool onlineState READ onlineState NOTIFY onlineStateChanged FINAL)
public:
    explicit Core(QObject *parent = nullptr);
    QStandardItemModel *boardModel() const;        
    void setProxyUrlList(const QString &newProxyUrlList);

    QString proxyUrlList() const;

    bool onlineState() const;

signals:
    void proxyUrlListChanged();
    void showToastMessage(const QString &message  = QString());    
    void onlineStateChanged();
private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    QString convertToTlgFormat(const QString &urlString) const;

    void fetchProxyList(const QString &url);
    QStandardItemModel *m_boardModel = nullptr;

    QNetworkAccessManager *m_networkManager;
    QNetworkReply *m_currentReply = nullptr;

    ITester *m_itester = nullptr;

    QString m_proxyUrlList;
    QStringList m_proxyList;

    bool m_onlineState;
};

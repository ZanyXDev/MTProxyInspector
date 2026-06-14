#pragma once
#include <QObject>
#include <QtQml>
#include <QStandardItemModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class Core : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QStandardItemModel* boardModel READ boardModel CONSTANT)    
    Q_PROPERTY(QString proxyUrlList READ proxyUrlList WRITE setProxyUrlList NOTIFY proxyUrlListChanged FINAL)

public:
    explicit Core(QObject *parent = nullptr);
    QStandardItemModel *boardModel() const;        
    void setProxyUrlList(const QString &newProxyUrlList);

    QString proxyUrlList() const;

signals:
    void proxyUrlListChanged();
    void loadingStatusChanged(bool success, const QString &message, const QString &errorType = QString());

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    void fetchProxyList(const QString &url);

    QString m_proxyUrlList;
    QStringList m_proxyList;
    QNetworkAccessManager *m_networkManager;
    QNetworkReply *m_currentReply;

    QStandardItemModel *m_boardModel = nullptr;
};

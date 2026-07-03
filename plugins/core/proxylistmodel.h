#pragma once
#include <QAbstractListModel>
#include <QList>
#include "proxyresult.h"

class ProxyListModel : public QAbstractListModel {
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(ProxyListModel)

public:
    enum Roles {
        PingRole = Qt::UserRole + 1,
        PortRole,
        ServerRole,
        SecretRole,
    };
    Q_ENUM(Roles)

    explicit ProxyListModel(QObject *parent = nullptr);
    // QAbstractListModel interface
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    //bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    QModelIndex index(int row, int column, const QModelIndex& parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex& index) const override;

public slots:
    void append(const ProxyResult &result);
    void clear();
    void updateLatency(int row, int ping);

private:
    QList<ProxyResult> m_items;
};

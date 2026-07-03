#include "proxylistmodel.h"

ProxyListModel::ProxyListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

Qt::ItemFlags ProxyListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid()) return Qt::NoItemFlags;
    return Qt::ItemIsSelectable | Qt::ItemIsEnabled | Qt::ItemIsEditable;
}

QModelIndex ProxyListModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent)) return QModelIndex();
    return createIndex(row, column);
}

QModelIndex ProxyListModel::parent(const QModelIndex &index) const
{
    Q_UNUSED(index);
    return QModelIndex(); // Плоская структура данных
}

QHash<int, QByteArray> ProxyListModel::roleNames() const
{
    return {
        { ServerDisplayRole, "serverDisplay" },
        { PingRole,          "ping" },
        { PortRole,          "port" },
        { SecretRole,        "secret" }
    };
}

int ProxyListModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_items.size();
}

int ProxyListModel::columnCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : this->roleNames().count();
}

QVariant ProxyListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size())
        return {};

    const ProxyResult &item = m_items.at(index.row());

    switch (role) {
    case ServerDisplayRole: return item.server;
    case PingRole:          return item.latency;
    case PortRole:          return item.port;
    case SecretRole:        return item.secret;
    default:                return {};
    }        
}



void ProxyListModel::append(const ProxyResult &result)
{
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(result);
    endInsertRows();
}

void ProxyListModel::clear()
{
    beginResetModel();
    m_items.clear();
    endResetModel();
}


void ProxyListModel::updateLatency(int row, int latency)
{
    if (row < 0 || row >= m_items.size())
        return;
    m_items[row].latency = latency;
    QModelIndex idx = index(row, 0);
    emit dataChanged(idx, idx, { PingRole });
}

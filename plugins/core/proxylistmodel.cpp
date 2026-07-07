#include "proxylistmodel.h"

ProxyListModel::ProxyListModel(QObject *parent)
    : GenericListModel(parent)
{
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

void ProxyListModel::updateLatency(int row, int ping)
{
    if (row < 0 || row >= m_items.size())
        return;
    m_items[row].ping = ping;
    QModelIndex idx = index(row, 0);
    emit dataChanged(idx, idx, { PingRole });
}

int ProxyListModel::doRowCount() const
{
     return m_items.size();
}

QHash<int, QByteArray> ProxyListModel::doRoleNames() const
{
    return {
        { PingRole,    "ping" },
        { PortRole,    "port" },
        { ServerRole, "server" },
        { SecretRole,  "secret" }
    };
}

QVariant ProxyListModel::doData(int row, int role) const
{
    const ProxyResult &item = m_items.at(row);

    switch (role) {
    case PingRole:   return item.ping;
    case PortRole:   return item.port;
    case ServerRole: return item.server;
    case SecretRole: return item.secret;
    default:         return {};
    }
}

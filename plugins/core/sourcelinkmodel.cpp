// sourcelinkmodel.cpp
#include "sourcelinkmodel.h"

SourceLinkModel::SourceLinkModel(QObject *parent) : GenericListModel(parent) {}

void SourceLinkModel::append(const ProxySourceLink &link) {
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(link);
    endInsertRows();
}

void SourceLinkModel::clear() {
    beginResetModel();
    m_items.clear();
    endResetModel();
}

int SourceLinkModel::doRowCount() const {
    return m_items.size();
}

QHash<int, QByteArray> SourceLinkModel::doRoleNames() const {
    return {
        {TitleRole, "url_title"},
        {ServerRole, "url_server"}
    };
}

QVariant SourceLinkModel::doData(int row, int role) const {
    const ProxySourceLink &item = m_items.at(row);
    switch (role) {
    case TitleRole:  return item.url_title;
    case ServerRole: return item.url_server;
    default:         return QVariant();
    }
}
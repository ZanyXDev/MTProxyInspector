// sourcelinkmodel.cpp
#include "sourcelinkmodel.h"

SourceLinkModel::SourceLinkModel(QObject *parent) : GenericListModel(parent) {}

void SourceLinkModel::setFromList(const QVariantList &proxyLinks)
{
    beginResetModel();
    m_items.clear();
    // Заполняем модель новыми данными
    // Используем std::as_const для предотвращения деструктивного отсоединения (detach)
    for (const QVariant &linkVar : std::as_const(proxyLinks)) {
        QVariantMap linkMap = linkVar.toMap();
        ProxySourceLink proxyLinkItem;

        proxyLinkItem.title  = linkMap.value("title").toString();
        proxyLinkItem.server = linkMap.value("server").toString();
        proxyLinkItem.selected   = linkMap.value("selected").toBool();
        // Добавляем элемент в модель
        append( proxyLinkItem );
    }

    // Сигнализируем об успешном окончании перезагрузки
    endResetModel();
}

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
        {TitleRole, "title"},
        {ServerRole, "server"},
        {SelectedRole, "selected"}
    };
}

QVariant SourceLinkModel::doData(int row, int role) const {
    const ProxySourceLink &item = m_items.at(row);
    switch (role) {
    case TitleRole:    return item.title;
    case ServerRole:   return item.server;
    case SelectedRole: return item.selected;
    default:           return QVariant();
    }
}
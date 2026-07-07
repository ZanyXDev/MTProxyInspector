#include "genericlistmodel.h"

int GenericListModel::rowCount(const QModelIndex &parent) const {
    return parent.isValid() ? 0 : doRowCount();
}

int GenericListModel::columnCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return 1; // Обычно одна колонка для списка
}

QModelIndex GenericListModel::index(int row, int column, const QModelIndex &parent) const {
    if (parent.isValid() || row < 0 || row >= rowCount() || column != 0)
        return QModelIndex();
    return createIndex(row, column);
}

QModelIndex GenericListModel::parent(const QModelIndex &index) const {
    Q_UNUSED(index)
    return QModelIndex(); // Плоская структура данных
}

Qt::ItemFlags GenericListModel::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEnabled | Qt::ItemIsSelectable;
}

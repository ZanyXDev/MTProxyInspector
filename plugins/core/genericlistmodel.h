#pragma once
#include <QAbstractListModel>
#include <QHash>
#include <QByteArray>
#include <QObject>

/**
 * @brief The GenericListModel class
 * макрос используется, потому что модели данных наследуют QObject
 * (через QAbstractListModel) и копирование таких объектов было бы опасным
 *  — они управляют подключениями сигналов/слотов и внутренним состоянием
 *  представления.
 */

class GenericListModel : public QAbstractListModel {
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(GenericListModel)

public:
    explicit GenericListModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}

    // Общие методы, реализованные один раз
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;

    QModelIndex parent(const QModelIndex &index) const override;

    Qt::ItemFlags flags(const QModelIndex &index) const override;

    QHash<int, QByteArray> roleNames() const override {
        return doRoleNames();
    }

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override {
        if (!index.isValid() || index.row() < 0 || index.row() >= rowCount())
            return QVariant();
        return doData(index.row(), role);
    }

protected:
    // Чисто виртуальные методы, которые должны быть переопределены в наследниках
    virtual int doRowCount() const = 0;
    virtual QHash<int, QByteArray> doRoleNames() const = 0;
    virtual QVariant doData(int row, int role) const = 0;
};
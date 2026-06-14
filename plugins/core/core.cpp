#include "core.h"
#include <QDebug>

Core::Core(QObject *parent)
    : QObject(parent)
    , m_boardModel (new QStandardItemModel( this) )
{
    qDebug() << "[INIT_ORDER] >>> CorePlugin created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;
    QHash<int, QByteArray> roleNames = m_boardModel->roleNames();
    roleNames[Qt::UserRole + 1] = "pictureId";
    roleNames[Qt::UserRole + 2] = "cardVisible";
    m_boardModel->setItemRoleNames(roleNames);
#ifdef QT_DEBUG
    m_boardModel->setColumnCount(1);
    const int N = 16;
    m_boardModel->setRowCount(N);
    for (int r = 0; r < N; ++r)
    {
        QStandardItem* item = new QStandardItem();

        item->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
        item->setData( r ,Qt::UserRole +1);
        item->setData( true, Qt::UserRole +2);

        m_boardModel->setItem(r, 0, item);
    }
#endif
}


QStandardItemModel *Core::boardModel() const
{
    return m_boardModel;
}

bool Core::value() const
{
    return m_value;
}

void Core::setValue(bool newValue)
{
    QModelIndex idx = m_boardModel->index(0,0);
    QStandardItem *item = m_boardModel->itemFromIndex(idx);
    qDebug() << "item.data(Qt::UserRole + 1):" << item->data(Qt::UserRole + 1)
             << "item.data(Qt::UserRole + 2):" << item->data(Qt::UserRole + 2) ;

    (newValue) ? item->setData(99, Qt::UserRole + 1): item->setData(66, Qt::UserRole + 1);
    item->setData(newValue, Qt::UserRole + 2);

    if (m_value == newValue)
        return;
    m_value = newValue;
    emit valueChanged();
}

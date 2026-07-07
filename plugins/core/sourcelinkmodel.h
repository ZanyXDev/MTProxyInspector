#pragma once
#include <QAbstractListModel>
#include <QList>
#include "proxysourcelink.h"
#include "genericlistmodel.h"

class SourceLinkModel : public GenericListModel {
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(SourceLinkModel)

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        ServerRole,
    };
    Q_ENUM(Roles)

    explicit SourceLinkModel(QObject *parent = nullptr);

public slots:
    void append(const ProxySourceLink &link);
    void clear();
protected:
    int doRowCount() const override;
    QHash<int, QByteArray> doRoleNames() const override;
    QVariant doData(int row, int role) const override;

private:
    QList<ProxySourceLink> m_items;
};


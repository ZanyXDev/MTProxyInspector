#pragma once
#include <QAbstractListModel>
#include <QList>
#include <QVariantList>
#include <QVariantMap>
#include <QtQml>

#include "proxysourcelink.h"
#include "genericlistmodel.h"

class SourceLinkModel : public GenericListModel {
    Q_OBJECT
    QML_ELEMENT
    Q_DISABLE_COPY_MOVE(SourceLinkModel)

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        ServerRole,
        SelectedRole
    };
    Q_ENUM(Roles)

    explicit SourceLinkModel(QObject *parent = nullptr);

public slots:
    void setFromList(const QVariantList &proxyLinks);
    void append(const ProxySourceLink &link);
    void clear();
protected:
    int doRowCount() const override;
    QHash<int, QByteArray> doRoleNames() const override;
    QVariant doData(int row, int role) const override;

private:
    QList<ProxySourceLink> m_items;
};


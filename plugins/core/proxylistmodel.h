#pragma once
#include <QAbstractListModel>
#include <QtQml>
#include <QList>
#include "proxyresult.h"
#include "genericlistmodel.h"

/**
 * @brief The ProxyListModel class
 * @note Предупреждение [unresolved-type] возникает из-за того,
 * что анализатор QML (QML linter) не видит тип ProxyListModel
 * на стороне QML, несмотря на то, что AppController объявлен
 * как QML_ELEMENT.
 * Чтобы QML распознал этот тип в свойствах Q_PROPERTY,
 * класс ProxyListModel должен быть также экспонирован в систему типов QML.
 */
class ProxyListModel : public GenericListModel {
    Q_OBJECT
    QML_ELEMENT
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

public slots:
    void append(const ProxyResult &result);
    void clear();
    void updateLatency(int row, int ping);

protected:
    int doRowCount() const override;
    QHash<int, QByteArray> doRoleNames() const override;
    QVariant doData(int row, int role) const override;

private:
    QList<ProxyResult> m_items;
};

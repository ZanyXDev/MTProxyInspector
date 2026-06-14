#pragma once
#include <QObject>
#include <QtQml>
#include <QStandardItemModel>

class Core : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QStandardItemModel* boardModel READ boardModel CONSTANT)
    Q_PROPERTY(bool value READ value WRITE setValue NOTIFY valueChanged FINAL)

public:
    explicit Core(QObject *parent = nullptr);
    QStandardItemModel *boardModel() const;

    bool value() const;
    void setValue(bool newValue);

signals:
    void valueChanged();

private:
    QStandardItemModel *m_boardModel = nullptr;
    bool m_value;
};

#pragma once
#include <QObject>
#include <QtQml>

class ITester;

class Core : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit Core(QObject *parent = nullptr);

signals:
    void showToastMessage(const QString &message  = QString());

private:
    void checkExternalStorageWritable();    
};

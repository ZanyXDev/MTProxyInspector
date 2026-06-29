#pragma once
#include <QObject>
#include <QtQml>

class ITester;

class Core : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(bool externalStorageWritable READ externalStorageWritable NOTIFY externalStorageWritableChanged FINAL)
    Q_PROPERTY(bool internetConnectivity READ internetConnectivity NOTIFY internetConnectivityChanged FINAL)
public:
    explicit Core(QObject *parent = nullptr);

    bool externalStorageWritable() const;
    bool internetConnectivity() const;
    Q_INVOKABLE void checkAppCondition();
signals:
    void showToastMessage(const QString &message );
    void externalStorageWritableChanged();

    void internetConnectivityChanged();

private:
    void checkExternalStorageWritable();
    void checkInternetConnectivity();
    bool m_externalStorageWritable;
    bool m_internetConnectivity;
};

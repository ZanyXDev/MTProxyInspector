#include <QDebug>
#include <QString>
#include <QUrl>
#include <QUrlQuery>
#include <QStandardPaths>
#include <QDir>
#include <QFileInfo>

#include "core.h"


Core::Core(QObject *parent)
    : QObject(parent)
{
    qDebug() << "[INIT_ORDER] >>> CorePlugin created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;

    checkExternalStorageWritable();

}

void Core::checkExternalStorageWritable()
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QFileInfo fi(path);

    if (fi.exists() && fi.isDir()) {
        if (fi.isWritable()) {
            qDebug() << "[STORAGE] AppDataLocation is writable:" << path;
        } else {
            qWarning() << "[STORAGE] AppDataLocation is NOT writable:" << path;
            emit showToastMessage(tr("Внешнее хранилище недоступно для записи!"));
        }
    } else {
        QDir dir(path);
        if (dir.mkpath(".")) {
            qDebug() << "[STORAGE] AppDataLocation created and writable:" << path;
        } else {
            qWarning() << "[STORAGE] Cannot create AppDataLocation:" << path;
            emit showToastMessage(tr("Внешнее хранилище не найдено!"));
        }
    }
}
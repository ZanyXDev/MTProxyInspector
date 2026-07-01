#include <QFileInfo>
#include "storagemanager.h"

StorageManager::StorageManager(QObject *parent)
    : QObject(parent)
{
    m_dataDir  = QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );    
}

void StorageManager::checkAccess()
{
    bool ok = false;
    QString msg = QString();
    if (m_dataDir.isEmpty()){
        msg =  tr("AppDataLocation folder name is't valid or empty!");
    }else{
        QFileInfo fi(m_dataDir);
        if (fi.exists() && fi.isDir()) {
            if (fi.isWritable()) {
                msg =  tr("AppDataLocation is writable");
                ok = true;
            } else {
                msg =  tr("AppDataLocation is NOT writable");
            }
        } else {
            QDir dir(m_dataDir);
            if (dir.mkpath(".")) {// Создает всю цепочку папок, если их нет
                msg =  tr("AppDataLocation created and writable");
                ok = true;
            } else {
                msg =  tr("Cannot create AppDataLocation");
            }
        }
    }
#ifdef QT_DEBUG
    qDebug() << "[STORAGE]" << "ok:"<< ok << " msg:"<< msg << m_dataDir;
#endif
    emit accessChecked( ok, msg );
}

QString StorageManager::dataDir() const
{
    return m_dataDir;
}

bool StorageManager::saveFile(const QString &fileName, const QByteArray &data)
{
    return false;
}

QByteArray StorageManager::loadFile(const QString &fileName) const
{
    return QByteArray();
}



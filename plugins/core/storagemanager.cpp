#include <QFileInfo>
#include "storagemanager.h"

StorageManager::StorageManager(QObject *parent, SenderTypes senderType)
    : QObject(parent)
{
    m_dataDir  = QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );
    m_cacheDir = QStandardPaths::writableLocation( QStandardPaths::CacheLocation );
    m_senderType = senderType;
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
    emit accessChecked( ok, msg , m_senderType);
}

QString StorageManager::dataDir() const
{
    return m_dataDir;
}

QString StorageManager::cacheDir() const
{
    return m_cacheDir;
}

bool StorageManager::saveFile(const QString &fileName, const QByteArray &data)
{

}

QByteArray StorageManager::loadFile(const QString &fileName) const
{

}

bool StorageManager::fileExists(const QString &fileName) const
{

}

qint64 StorageManager::fileAge(const QString &fileName) const
{

}

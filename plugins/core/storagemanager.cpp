#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QStandardPaths>
#include <QDebug>

#include "storagemanager.h"
#include "sourcelinkmodel.h"

StorageManager::StorageManager(QObject *parent)
    : QObject(parent)
{
    m_dataDir  = QStandardPaths::writableLocation( QStandardPaths::AppDataLocation );    
}

void StorageManager::checkAccess()
{
    m_checkAccess = false;
    QString msg = QString();
    if (m_dataDir.isEmpty()){
        msg =  tr("AppDataLocation folder name is't valid or empty!");
    }else{
        QFileInfo fi(m_dataDir);
        if (fi.exists() && fi.isDir()) {
            if (fi.isWritable()) {
                msg =  tr("AppDataLocation is writable");
                m_checkAccess = true;
            } else {
                msg =  tr("AppDataLocation is NOT writable");
            }
        } else {
            QDir dir(m_dataDir);
            if (dir.mkpath(".")) {// Создает всю цепочку папок, если их нет
                msg =  tr("AppDataLocation created and writable");
                m_checkAccess = true;
            } else {
                msg =  tr("Cannot create AppDataLocation");
            }
        }
    }
#ifdef QT_DEBUG
    qDebug() << "[STORAGE]" << "m_checkAccess:"<< m_checkAccess << " msg:"<< msg << m_dataDir;
#endif
    ///TODO разделить accessChecked если успешно и errorMessage если ошибка
    emit accessChecked( m_checkAccess, msg );
}

QByteArray StorageManager::loadFile(const QString &fileName) const
{
    QFile file(fileName);
    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        return file.readAll();
    }
    return QByteArray();
}

void StorageManager::loadSettings()
{
    if (m_checkAccess){
        QByteArray data = loadFile(m_dataDir + "/settings.json");
        if (data.isEmpty()){
            setDefaults();   // Если файла нет или он повреждён — используем значения по умолчанию
            saveSettings();  // сохраним для будущих запусков
        }else{
            parseJson(data);
        }        
    }else {
        emit  errorMessage(tr("Cannot read settings.json file!"));
    }
}

void StorageManager::saveSettings()
{
    QJsonObject rootObj;

    // 1. Преобразуем m_appSettings (QVariantMap) в QJsonObject
    QJsonObject appObj = QJsonObject::fromVariantMap(m_appSettings);
    rootObj["App"] = appObj;
    // 2. Преобразуем m_proxyLinks (QVariantList) обратно в объект MTProxy
    // Так как при чтении превращали ключ-значение в список карт, возвращаем структуру обратно
    QJsonObject proxyObj;
    // std::as_const гарантирует, что контейнер не сделает глубокую копию
    for (const QVariant &linkVar : std::as_const(m_proxyLinks)) {
        QVariantMap linkMap = linkVar.toMap();
        QString title  = linkMap.value("title").toString();
        QString server = linkMap.value("server").toString();
        bool selected  = linkMap.value("selected").toBool();
        if (!title.isEmpty()) {
            // Создаем вложенный JSON-объект для хранения всех параметров прокси
            QJsonObject linkDetails;
            linkDetails["server"] = server;
            linkDetails["selected"] = selected;

            // Записываем объект под именем прокси (title)
            proxyObj[title] = linkDetails;
        }
    }
    rootObj["MTProxy"] = proxyObj;
    // 3. Создаем документ и записываем в файл
    QJsonDocument jsonDoc(rootObj);
    QFile file(m_dataDir + "/settings.json");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QString info = tr("Can't onep file to write: $1/settings.json");
        emit errorMessage(info.arg(m_dataDir));
        return;
    }

    // Сохраняем в красивом форматированном виде (Indented)
    file.write(jsonDoc.toJson(QJsonDocument::Indented));
    file.close();

}

void StorageManager::setDefaults()
{
    setDefaultsApp();
    setDefaultsLinks();
}

void StorageManager::setDefaultsApp()
{
    m_appSettings["DarkMode"] = true;
    m_appSettings["PingTest"] = true;
    m_appSettings["MTProxyTest"] = false;
    m_appSettings["EnableDebugLog"] = false;

    emit appSettingsChanged( m_appSettings );
}

void StorageManager::setDefaultsLinks()
{
    m_proxyLinks.clear();

    const QMap<QString, QString> defaultLinks = {
        {"Прокси (RU)", "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/main/proxy_ru.txt"},
        {"Прокси (EU)", "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/main/proxy_eu.txt"},
        {"Прокси (ALL)", "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/main/proxy_all.txt"},
        {"Прокси (Личный 1)", "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/main/proxy_personal_1.txt"},
        {"Прокси (Личный 2)", "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/main/proxy_personal_2.txt"}
    };
    for (auto it = defaultLinks.begin(); it != defaultLinks.end(); ++it) {
        QVariantMap map;
        map["title"] = it.key();
        map["server"] = it.value();
        map["selected"] = false;
        m_proxyLinks.append(map);
    }
    emit proxyLinksChanged(m_proxyLinks);
}

void StorageManager::applyAppSettings(const QJsonObject &appObj)
{
    m_appSettings["DarkMode"] = appObj.value("DarkMode").toBool(true);
    m_appSettings["PingTest"] = appObj.value("PingTest").toBool(true);
    m_appSettings["MTProxyTest"] = appObj.value("MTProxyTest").toBool(false);
    m_appSettings["EnableDebugLog"] = appObj.value("EnableDebugLog").toBool(false);
    emit appSettingsChanged(m_appSettings);
}

void StorageManager::applyProxyLinks(const QJsonObject &proxyObj)
{
    m_proxyLinks.clear();
    for (auto it = proxyObj.begin(); it != proxyObj.end(); ++it) {
        // Теперь внутри лежит объект, а не строка
        if (it.value().isObject()) {
            QJsonObject linkDetails = it.value().toObject();

            QVariantMap map;
            map["title"] = it.key();
            map["server"] = linkDetails.value("server").toString();
            map["selected"] = linkDetails.value("selected").toBool(false); // по умолчанию false

            m_proxyLinks.append(map);
        }
    }
    emit proxyLinksChanged(m_proxyLinks);
}

void StorageManager::parseJson(const QByteArray &data)
{
    QJsonDocument json = QJsonDocument::fromJson(data);
    if (!json.isNull() && json.isObject()) {
        // Получаем корневой объект JSON
        QJsonObject rootObj = json.object();

        // Обработка раздела App
        if ( !(rootObj.contains("App") &&  rootObj["App"].isObject()) ) {
            // если нет раздела App – берем дефолтные
            setDefaultsApp();
        } else {
            applyAppSettings(rootObj["App"].toObject());
        }
        // Обработка раздела MTProxy
        if ( !(rootObj.contains("MTProxy") && rootObj["MTProxy"].isObject()) ) {
            // если нет – заполняем дефолтными ссылками
            setDefaultsLinks();
        }else{
            applyProxyLinks(rootObj["MTProxy"].toObject());
        }
    }
}

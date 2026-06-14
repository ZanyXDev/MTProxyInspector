#include <QDir>
#include <QDirListing>
#include <QDirIterator>
#include <QStringList>

#include "imagedatamanager.h"

ImageDataManager *ImageDataManager::create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(jsEngine)

    // ✅ Правильная проверка с атомарной инициализацией
    ImageDataManager* expected = nullptr;
    if (s_instance.loadAcquire() == nullptr){
        auto* instance = new ImageDataManager();
        s_instance.storeRelease(instance);

        // ✅ Передаём владение qmlEngine, чтобы он удалил объект при необходимости
        qmlEngine->setObjectOwnership(instance, QQmlEngine::CppOwnership);
        return instance;
    }

    return s_instance.loadAcquire();
}

QString ImageDataManager::getRealFileName(const QString &id)
{
    if ( m_images.isEmpty() ) {
        qWarning() <<Q_FUNC_INFO << " No images found in resources!";
        return QString();
    }

    // Валидация входного параметра
    if (id.isEmpty()) {
        qWarning() << Q_FUNC_INFO <<  "Empty id requested !";
        return QString();
    }

    QString packName = getPackNameFromPatch( id );

    if (packName.isEmpty()){
        // обычное изображение возвращаем путь
        // ❌ Сейчас: фильтр по подстроке (может вернуть неверный результат)
        //      m_images.filter(id).at(0);
        // ✅ Лучше: точное сравнение или endsWith для имён файлов
        for (const QString& img : std::as_const(m_images)) {
            qDebug() <<"img:" <<img << "id:" <<id;
            if (img.endsWith('/' + id) || img == id) {
                return img;
            }
        }

    }else{
        // нашли изображение pack
        QStringList parts = id.split("/");
        if (parts.size() < 2) {
            qWarning() << "[ImagePackProvider] Invalid id format:" << id << "- expected format: '__packName/index'";
            return QString();
        }
        bool conversionOk = false;
        int pictureId = parts[1].toInt(&conversionOk);
        if (conversionOk){
            if (pictureId >=0 && pictureId < m_packs.filter("__"+packName ).count() ){
                return m_packs.filter("__"+packName ).at( pictureId );
            }
        }else{
            qWarning() << "[ImagePackProvider] Invalid id format (index conversion):" << id << "- expected format: '__packName/index'";
            return QString();
        }
    }
    return QString();
}

QString ImageDataManager::currentPackName() const
{
    return m_currentPackName;
}

int ImageDataManager::currentPackImagesCount() const
{
    return m_currentPackImagesCount;
}

void ImageDataManager::onPackComboBoxIndexChanged(int current)
{
    if (current == -1 ) return;

    if ( current <= m_packNames.count()){
        QString tmpStr = m_packNames.at( current );
        if ( tmpStr != m_currentPackName ){
            m_currentPackName = tmpStr;
            m_currentPackImagesCount = m_packs.filter("__"+tmpStr ).count();
            emit currentPackNameChanged();
            emit currentPackImagesCountChanged();
        }
    }
}

// ------------------------ private -----------------------------------------
ImageDataManager::ImageDataManager(QObject *parent)
    : QObject(parent)
{
    qDebug() << "[INIT_ORDER] >>> ImageDataManager created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;

    getAllImagesFileName();
}

void ImageDataManager::getAllImagesFileName()
{
    m_images.clear();
    m_packs.clear();
    m_packNames.clear();

    // Определяем список расширений изображений
    const QStringList imageFilters = { "*.png", "*.jpg", "*.jpeg", "*.svg" };

    // Создаём итератор с рекурсивным обходом и фильтрами
    QDirIterator it(":/qt/qml/assets/images",
                    imageFilters, QDir::Files, QDirIterator::Subdirectories);

    while (it.hasNext()) {
        it.next();
        const QString filePath = it.filePath();
        QString _packName = getPackNameFromPatch(filePath);
        if (_packName.isEmpty()){
            m_images.append( filePath );
        }else{
            if ( !m_packNames.contains( _packName,Qt::CaseInsensitive )){
                m_packNames.append( _packName );
            }
            m_packs.append( filePath );
        }
    }

    if ( m_images.isEmpty() || m_packs.isEmpty() || m_packNames.empty()) {
        qCritical() << "[DEV.plugin] ImageDataManager: No images found in resources!";
        Q_ASSERT_X(false, "ImageDataManager::getAllImagesFileName", "Broken qresources!!");
    }else{
        emit packNamesChanged();  // ✅ Уведомляем QML об изменении данных
        onPackComboBoxIndexChanged( 0 );
    }
}

QString ImageDataManager::getPackNameFromPatch(const QString &path)
{
    /**
     * @brief re Поиск названия бандла с картинками
     * .*? чтобы поиск остановился сразу на первом встреченном __:
     *  __ — два символа подчёркивания.
     * ( начало захвата группы
     *  [^/]+ — один или более любых символов, кроме /.
     *  ) конец захвата группы
     *  / — обязательный слэш после текста.
     */
    QRegularExpression re(".*?__([^/]+)/.*");

    QRegularExpressionMatch match = re.match( path );
    if (match.hasMatch()) {
        return match.captured(1); // Вернет "animals" или "emoji"
    } else {
        qWarning() << "Совпадение не найдено для пути:" << path;
        return QString();
    }
}

QStringList ImageDataManager::packNames() const
{
    return m_packNames;
}

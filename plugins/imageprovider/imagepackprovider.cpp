//src/plugins/imageprovider/imagepackprovider.cpp
#include "imagepackprovider.h"
#include "imagedatamanager.h"

ImagePackProvider::ImagePackProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
    qDebug().nospace() << "[INIT_ORDER] >>> ImagePackProvider created at "
                       << QTime::currentTime().toString("hh:mm:ss.zzz")
                       << ", instance:" << static_cast<void*>(this);
}

QPixmap ImagePackProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    // ✅ Мгновенный и потокобезопасный доступ к синглтону
    auto* dataManager = ImageDataManager::instance();
    if (!dataManager) {
        qWarning() << "[ImagePackProvider] ImageDataManager not initialized yet!";
        return QPixmap();
    }

    // ✅ Вызываем метод синглтона
    QString fileName = dataManager->getRealFileName( id );

    if (fileName.isEmpty()) return QPixmap();

    QPixmap pixmap;
    if (!pixmap.load(fileName)) {
        qWarning() << "[ImagePackProvider] Failed to load image:" << fileName;
        return QPixmap();
    }
    // Масштабирование, если запрошен другой размер
    if (requestedSize.isValid() && !requestedSize.isEmpty()) {
        if (pixmap.size() != requestedSize) {
            Qt::AspectRatioMode aspectMode = Qt::KeepAspectRatio;
            Qt::TransformationMode transformMode = Qt::SmoothTransformation;

            qDebug() << "[ImagePackProvider] Scaled image from" << pixmap.size()
                     << "to" << requestedSize << "(aspect ratio kept)";
            pixmap = pixmap.scaled(requestedSize, aspectMode, transformMode);

            if (size) {
                *size = pixmap.size();
            }
        } else if (size) {
            *size = pixmap.size();
        }
    } else if (size) {
        *size = pixmap.size();
    }

    return pixmap;
}





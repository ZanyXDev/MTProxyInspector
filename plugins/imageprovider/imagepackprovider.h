//src/plugins/imageprovider/imagepackprovider.h
#pragma once

#include <QQuickImageProvider>
#include <QPixmap>
#include <QPointer>
#include <QQmlEngine>


class ImagePackProvider : public QQuickImageProvider
{
public:
    ImagePackProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;
private:
    QPointer<QQmlEngine> m_engine;  // ✅ Безопасный указатель на engine
};

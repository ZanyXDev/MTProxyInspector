// src/plugins/imageprovider/imageproviderplugin.h
#pragma once
#include <QQmlExtensionPlugin>
#include <QQmlEngine>

#include "imagepackprovider.h"

class ImageProviderPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)
public:
    // registerTypes обязателен для QQmlExtensionPlugin (даже если пустой)
    void registerTypes(const char *uri) override
    {
       Q_UNUSED(uri);
       // Для image provider типы не регистрируем — только провайдер
    }

    // initializeEngine вызывается при первом импорте модуля в QML
    void initializeEngine(QQmlEngine *engine, const char *uri) override
    {
        Q_ASSERT(uri == QLatin1String("ImageProviderCore"));
        engine->addImageProvider("imagepack", new ImagePackProvider());
    }
};
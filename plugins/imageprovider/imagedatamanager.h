#pragma once

#include <QObject>
#include <QDebug>
#include <QStringListModel>
#include <QtQml>

#include <QAtomicPointer> // ✅ Для потокобезопасного доступа из QQuickImageProvider

/**
 * @brief The ImageDataManager class
 * Wrapper для ImagePackProvider
 * Обрабоатывает пути к фалам изображений из ресурсов по запросу отдает реальный файловый путь
 */

class ImageDataManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON    
    Q_PROPERTY(QString currentPackName READ currentPackName  NOTIFY currentPackNameChanged FINAL)
    Q_PROPERTY(int currentPackImagesCount READ currentPackImagesCount NOTIFY currentPackImagesCountChanged FINAL)
    // Добавьте:
    Q_PROPERTY(QStringList packNames READ packNames NOTIFY packNamesChanged FINAL)
public:    
    ~ImageDataManager() override;

    /**
     * @brief create
     * @param qmlEngine not used
     * @param jsEngine not used
     * @return static ImageDataManager*
     * @note Вызывается движком @sa qmlEngine для "ленивого" динамического создания Singleton экземпляра класса
     */
    static ImageDataManager* create(QQmlEngine* qmlEngine, QJSEngine* jsEngine);
    // ✅ Потокобезопасный доступ к экземпляру синглтона
    static ImageDataManager* instance();
    // ----------------- getRealFileName ------------------------------------
    QString getRealFileName(const QString &id);

    QStringListModel *packNamesModel() const;   
    QString currentPackName() const;    
    int currentPackImagesCount() const;

    QStringList packNames() const;

public slots:
    void onPackComboBoxIndexChanged(int current);

signals:
    void currentPackNameChanged();
    void currentPackImagesCountChanged();

    void packNamesChanged();

private:
    /**
     * @brief ImageDataManager
     * @param parent
     * @note Приватный конструктор
     *              Особенности
     * Объекты такого класса могут создаваться только внутри его методов (например, статических).
     * Попытка создать объект извне вызовет ошибку компиляции.
     * Приватный конструктор часто используется вместе с паттернами проектирования и для повышения безопасности кода.
     *              Когда использовать
     * Если нужно ограничить создание объектов класса.
     * Для реализации Singleton.
     * Для классов-утилит, не требующих состояния.
     */
    explicit ImageDataManager(QObject* parent = nullptr);

    void getAllImagesFileName();
    QString getPackNameFromPatch(const QString &path);
    QString getImageNameFromPack(const QString &id);
    // ✅ Атомарный указатель: безопасно читать из любого потока
    inline static QAtomicPointer<ImageDataManager> s_instance{nullptr};

    QStringList m_images;
    QStringList m_packs;

    QString m_currentPackName;
    int m_currentPackImagesCount;
    QStringList m_packNames;
};

inline ImageDataManager::~ImageDataManager() = default;

inline ImageDataManager *ImageDataManager::instance() { return s_instance.loadAcquire(); }
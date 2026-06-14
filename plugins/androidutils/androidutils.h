#pragma once
#include <QObject>
#include <QString>
#include <QtQml>

class AndroidUtils : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:

    /**
     * @brief create
     * @param qmlEngine not used
     * @param jsEngine not used
     * @return static ImageDataManager*
     * @note Вызывается движком @sa qmlEngine для "ленивого" динамического создания Singleton экземпляра класса
     */
    static AndroidUtils* create(QQmlEngine* qmlEngine, QJSEngine* jsEngine);
    // ✅ Потокобезопасный доступ к экземпляру синглтона
    static AndroidUtils* instance();

    // Метод, который мы будем вызывать из QML
    Q_INVOKABLE void showToast(const QString &message, bool isLong = false);
private:
    /**
     * @brief AndroidUtils
     * @param parent
     * @note Приватный конструктор
     *              Особенности
     * Объекты такого класса могут создаваться только внутри его методов
     * (например, статических).
     * Попытка создать объект извне вызовет ошибку компиляции.
     * Приватный конструктор часто используется вместе с паттернами проектирования
     * и для повышения безопасности кода.
     *              Когда использовать
     * Если нужно ограничить создание объектов класса.
     * Для реализации Singleton.
     * Для классов-утилит, не требующих состояния.
     */

    explicit AndroidUtils(QObject *parent = nullptr) ;
    // ✅ Атомарный указатель: безопасно читать из любого потока
    inline static QAtomicPointer<AndroidUtils> s_instance{nullptr};
};

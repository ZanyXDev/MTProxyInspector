#include "androidutils.h"

#ifdef Q_OS_ANDROID
#include <QJniObject>
#endif

AndroidUtils *AndroidUtils::create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)

    if (s_instance.loadAcquire() == nullptr) {
        auto* instance = new AndroidUtils();
        s_instance.storeRelease(instance);
        return instance;
    }

    // Если уже создан, возвращаем существующий (QML этого не ожидает!)
    qWarning() << "AndroidUtils already exists - returning existing instance";
    return s_instance.loadAcquire();
}


void AndroidUtils::showToast(const QString &message, bool isLong) {
#ifdef Q_OS_ANDROID
    // Переводим текст в Java String
    QJniObject javaMessage = QJniObject::fromString(message);
    jint duration = isLong ? 1 : 0; // 1 = Toast.LENGTH_LONG, 0 = Toast.LENGTH_SHORT

    // Получаем контекст текущего Android-приложения
    QJniObject context = QNativeInterface::QAndroidApplication::context();

    // Вызываем статический метод Toast.makeText
    QJniObject toast = QJniObject::callStaticObjectMethod(
        "android/widget/Toast",
        "makeText",
        "(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;",
        context.object(),
        javaMessage.object(),
        duration
        );

    // Если объект успешно создан, вызываем метод .show()
    if (toast.isValid()) {
        toast.callMethod<void>("show");
    }
#else
    qDebug() << "Toast (Desktop emulation):" << message;
#endif
}

AndroidUtils::AndroidUtils(QObject *parent)
    : QObject(parent)
{
    qDebug() << "[INIT_ORDER] >>> AndroidUtils created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this;
}

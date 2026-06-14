#include "androidutils.h"

#ifdef Q_OS_ANDROID
#include <QJniObject>      // ✅ для QNativeInterface::QAndroidApplication
#include <QCoreApplication>
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



void AndroidUtils::showToast(const QString &message, bool isLong)
{
#ifdef Q_OS_ANDROID
    // ✅ Выполняем в главном UI-потоке Android, где есть Looper
    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([message, isLong]() {
        QJniObject javaMessage = QJniObject::fromString(message);
        jint duration = isLong ? 1 : 0; // 1 = Toast.LENGTH_LONG, 0 = Toast.LENGTH_SHORT

        QJniObject context = QNativeInterface::QAndroidApplication::context();

        QJniObject toast = QJniObject::callStaticObjectMethod(
            "android/widget/Toast",
            "makeText",
            "(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;",
            context.object(),
            javaMessage.object(),
            duration
            );

        if (toast.isValid()) {
            toast.callMethod<void>("show");
        }
    });
#else
    qDebug() << "Toast (Desktop emulation):" << message;
#endif
}

AndroidUtils::AndroidUtils(QObject *parent)
    : QObject(parent)
{
    qDebug() << Q_FUNC_INFO
             << "[INIT_ORDER] >>> AndroidUtils created at"
             << QTime::currentTime().toString("hh:mm:ss.zzz")
             << ", instance:" << this
             << ", parent:" << parent;
}

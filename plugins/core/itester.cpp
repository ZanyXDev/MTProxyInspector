#include <QLoggingCategory>
#include <QNetworkInterface>

#include "itester.h"

Q_LOGGING_CATEGORY(networkLog, "ITester")

ITester::ITester(QObject *parent)
    : QObject(parent)
{

}

void ITester::checkNetworkAvailability()
{
    QDateTime startTime = QDateTime::currentDateTime();
    // Разница в миллисекундах
    qint64 deltaMsecs = m_lastCheck.msecsTo(startTime);
    qDebug() << "Разница (мс):" << deltaMsecs;
    if ((deltaMsecs > 0) && (deltaMsecs < 1000)
        && m_isNetworkAvailable
        && m_hasActiveInternet  ){
        return;
    }
    // Start new test
    m_isNetworkAvailable = checkNetworkInterfaceAvailability();

    m_lastCheck = QDateTime::currentDateTime();
}

bool ITester::checkNetworkInterfaceAvailability()
{
    //Проверка через QNetworkInterface
    bool hasNetwork = false;
    QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();

    for (const QNetworkInterface &iface : interfaces) {
        // Получаем флаги текущего интерфейса
        QNetworkInterface::InterfaceFlags flags = iface.flags();
        // 1. Проверка: включен ли интерфейс (IsUp)
        // 2. Проверка: включен ли интерфейс (IsRunning) и физически подключен
        // 3. Проверка: является ли интерфейс петлей (Loopback / localhost)

        if ( flags.testFlag(QNetworkInterface::IsUp) &&
             flags.testFlags(QNetworkInterface::IsRunning) &&
             !flags.testFlags(QNetworkInterface::IsLoopBack)  ){

            hasNetwork = true;
            break;
        }
    }

    return hasNetwork;
}

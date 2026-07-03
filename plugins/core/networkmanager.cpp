#include <QNetworkInformation>
#include <QUrl>
#include <QUrlQuery>
#include <QNetworkRequest>
#include <QFutureWatcher>
#include <QFuture>
#include <QtConcurrent>
#include "networkmanager.h"

NetworkManager::NetworkManager(QObject *parent)
    : QObject(parent)
{
    if (QNetworkInformation::instance()) {
        connect(QNetworkInformation::instance(), &QNetworkInformation::reachabilityChanged,
                this, [this](QNetworkInformation::Reachability newReachability) {

                    // C++17 Структурированное связывание напрямую из функции
                    auto [isOnline, msg] = parseReachability(newReachability);
                    m_internetConnectivity = isOnline;
                    qDebug() << "[NETWORK] Reachability changed:" << msg;
                    emit connectivityChecked(isOnline, msg);
                });
    } else {
        qDebug() << "[NETWORK] QNetworkInformation not available on this platform";
    }
    m_networkAccessManager = new QNetworkAccessManager(this);
}

void NetworkManager::checkConnectivity()
{
    // Если сервис недоступен, задаем дефолтные значения прямо при объявлении
    m_internetConnectivity = false;
    QString msg = tr("Сетевое подключение недоступно!");

    if (QNetworkInformation::instance()) {
        //Создаем переменные прямо в момент получения результата
        auto [currentOnline, currentMsg] = parseReachability(QNetworkInformation::instance()->reachability());
        m_internetConnectivity = currentOnline;
        msg = currentMsg;

        if (!m_internetConnectivity) {
            qWarning() << "[NETWORK]" << msg;
        }
    }

    emit connectivityChecked(m_internetConnectivity, msg);
}

void NetworkManager::refreshProxyLists(const QString &urlSourceList)
{
    if (!m_internetConnectivity)
        return;
    if (urlSourceList.isEmpty())
        return;

    QUrl qurl(urlSourceList);
    if (!qurl.isValid()) {
        emit parseProxyListStatus(false, tr("Неверный URL: %1").arg(urlSourceList) );
        return;
    }
    // Отменяем предыдущий запрос если есть
    if (m_currentReply) {
        m_currentReply->abort();
        m_currentReply->deleteLater();
        m_currentReply = nullptr;

    }
    ///TODO Нужна проверка что опрос серверов из предыдущего списка тоже отменен, модель данных сборошена
    QNetworkRequest request(urlSourceList);
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
    request.setTransferTimeout(5000);
    m_currentReply = m_networkAccessManager->get(request);

    connect(m_currentReply, &QNetworkReply::finished, this, &NetworkManager::onReplyFinished);
}

void NetworkManager::onReplyFinished()
{
    // Сохраняем указатель в локальную переменную
    QNetworkReply *reply = m_currentReply;

    // Сразу обнуляем член класса и помечаем объект на удаление
    m_currentReply = nullptr;
    if (reply) {
        reply->deleteLater();
    } else {
        return;
    }
    m_currentProxyList.clear();
    bool success = false;
    QString errorMessage;
    QString errorType;

    // Проверяем наличие ошибок
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Network error:" << reply->errorString();
        success = false;
        // Обработка различных типов ошибок
        switch (reply->error()) {
        case QNetworkReply::TimeoutError:
            errorMessage = tr("Таймаут при загрузке прокси (>5 секунд). Проверьте соединение.");
            errorType = "timeout";
            break;

        case QNetworkReply::HostNotFoundError:
            errorMessage = tr("Хост не найден. Проверьте URL.");
            errorType = "host_not_found";
            break;

        case QNetworkReply::ContentNotFoundError:
            errorMessage = tr("Файл не найден на сервере (404).");
            errorType = "not_found";
            break;

        case QNetworkReply::OperationCanceledError:
            errorMessage = tr("Операция отменена.");
            errorType = "cancelled";
            break;
        default:
            errorMessage = tr("Ошибка загрузки: %1 (код: %2)")
                               .arg(reply->errorString())
                               .arg(reply->error());
            errorType = "network_error";
            break;
        }
    }else{
        // Загружаем данные в QStringList
        QByteArray data = reply->readAll();
        QString content = QString::fromUtf8(data);

        // Разбиваем на строки, удаляем пустые строки
        QStringList proxyList = content.split('\n', Qt::SkipEmptyParts);
        for (QString &line : proxyList) {
            line = line.trimmed();
            if (line.isEmpty() || line.startsWith('#')) {
                line = "";
                continue;
            }
            QUrl qurl(line);
            if (!(qurl.isValid() && qurl.scheme() == "tg")){
                line = ""; // Не валидный URL или нет протокола
            }
        }
        proxyList.removeAll("");
        if (!proxyList.isEmpty()) {
            success = true;
            errorMessage = tr("Загружено %1 mtproxy").arg(proxyList.size());
            errorType = "success";

            // Сохраняем список прокси
            m_currentProxyList = proxyList;            
            emit proxyListChanged( m_currentProxyList.count() );
            // запуск многопоточной проверки прокси серверов
            refreshProxyLists( m_currentProxyList );
        } else {
            success = false;
            errorMessage = tr("Файл с прокси пуст");
            errorType = "empty";
        }
    }
    // Информируем frontend
    m_loadingStatus = success;
    emit loadingStatusChanged(success, errorMessage, errorType);
}

// Функция проверки ОДНОГО прокси (работает в фоновом потоке)
ProxyResult  NetworkManager::checkSingleProxy(const QString &proxyUrl) const{
    ProxyResult result;
    // ... логика проверки, замер latency ...
    return result;
}
void NetworkManager::refreshProxyLists(const QStringList &sources){
    /** @note Самый современный и чистый способ в C++11 и новее.
     *  Передача this в контекст лямбды, чтобы вызвать метод у текущего объекта.
    */
    QFuture<ProxyResult> future = QtConcurrent::mapped(sources, [this](const QString &proxyUrl) {
        return checkSingleProxy(proxyUrl);
    });
    // Отслеживаем результаты через watcher
    auto *watcher = new QFutureWatcher<ProxyResult>(this);

    // Сигнал срабатывает, как только готов ТЕКУЩИЙ прокси
    connect(watcher, &QFutureWatcher<ProxyResult>::resultReadyAt, this, [this, watcher](int index){
        ProxyResult res = watcher->resultAt(index);
        emit proxyChecked(res); // Отправляем в AppController -> в модель
    });

    // Очищаем watcher после завершения всей проверки
    connect(watcher, &QFutureWatcher<ProxyResult>::finished, watcher, &QFutureWatcher<ProxyResult>::deleteLater);

    watcher->setFuture(future);
}
// Метод возвращает структуру, которая на лету раскладывается в C++17 коде
NetworkManager::Status NetworkManager::parseReachability(QNetworkInformation::Reachability reachability) const
{
    const bool isOnline = (reachability == QNetworkInformation::Reachability::Online);
    QString msg;

    switch (reachability) {
    case QNetworkInformation::Reachability::Online:
        msg = tr("Устройство онлайн!");
        break;
    case QNetworkInformation::Reachability::Disconnected:
        msg = tr("Устройство офлайн!");
        break;
    case QNetworkInformation::Reachability::Local:
        msg = tr("Устройство подключено к локальной сети, без доступа в Интернет!");
        break;
    case QNetworkInformation::Reachability::Site:
        msg = tr("Устройство подключено к интранет сети, без доступа в Интернет!");
        break;
    default:
        msg = tr("Сетевое подключение недоступно!");
        break;
    }

    return {isOnline, msg}; // Инициализация структуры агрегатом
}


#include "networkmanager.h"

NetworkManager::NetworkManager(QObject *parent, SenderTypes senderType)
    : QObject(parent)
{
    m_senderType = senderType;
}

void NetworkManager::checkConnectivity()
{

}


    ColumnLayout {
        id: mainColumnLayout
        Material.theme: appWnd.Material.theme
        Material.elevation: 2
        anchors.centerIn: parent
        anchors{
            fill: parent
            margins: padding /2
            leftMargin: 2
            rightMargin: 8
            topMargin: 8
            bottomMargin: 10
        }

        spacing: baseSpacing

        Pane {
            id: sourceSelectorPane
            Layout.fillWidth: true
            background: Rectangle {
                color: Material.backgroundColor
                radius: appWnd.m_radius
                border.width: 1
                border.color: Material.frameColor
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 2
                CheckBox {
                    id:ruList
                    Layout.fillWidth: true // Принудительно растягиваем на всю доступную ширину
                    text: qsTr("Сервира из [RU] региона")
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 16
                        bold:true
                    }
                }
                CheckBox {
                    id:euList
                    Layout.fillWidth: true
                    text: qsTr("Сервира из [EU] региона")
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 16
                        bold:true
                    }
                }
                CheckBox {
                    id:surfList
                    Layout.fillWidth: true
                    text: qsTr("Сервира от Surfboardv2ray")
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 16
                        bold:true
                    }
                }
                Frame{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 2
                }
                Button{
                    id:runCheckProxyList
                    icon.source: isConnected ? "qrc:/qt/qml/assets/images/online.png":"qrc:/qt/qml/assets/images/offline.png"
                    enabled: isConnected && (ruList.checked | euList.checked | surfList.checked)
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Проверка прокси")
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 15
                        bold:true
                    }
                }
            }
        }
        Pane{
            id:paneListView
            Layout.fillWidth: true
            Layout.fillHeight:  true
            background: Rectangle {
                color: Material.backgroundColor
                radius: appWnd.m_radius
                border.width: 1
                border.color: Material.frameColor
            }
            ListView {
                id: listView
                anchors.fill: parent

                clip: true
                focus: true // Required for arrow keys to work
                keyNavigationWraps: true // Allows looping from end to start

                model: [
                    { status: "ok",  text: "mtproxy.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy1.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy2.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy3.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "bad", text: "mtproxy3.prn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy1.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy2.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy3.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy1.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy2.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy3.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy1.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy2.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "ok",  text: "mtproxy3.rkn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" },
                    { status: "bad", text: "mtproxy3.prn.ru", mtproxyurl:"https://t.me/server=1.1.1.1&port=483&secret=dmshfhdashfejwr3ur104033" }

                ]
                highlight: Rectangle {

                    color: Material.listHighlightColor
                    radius: appWnd.m_radius
                    // Standard Behavior can be used for custom easing
                    Behavior on y {
                        SpringAnimation { spring: 3; damping: 0.2 }
                    }
                }

                delegate: MItemDelegate {
                    required property int index
                    width: ListView.view.width
                    hoverEnabled: false
                    text:qsTr("Title %1").arg(index + 1)

                    icon.source:"qrc:/qt/qml/assets/images/ok.png"
                    highlighted: ListView.isCurrentItem
                    onClicked: listView.currentIndex = index

                }
                // Component.onCompleted: currentIndex = 0
            }

        }
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 2
        }
    }
    Text {
        Material.theme: appWnd.Material.theme
        color:  Material.foreground
        id:appVerTxt
        z: 1
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        // Добавляем отступы от краев contentItem, чтобы текст не лип к границам
        anchors.rightMargin: 16
        anchors.bottomMargin: 6

        opacity:0
        visible: false
        text: qsTr("v.")+ appWnd.appVersion + " "
        font{
            family: appWnd.digitalFont.name
            pixelSize: 10
            bold: true
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }


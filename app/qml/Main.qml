import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import io.github.zanyxdev.mtproxyinspector
import io.github.zanyxdev.mtproxyinspector.core
import io.github.zanyxdev.mtproxyinspector.androidutils

ApplicationWindow {
    id: appWnd

    // ----- Property Declarations
    // Required properties should be at the top.
    readonly property int screenOrientation: Qt.PortraitOrientation
    property bool isConnected: Core.onlineState
    property var screenWidth: Screen.width
    property var screenHeight: Screen.height
    property var screenAvailableWidth: Screen.desktopAvailableWidth
    property var screenAvailableHeight: Screen.desktopAvailableHeight

    // Свойство для версии приложения
    property string appVersion
    property string buildQtVersion

    // Свойство-флаг для мобильной платформы
    property bool isMobile: Qt.platform.os === "android" || Qt.platform.os === "ios"
    // Свойство-флаг для режима отладки
    property bool isDebugMode: false


    ///TODO add load/save in app Settings
    // Theme selection
    property bool darkMode: true
    property real  baseSpacing: 8
    property real  padding: 16
    property real  m_radius: 12

    property FontLoader buiraFont: FontLoader {
        id: buiraFont
        source: "qrc:/qt/qml/assets/fonts/Buira/Buira.otf"
    }
    property FontLoader droidFont: FontLoader {
        id: droidFont
        source: "qrc:/qt/qml/assets/fonts/droidsansmono.ttf"
    }
    property FontLoader digitalFont: FontLoader {
        id: digitalFont
        source: "qrc:/qt/qml/assets/fonts/681-font.otf"
    }
    property FontLoader baseFont: FontLoader {
        id: baseFont
        source: "qrc:/qt/qml/assets/fonts/nasalization-rg.otf"
    }

    // -------------------- Глобальные стиль --------------------------------

    // Solarized color palette
    // Dark theme
    readonly property color solarizedBase3: "#fdf6e3"
    readonly property color solarizedBase2: "#eee8d5"

    readonly property color solarizedBase1: "#93a1a1" // опционально подчеркнутый
    readonly property color solarizedBase0: "#839496" // primary content основной текст
    readonly property color solarizedBase00: "#657b83"
    readonly property color solarizedBase01: "#586e75"// secondary content коментарии
    readonly property color solarizedBase02: "#073642"// background highlights
    readonly property color solarizedBase03: "#002b36"// background

    // Ligth theme
    // solarizedBase03
    // solarizedBase02
    // solarizedBase01 // опционально подчеркнутый
    // solarizedBase00 // primary content основной текст
    // solarizedBase0
    // solarizedBase1 // secondary content коментарии
    // solarizedBase2 // background highlights
    // solarizedBase3 // background

    readonly property color solarizedYellow: "#b58900"
    readonly property color solarizedOrange: "#cb4b16"
    readonly property color solarizedRed: "#dc322f"
    readonly property color solarizedMagenta: "#d33682"
    readonly property color solarizedViolet: "#6c71c4"
    readonly property color solarizedBlue: "#268bd2"
    readonly property color solarizedCyan: "#2aa198"
    readonly property color solarizedGreen: "#859900"
    readonly property color hightlightcolor: "#1e000000"

    Material.theme: darkMode ? Material.Dark : Material.Light
    Material.background: darkMode ? solarizedBase03 : solarizedBase3
    Material.foreground: darkMode ? solarizedBase0 : solarizedBase00
    Material.accent: solarizedOrange
    Material.primary: solarizedYellow

    Material.elevation : 2

    // ----- Signal declarations

    // ----- Size information
    /**
    * @brief
    * При работе с Android системами обычно выбирается базовый фрейм 360×640,
    * для адаптации под удлиненные экраны 18:9 можно использовать размер фрейма 360×720.
    * Размер фрейма для приложения на системе IOS чаще всего используется 375×812.
  */
    width: 360
    height: 720

    // ----- Then comes the other properties. There's no predefined order to these.
    visible: true
    visibility: (isMobile) ? Window.FullScreen : Window.Windowed
    flags: Qt.Window | Qt.ExpandedClientAreaHint | Qt.NoTitleBarBackgroundHi>
    // ----- Qt provided visual children


    header: ToolBar{
            background: Rectangle {
                color: Material.backgroundColor
		opacity: 0.7
            }
            RowLayout {
                spacing: baseSpacing
                anchors{
                    fill: parent
                }
                Item{
                    id:spacer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Label {
                    id:titleLabel
                    Layout.alignment: Qt.AlignVCenter  // Вертикальное центрирование
                    Layout.fillHeight: true            // Заполнить высоту родителя
                    Layout.fillWidth: false
                    Layout.leftMargin: padding

                    text: qsTr("Тест MTProxy для Телеграм")
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 18
                        bold:true
                    }
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                ToolButton {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    // Иконка "три точки" (вертикальные)
                    icon.source: "qrc:/qt/qml/assets/images/more_vert.png"
                    onClicked: optionsMenu.open()

                    Menu {
                        id: optionsMenu
                        y: parent.height

                        MenuItem {
                            icon.source: "qrc:/qt/qml/assets/images/settings.png"
                            text: qsTr("Настройки")
                            onTriggered: console.log("Настройки выбраны")
                        }
                        MenuItem {
                            id:themeModeMenu
                            icon.source: (appWnd.darkMode) ?  "qrc:/qt/qml/assets/images/sun.png" :"qrc:/qt/qml/assets/images/moon.png"
                            text:(appWnd.darkMode) ? qsTr("Дневной") :qsTr("Ночной")
                            onTriggered: {

                                console.log(`Выбран режим:${themeModeMenu.text}`)
                                appWnd.darkMode = ! appWnd.darkMode

                            }
                        }
                        MenuItem {
                            icon.source: "qrc:/qt/qml/assets/images/question-mark.png"
                            text: qsTr("Справка")
                            onTriggered: {
                                console.log("Справка выбрано")
                            }
                        }
                        MenuSeparator{
                        }
                        MenuItem {
                            icon.source: "qrc:/qt/qml/assets/images/about.png"
                            //icon.color: "transparent" // Set to transparent to use original icon colors
                            text: qsTr("О программе")
                            onTriggered: console.log("О программе выбрано")
                        }
                        Component.onCompleted: {
                            console.log(`Menu.Material.listHighlightColor ${optionsMenu.Material.listHighlightColor}`)
                        }
                    }
                }
            }
    }
 topPadding: 0


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

    // BusyIndicator
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: false
        running: visible
    }

    Component.onCompleted: {
        if  (appWnd.isDebugMode){
            console.log(`[DEV.UI.Main] Info: ${buildQtVersion}`)
            console.log(`Window size: [${appWnd.width}w, ${appWnd.height}h]`)
            console.log(`screenAvailableWidth:  ${screenAvailableWidth} screenWidth:${screenWidth}`)
            console.log(`screenAvailableHeight: ${screenAvailableHeight} screenHeight:${screenHeight}`)

        }
        showAnimation.start()

    }

    //--------------------- non Visual items -------------------------------------
    SequentialAnimation {
        id: showAnimation

        PauseAnimation {
            duration: 1000
        }
        PropertyAction {
            targets: [appVerTxt]
            property: "visible"
            value: true
        }
        NumberAnimation {
            targets: [appVerTxt]
            properties: "opacity"
            from: 0
            to: 0.8
            duration: 1500
            easing.type: Easing.Linear
        }

    }
    /**
   * @brief Ключевые моменты для Qt6:
   * Аспект         Описание
   * QML_SINGLETON	Позволяет обращаться к классу как Core напрямую в QML
   * Connections	Основной способ подключения к сигналам в Qt6 QML
   * Имя функции	on<Сигнал>Changed (с заглавной буквы после on)
   * Аргументы	Принимаются в порядке, как в signals C++
   */
    Connections {
        target: Core

        function onProxyUrlListChanged() {
            console.log("Proxy URL list изменился:", Core.proxyUrlList)
            AndroidUtils.showToast(qsTr("Proxy URL list изменился!"), false)
        }

        function onShowToastMessage( message){
            AndroidUtils.showToast(message, false)
        }
    }

}

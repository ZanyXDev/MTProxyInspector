import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import io.github.zanyxdev.mtproxyinspector
import io.github.zanyxdev.mtproxyinspector.core


ApplicationWindow {
    id: appWnd

    // ----- Property Declarations
    // Required properties should be at the top.
    readonly property int screenOrientation: Qt.PortraitOrientation

    property var screenWidth: Screen.width
    property var screenHeight: Screen.height
    property var screenAvailableWidth: Screen.desktopAvailableWidth
    property var screenAvailableHeight: Screen.desktopAvailableHeight

    // Свойство для версии приложения
    property string appVersion
    property string buildQtVersion
    // Свойство-флаг для мобильной платформы
    property bool isMobile: false // Можно задать значение по умолчанию
    // Свойство-флаг для режима отладки
    property bool isDebugMode: false
    property bool isEURegion: false

    ///TODO add load/save in app Settings
    // Theme selection
    property bool darkMode: false
    property real  baseSpacing: 8
    property real  padding: 16

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

    Material.elevation : 2
    // ----- Signal declarations

    // ----- Size information
    width: (screenOrientation === Qt.PortraitOrientation) ? 360 : 640
    height: (screenOrientation === Qt.PortraitOrientation) ? 640 : 360
    maximumHeight: height
    maximumWidth: width

    minimumHeight: height
    minimumWidth: width
    // ----- Then comes the other properties. There's no predefined order to these.
    visible: true
    visibility: (isMobile) ? Window.FullScreen : Window.Windowed
    flags: Qt.Dialog

    // ----- Qt provided visual children

    header: ToolBar {
        Material.theme: appWnd.Material.theme
        Material.background: darkMode ? solarizedBase02 : solarizedBase2
        Material.foreground: darkMode ? solarizedBase0 : solarizedBase00
        Material.elevation: 2

        background:Rectangle {
            anchors{
                fill: parent
                topMargin: padding / 2
                leftMargin: padding / 2
                rightMargin: padding / 2
            }
            color: Material.backgroundColor
            radius: 8
            border.width: 0
        }
        RowLayout {
            spacing: baseSpacing
            anchors{
                fill: parent
                topMargin: padding / 2
                leftMargin: padding / 2
                rightMargin: padding / 2
            }
            Item{
                id:spacer
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Label {
                Layout.alignment: Qt.AlignCenter

                Layout.preferredHeight: 64
                Layout.leftMargin: padding
                Layout.fillWidth: true
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
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: 64
                // Иконка "три точки" (вертикальные)
                icon.name: "edit-menu"
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
                        onTriggered: console.log("Справка выбрано")
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

    ColumnLayout {
        Material.theme: appWnd.Material.theme
        Material.background: darkMode ? solarizedBase02 : solarizedBase2
        Material.foreground: darkMode ? solarizedBase0 : solarizedBase00
        Material.elevation: 2
        Material.accent: solarizedOrange
        Material.primary: solarizedYellow

        id: mainColumnLayout
        anchors{
            fill: parent
            topMargin: padding / 2
            leftMargin: padding   / 2
            rightMargin: padding  / 2
            bottomMargin: padding / 2
        }
        spacing: baseSpacing
        Pane{
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            padding: 0
            background: Rectangle {
                color: Material.backgroundColor
                radius: 8
                border.width: 0
            }
            RowLayout {
                anchors.fill: parent
                spacing: baseSpacing
                Image{
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 48
                    Layout.leftMargin: baseSpacing

                    width: 64
                    height: 48
                    source:(isEURegion) ? "qrc:/qt/qml/assets/images/flags/eu.svg": "qrc:/qt/qml/assets/images/flags/ru.svg"
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    clip:true
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 48
                    Layout.fillWidth: true
                    text: (isEURegion) ? qsTr("MTProxy регион [EU]"): qsTr("MTProxy регион [RU]")
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 16
                        bold:true
                    }

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }
                Switch{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    checked: isEURegion
                    onCheckedChanged: {
                        isEURegion = checked
                        busyIndicator.visible = true
                        Core.proxyUrlList = isEURegion ? "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/main/proxy_eu.txt" : "https://raw.githubusercontent.com/kort0881/telegram-proxy-collector/main/proxy_ru.txt"
                    }
                }
            }
        }
        Pane{
            id:paneListView
            Layout.fillWidth: true
            Layout.fillHeight: true

            padding: 0
            background: Rectangle {
                color: Material.backgroundColor
                radius: 8
                border.width: 0
            }
            ColumnLayout{
                id:mainPaneColumnLayout
                anchors.fill: parent
                spacing: baseSpacing
                ListView {
                    id: listView
                    Layout.fillWidth: true
                    Layout.fillHeight: true

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
                        radius: 8
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
                Text {
                    id:appVerTxt
                    z: 1
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom

                    opacity: 0
                    visible: false
                    text: qsTr("v.")+ appWnd.appVersion + " "
                    font{
                        family: appWnd.digitalFont.name
                        pixelSize: 12
                        bold: true
                    }
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Item{
                    Layout.fillWidth: true
                    Layout.preferredHeight: padding / 2
                }
            }
        }
        Pane{
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            padding: 0
            background: Rectangle {
                color: Material.backgroundColor
                radius: 8
                border.width: 0
            }
            RowLayout {
                anchors.fill: parent
                spacing: baseSpacing
                property bool  isOnline: false
                property string text

                Image{
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    Layout.leftMargin: baseSpacing

                    width: 48
                    height: 48
                    //source:(isOnLine) ? "qrc:/qt/qml/assets/images/online.png": "qrc:/qt/qml/assets/images/offline.png"
                    source: "qrc:/qt/qml/assets/images/online.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    clip:true
                }

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 48
                    Layout.fillWidth: true
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 16
                        bold:true
                    }
                    text: "cloud.mtproxy.pw"
                    onClicked: {
                        // Opens the URL in the system's default web browser
                        Qt.openUrlExternally("tg://proxy?server=cloud.mtproxy.pw&port=443&secret=ee3f8a91c2d7e04b6a9f12c5e8370bd4aa786170692e6f7a6f6e2e7275")
                    }
                }


                ToolButton {
                    Layout.alignment: Qt.AlignRight | Qt.AlignHCenter
                    Layout.preferredHeight: 48

                    icon.name: "add-telegram"
                    icon.source: "qrc:/qt/qml/assets/images/more_vert.png"

                    onClicked: optionsMenu.open()
                }

            }
        }
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
            duration: 2000
            easing.type: Easing.Linear
        }
        // PauseAnimation {
        //     duration: 1000
        // }
        // NumberAnimation {
        //     targets: [appVerTxt]
        //     properties: "opacity"
        //     from: 0.8
        //     to: 0
        //     duration: 2000
        //     easing.type: Easing.Linear
        // }
        // PropertyAction {
        //     targets: [appVerTxt]
        //     property: "visible"
        //     value: false
        // }

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
        }

        function onCurrentStatusChanged(success, message, errorType) {
            console.log("Статус загрузки:", success)
            console.log("Сообщение:", message)
            console.log("Тип ошибки:", errorType)

            if (!success) {
                // Показать ошибку пользователю
                console.error("Ошибка загрузки прокси:", errorType)
            }
        }
    }
}

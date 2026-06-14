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
    property bool isDebugMode: false // Можно задать значение по умолчанию

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
    readonly property color solarizedBase03: "#002b36"
    readonly property color solarizedBase02: "#073642"
    readonly property color solarizedBase01: "#586e75"
    readonly property color solarizedBase00: "#657b83"
    readonly property color solarizedBase0: "#839496"
    readonly property color solarizedBase1: "#93a1a1"
    readonly property color solarizedBase2: "#eee8d5"
    readonly property color solarizedBase3: "#fdf6e3"
    readonly property color solarizedYellow: "#b58900"
    readonly property color solarizedOrange: "#cb4b16"
    readonly property color solarizedRed: "#dc322f"
    readonly property color solarizedMagenta: "#d33682"
    readonly property color solarizedViolet: "#6c71c4"
    readonly property color solarizedBlue: "#268bd2"
    readonly property color solarizedCyan: "#2aa198"
    readonly property color solarizedGreen: "#859900"

    // Theme selection
    property bool darkMode: false

    Material.theme: darkMode ? Material.Dark : Material.Light
    Material.accent: solarizedCyan
    Material.primary: solarizedBlue

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
        Material.background: darkMode ? solarizedBase03 : solarizedBase2
        Material.foreground: darkMode ? solarizedBase2 : solarizedBase02
        Material.elevation: 2
        background:Rectangle {
            anchors.fill: parent
            anchors.margins:  appWnd.padding / 2
            color: Material.backgroundColor
            radius: 8
            border.width: 0
        }
        RowLayout {
            ToolButton {
                text: "☰"
                font{
                    family: appWnd.droidFont.name
                    pixelSize: 18
                }
                onClicked: drawer.open()
            }
            Label {
                text: qsTr("MTProxy для Телеграм")
                font{
                    family: appWnd.droidFont.name
                    pixelSize: 18
                }
                Layout.fillWidth: true
            }
        }
    }
    Drawer {
        id: drawer
        width: (screenOrientation === Qt.PortraitOrientation) ? Math.min(appWnd.width * 0.7, 300) : Math.min(appWnd.width * 0.7, 600)
        height: appWnd.height
        interactive: true
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: appWnd.padding
            spacing: 2
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                spacing: 2
                Image {
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 64
                    source: "qrc:/qt/qml/assets/images/ic_launcher-playstore.png"
                    width: 64
                    height: 64
                    sourceSize.width: 64
                    sourceSize.height: 64
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Label {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Тестер MTProxy")
                    font{
                        family: appWnd.droidFont.name
                        pixelSize: 18
                    }
                    color: darkMode ? solarizedBase2 : solarizedBase02
                }
            }
            Rectangle {
                Layout.preferredWidth: parent.width *0.9
                Layout.preferredHeight: 1
                Layout.alignment: Qt.AlignHCenter
                color: darkMode ? solarizedBase01 : solarizedBase1
            }
            Switch{
                id: themeSwitch
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                text: darkMode ? qsTr("Dark") : qsTr("Light")
                checked: darkMode
                onCheckedChanged: darkMode = checked
            }
        }

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }


ColumnLayout {
    id: mainColumnLayout
    anchors.fill: parent
    spacing: 0

    // ─── ОТСТУП СВЕРХУ (48dp) ──────────────────────
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: appWnd.padding * 3
    }
    Text {

        text: qsTr("Прокси для Телеграм")
        font{
            family: appWnd.buiraFont.name
            pixelSize: 28
            bold: true
        }

        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: appWnd.padding
    }
    MButton {
        id: btnHelp
        text: qsTr("Справка")

        //borderColor:appWnd.textColorSecondary

        font{
            family: appWnd.droidFont.name
            pixelSize: 16
        }

        Layout.preferredHeight: 40
        Layout.preferredWidth: 80
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: appWnd.padding * 2

        // Сигнал для обработки (подключить в C++ или JS)
        onClicked: {
            console.log(`btnHelp.clicked()`)
        }
    }
    // ─── КНОПКИ РЕГИОНОВ (горизонтальный ряд) ─────
    RowLayout {
        Layout.fillWidth: true
        Layout.bottomMargin: 24
        spacing: 8

        // 🇪🇺 Европа
        MButton {
            id: btnEurope
            text: "Европа"
            font{
                family: appWnd.droidFont.name
                pixelSize: 18
                bold:true
            }
            Layout.fillWidth: true
            Layout.preferredHeight: 60


            onClicked: {
                console.log(`btnEurope.clicked()`)
            }
        }
    }

    Text {
        id:appVerTxt
        z: 1
        opacity: 0
        visible: false
        text: qsTr("v. ")+ appWnd.appVersion
        font{
            family: appWnd.digitalFont.name
            pixelSize: 12
            bold: true
        }

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        Layout.alignment: Qt.AlignRight
        Layout.rightMargin: appWnd.padding
    }
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
}
}

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

    Material.background: darkMode ? solarizedBase00 : solarizedBase0
    Material.foreground: darkMode ? solarizedBase0 : solarizedBase00

    header: ToolBar {
        Material.background: darkMode ? solarizedBase02 : solarizedBase2
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
            anchors.fill: parent
            Label {

                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: appWnd.padding
                Layout.preferredHeight: 64
                Layout.fillWidth: true
                text: qsTr("Тестер MTProxy для Телеграм")
                font{
                    family: appWnd.droidFont.name
                    pixelSize: 18
                    bold:true
                }

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
            ToolButton {
                // Иконка "три точки" (вертикальные)
                icon.name: "edit-menu"
                icon.source: "qrc:/qt/qml/assets/images/more_vert.png"

                onClicked: optionsMenu.open()

                Menu {
                    Material.background: darkMode ? solarizedBase02 : solarizedBase2
                    Material.foreground: darkMode ? solarizedBase2 : solarizedBase02

                    id: optionsMenu
                    y: parent.height

                    MenuItem {
                        icon.source: "qrc:/qt/qml/assets/images/settings.png"
                        text: qsTr("Настройки")
                        onTriggered: console.log("Настройки выбраны")
                    }
                    MenuItem {
                        id:themeModeMenu
                        icon.source: (appWnd.darkMode) ? "qrc:/qt/qml/assets/images/moon.png" : "qrc:/qt/qml/assets/images/sun.png"
                        text:(appWnd.darkMode) ? qsTr("Ночной"): qsTr("Дневной")
                        onTriggered: {
                            appWnd.darkMode = ! appWnd.darkMode
                            console.log(`Выбран режим:${themeModeMenu.text}`)
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
                }
            }
        }
    }

    ColumnLayout {
        id: mainColumnLayout
        anchors.fill: parent
        spacing: 0
    }


    ColumnLayout {
        id: mainColumnLayout2
        anchors.fill: parent
        spacing: 0
        visible: false
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

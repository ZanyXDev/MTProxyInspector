import QtQuick
import QtQuick.Controls
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

    // === Глобальные стили (легко менять в одном месте) ===
    property color textColorPrimary: "black"
    property color textColorSecondary: "darkgrey"
    property color buttonHelpBg: "lightgrey"
    property color buttonBorder: "lightgrey"
    property color bgrColor: "lightblue"
    property real  baseSpacing: 8
    property real  padding: 16

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

    title: qsTr("Проверка MTProxy для Телеграм")

    // ----- Qt provided visual children
    background: Rectangle {
        id: background
        anchors.fill: parent
        color: bgrColor
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
            color: appWnd.textColorPrimary
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: appWnd.padding
        }
        MButton {
            id: btnHelp
            text: qsTr("Справка")
            bgrColor: "lightblue" //appWnd.textColorPrimary
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
                bgrColor: "transparent"

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
            color: appWnd.textColorPrimary
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

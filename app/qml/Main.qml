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
    flags: Qt.Window | Qt.ExpandedClientAreaHint | Qt.NoTitleBarBackgroundHint
    // ----- Qt provided visual children


    header: ToolBar{
        background: Rectangle {
            //компонент ToolBar принудительно устанавливает свой собственный цвет фона равным Material.primary.
            // поэтому переопределяем его
            color: appWnd.Material.background
            opacity: 0.7
        }
        RowLayout {
            spacing: appWnd.baseSpacing
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
        Component.onCompleted: {
            console.log(`ToolBar.background.rectangle.color:${Material.backgroundColor}`)
        }
    }
    topPadding: 0
    footer: NavigationPane{

        // Явно задаем цвет фона окна, чтобы избежать дефолтного поведения Material
        Material.background: appWnd.Material.background

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

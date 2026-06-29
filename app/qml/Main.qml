#pragma ComponentBehavior: Bound

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
    //property bool isConnected: Core.onlineState
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

    property bool isDark: true

    ///TODO add load/save in app Settings
    // Theme selection
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

    property string sourceTitle:qsTr("Не выбран")

    // -------------------- Глобальные стиль --------------------------------
    // Синхронизируем фон окна с Material.background
    color: Material.background

    // 🔹 Базовая тема Material (влияет на ripple, скругления, тени, default-цвета)
    Material.theme: isDark ? Material.Dark : Material.Light

    // 🔹 Solarized цвета через Material attached properties
    Material.background: isDark ? "#002b36" : "#fdf6e3" // base03 / base3
    Material.foreground: isDark ? "#839496" : "#657b83" // base0  / base00
    Material.primary:    isDark ? "#2aa198" : "#268bd2" // cyan   / blue
    Material.accent:     isDark ? "#cb4b16" : "#dc322f" // orange / red

    readonly property color solarizedYellow: "#b58900"
    readonly property color solarizedOrange: "#cb4b16"
    readonly property color solarizedRed: "#dc322f"
    readonly property color solarizedMagenta: "#d33682"
    readonly property color solarizedViolet: "#6c71c4"
    readonly property color solarizedBlue: "#268bd2"
    readonly property color solarizedCyan: "#2aa198"
    readonly property color solarizedGreen: "#859900"


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
        // 0..6 (рекомендуется 2..4 для футеров)
        Material.elevation: 3

        // Явный фон обязателен для корректной отрисовки тени
        Material.background: appWnd.Material.background

        // Чтобы левая/правая тень не обрезалась краями окна
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        opacity: 0.7
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
                        icon.source: "qrc:/qt/qml/assets/images/link.png"
                        text: qsTr("Адреса источников")
                        onTriggered: console.log("Адреса источников выбраны")
                    }
                    MenuItem {
                        icon.source: "qrc:/qt/qml/assets/images/settings.png"
                        text: qsTr("Настройки")
                        onTriggered: console.log("Настройки выбраны")
                    }
                    MenuItem {
                        id:themeModeMenu
                        icon.source: (appWnd.isDark) ?  "qrc:/qt/qml/assets/images/sun.png" :"qrc:/qt/qml/assets/images/moon.png"
                        text:(appWnd.isDark) ? qsTr("Дневной") :qsTr("Ночной")
                        onTriggered: {

                            console.log(`Выбран режим:${themeModeMenu.text}`)
                            appWnd.isDark = ! appWnd.isDark

                        }
                    }
                    MenuSeparator{
                    }
                    MenuItem {
                        icon.source: "qrc:/qt/qml/assets/images/question-mark.png"
                        text: qsTr("Справка")
                        onTriggered: {
                            console.log("Справка выбрано")
                        }
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
    ListView {
        id: listView
        spacing: 16
        anchors.fill: parent
        // Тестовая модель
        model: ListModel {
            ListElement {
                domainName: "api.production.example.com";
                ping:200;
                mtype:1;
                port:443;
                isFavorite:false;
                secret:"ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d"
            }
            ListElement {
                domainName: "db.replica-01.internal";
                ping:200;
                mtype:2;
                port:443;
                isFavorite:false;
                secret:"ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d"
            }
            ListElement {
                domainName: "auth.staging.example.com";
                ping:70;
                mtype:99;
                port:443;
                isFavorite:false;
                secret:"ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d"
            }
            ListElement {
                domainName: "api.production.test.com";
                ping:200;
                mtype:2;
                port:443;
                isFavorite:true;
                secret:"ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d"
            }
            ListElement {
                domainName: "db.replica-01.ru";
                ping:25;
                port:443;
                mtype:3;
                isFavorite:false;
                secret:"ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d"
            }
            ListElement {
                domainName: "auth.long-long-long-long-name.me.com";
                ping:200;
                mtype:3;
                port:443;
                isFavorite:false;
                secret:"ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d"
            }
        }

        delegate:MDelegate{
            required property int index
            Material.elevation: 2
            // Явный фон обязателен для корректной отрисовки тени
            Material.background: appWnd.Material.background
            themeRed:appWnd.solarizedRed
            themeGreen:appWnd.solarizedGreen
            width: listView.width -16

            font.family: appWnd.droidFont.name
            //tg://proxy?server=87.248.129.102&port=8443&secret=ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d

        }

        leftMargin: 8
        topMargin: SafeArea.margins.top

        onDragStarted: {
            console.log("onDragStarted called");
            busyIndicator.visible = true
        }
        onDragEnded:{
            console.log("onDragEnded called");
            busyIndicator.visible = false
        }

        onTopMarginChanged: {

            // Keep content position stable
            if (!dragging && atYBeginning)
                contentY = -topMargin
        }

    }
    // BusyIndicator
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: false
        running: visible
    }


    RoundButton{
        implicitWidth: 56
        implicitHeight: 56
        icon.source:  "qrc:/qt/qml/assets/images/cloud-refresh.png"
        //icon.color:"transparent"
        anchors{
            bottom: parent.bottom
            right: parent.right
            margins: 16
        }
        Material.elevation: 4
    }
    footer: ToolBar{
        id:footterToolBar
        // 0..6 (рекомендуется 2..4 для футеров)
        Material.elevation: 3

        // Явный фон обязателен для корректной отрисовки тени
        Material.background: appWnd.Material.background

        // Чтобы левая/правая тень не обрезалась краями окна
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        opacity: 0.7
        RowLayout {
            spacing: 0
            anchors{
                fill: parent
            }
            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Label {
                id:appVerTxt
                z: 1
                Layout.alignment: Qt.AlignRight

                opacity:0

                text: qsTr("v.")+ appWnd.appVersion + " "
                font{
                    family: appWnd.digitalFont.name
                    pixelSize: 11
                    bold: true
                }
                verticalAlignment: Text.AlignVCenter |Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
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
        NumberAnimation {
            targets: [appVerTxt]
            properties: "opacity"
            from: 0
            to: 0.8
            duration: 1500
            easing.type: Easing.OutBounce
        }

        PauseAnimation {
            duration: 1000
        }
        NumberAnimation {
            targets: [footterToolBar]
            properties: "opacity"
            from: 0.7
            to: 0.4
            duration: 1500
            easing.type: Easing.OutBounce
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

        // function onProxyUrlListChanged() {
        //     console.log("Proxy URL list изменился:", Core.proxyUrlList)
        //     AndroidUtils.showToast(qsTr("Proxy URL list изменился!"), false)
        // }

        function onShowToastMessage( message){
            AndroidUtils.showToast(message, false)
        }
    }

}

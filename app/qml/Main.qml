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
    // property bool internetConnectivity: Core.internetConnectivity
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
    property bool isDebugMode

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
    Material.background: isDark ? MColors.solarizedBase03 : MColors.solarizedBase3
    Material.foreground: isDark ? MColors.solarizedBase0 : MColors.solarizedBase00
    Material.primary:    isDark ? MColors.solarizedCyan : MColors.solarizedBlue
    Material.accent:     isDark ? MColors.solarizedOrange : MColors.solarizedRed

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

        model:AppController.servers

        delegate:MDelegate{
            required property int index
            themeRed:MColors.solarizedRed
            themeGreen:MColors.solarizedGreen
            fontFamily: droidFont.name
            width: ListView.view.width - 16
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
        id:fabButton
        implicitWidth: 56
        implicitHeight: 56
        icon.source:  "qrc:/qt/qml/assets/images/cloud-refresh.png"
        icon.height:24
        icon.width: 24
        //icon.color:"transparent"
        anchors{
            bottom: parent.bottom
            right: parent.right
            margins: 16
        }
        Material.elevation: fabButton.down ? 6 : 2
        // При нажатии открываем меню со списком
        onClicked: {
            console.log(`proxyMenu.open()`)
            proxyMenu.open()
        }
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
        AppController.initialize()
    }

    //--------------------- non Visual items -------------------------------------
    Menu {
        id: proxyMenu
        x: fabButton.x - width + fabButton.width
        y: fabButton.y - height - 8
        width: 220
        height: Math.min(implicitContentHeight, 300)

        Instantiator {
            model: AppController.sourceLinksModel
            onObjectAdded: (index, object) => proxyMenu.insertItem(index, object)
            onObjectRemoved: (index, object) => proxyMenu.removeItem(object)
            delegate: MenuItem {
                required property var model
                width: parent.width
                text: model.title
                checkable: true
                checked: model.selected
                onTriggered: {
                    model.selected = checked
                }
            }
        }    
    }
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
   * QML_SINGLETON	Позволяет обращаться к классу как AppController напрямую в QML
   * Connections	Основной способ подключения к сигналам в Qt6 QML
   * Имя функции	on<Сигнал>Changed (с заглавной буквы после on)
   * Аргументы	Принимаются в порядке, как в signals C++
   */
    Connections {
        target: AppController
        Component.onCompleted: console.log("Connections to AppController established")
        // function onProxyUrlListChanged() {
        //     console.log("Proxy URL list изменился:", Core.proxyUrlList)
        //     AndroidUtils.showToast(qsTr("Proxy URL list изменился!"), false)
        // }

        function onProxyListChanged(srvCount:int){
            console.log(`recive onProxyListChanged:${srvCount}`);

        }
        function onShowToastMessage( message:string ){
            console.log("recive onShowToastMessage:")
            AndroidUtils.showToast(message, false)
        }
    }
    Connections {
        target: Qt.application
        function onStateChanged(state) {
            if (state === Qt.ApplicationSuspended) {
                console.log(`Current application state ${state}`);
                AppController.saveSetting();
            }
        }
    }
}

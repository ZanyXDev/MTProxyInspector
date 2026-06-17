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
    property real  baseSpacing: 8
    property real  padding: 16
    property real  m_radius: 12


    // -------------------- Глобальные стиль --------------------------------

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
    title: qsTr("Safe Area")

    // ----- Qt provided visual children
    header: ToolBar {
        background: Rectangle {
            gradient: Gradient.PremiumDark
            opacity: 0.7
        }
        RowLayout {
            anchors.fill: parent
            Text {
                text: "🎾 Throw Ball"; color: "white"; font.pointSize: 18
                Layout.margins: 10
            }
            Text {
                text: "Give Bone 🦴"; color: "white"; font.pointSize: 18
                Layout.alignment: Qt.AlignRight; Layout.margins: 10
            }
        }
    }
    topPadding: 0


    // Синхронизируем фон окна с Material.background
    color: Material.background

    property bool isDark: true

    // 🔹 Базовая тема Material (влияет на ripple, скругления, тени, default-цвета)
    Material.theme: isDark ? Material.Dark : Material.Light

    // 🔹 Solarized цвета через Material attached properties
    Material.background: isDark ? "#002b36" : "#fdf6e3" // base03 / base3
    Material.foreground: isDark ? "#839496" : "#657b83" // base0  / base00
    Material.primary:    isDark ? "#2aa198" : "#268bd2" // cyan   / blue
    Material.accent:     isDark ? "#cb4b16" : "#dc322f" // orange / red

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 16

        Switch {
            text: isDark ? "Solarized Dark" : "Solarized Light"
            checked: isDark
            onToggled: appWnd.isDark = checked
        }

        TextField {
            placeholderText: "Foreground & background наследуются автоматически"
            Layout.fillWidth: true
        }

        RowLayout {
            Button {
                text: "Primary"
                highlighted: true
                // В Material highlighted Button берет Material.primary
            }
            Button {
                text: "Accent"
                // Accent-кнопки в Material стиле используют Material.accent
            }
            Item { Layout.fillWidth: true }
        }

        Pane {
            Layout.fillWidth: true; Layout.fillHeight: true
            Material.elevation: 3
            Material.background: appWnd.Material.background // Явное указание для Pane

            Label {
                anchors.centerIn: parent
                text: "Pane with elevation 3\nText uses Material.foreground"
                color: Material.foreground
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    footer:  Pane {
        id: myPane

        Material.elevation: 16
        Material.background: "red" // Or any solid color/theme-defined color
    }

    // ListView {
    //     id: listView
    //     anchors.fill: parent
    //     model: 10
    //     delegate: Image {
    //         required property int index
    //         width: listView.width; height: 250
    //         source: "https://loremflickr.com/320/240?lock=" + (index + 1)
    //     }

    //     topMargin: SafeArea.margins.top

    //     onTopMarginChanged: {
    //         // Keep content position stable
    //         if (!dragging && atYBeginning)
    //             contentY = -topMargin
    //     }
    // }

    Component.onCompleted: {
        console.log(`appWnd: [${appWnd.width}w,${appWnd.height}h]`)
        console.log(`listView: [${listView.width}w,${listView.height}h]`)
        console.log(`screenWidth: ${screenWidth} screenHeight: ${screenHeight}`)

        console.log(`screenWidth: ${screenWidth} screenHeight: ${screenHeight}`)
        console.log(`screenAvailableWidth: ${screenAvailableWidth} screenAvailableHeight:${screenAvailableHeight}`)

        // Логируем SafeArea, чтобы убедиться, что Android вернул отступы для закруглений
        console.log(`SafeArea Top: ${appWnd.SafeArea.margins.top}, Bottom: ${appWnd.SafeArea.margins.bottom}`)
        console.log(`SafeArea Left: ${appWnd.SafeArea.margins.left}, Right: ${appWnd.SafeArea.margins.right}`)
    }
}

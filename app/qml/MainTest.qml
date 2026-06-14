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


    // Material Configuration for Solarized
    Material.theme: Material.Light // Or Material.Dark
    Material.primary: "#fdf6e3"    // Base3 (Background)
    Material.accent: "#268bd2"     // Blue (Buttons, switches)
    Material.foreground: "#586e75" // Base0 (Text, icons)

    // Override background color for native QML components
    color: "#fdf6e3"

    Pane {
        id: root
        Material.background: appWnd.Material.background
        width: parent.width -10
        height:96
        padding: 0
        topPadding: 0
        bottomPadding: 0
        Material.elevation: 8 // Добавляем тень сверху, как в Material Design
        background: Rectangle {
            id:bgrRect
            color: Material.backgroundColor

            border.width: 1
            border.color: Material.frameColor
        }
        // Контейнер для кнопок
        Button {
            text: "Solarized Action"
            anchors.centerIn: parent

            // Elevation example
            Material.elevation: 6
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

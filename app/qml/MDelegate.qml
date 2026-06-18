import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Layouts

ItemDelegate {
    id:root
    // Строгая типизация данных из C++ модели (Qt 6 best practice)
    required property string domainName
    required property int ping
    required property int port
    required property bool isFavorite
    property color themeRed: Material.color(Material.Red, Material.Shade800)
    property color themeGreen: Material.color(Material.Green, Material.Shade800)

    // Тень меняется при нажатии (эффект "поднятия" карточки)
    Material.elevation: root.down ? 6 : 2

    Material.roundedScale: Material.MediumScale
    contentItem: ColumnLayout {
        spacing: 8
        anchors.fill: parent
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }
        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16

            text: root.domainName
            font.family: root.font.family
            font.pixelSize: 18
            color: root.Material.primaryTextColor
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            spacing: 8

            Label {
                Layout.preferredWidth:  48
                Layout.fillHeight: true

                text: root.ping+qsTr(" мс")
                font.family: root.font.family
                font.pixelSize: 18
                color: (root.ping < 100) ? root.themeGreen : root.themeRed
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Rectangle{
                Layout.preferredWidth:  32
                Layout.fillHeight: true
                color:"green"
            }

        }
        Frame{
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.fillWidth: true
            Layout.preferredHeight: 2
        }
        RowLayout{
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            spacing: 8
            Item{
                Layout.fillWidth: true
            }
            RoundButton{
                Layout.alignment: Qt.AlignRight
                implicitWidth: 32
                implicitHeight: 32
                icon.source:  "qrc:/qt/qml/assets/images/cloud-refresh.png"
                Material.elevation: 4
            }
        }
        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }
    }
    background: Rectangle {
        implicitHeight: root.Material.delegateHeight
        color: root.Material.background
        clip:true
        layer.enabled: root.Material.elevation > 0
        layer.smooth: true
        layer.effect: ElevationEffect {
            elevation: root.Material.elevation
            fullWidth: true

        }
        radius: 12
        Ripple {
            width: parent.width
            height: parent.height

            clip: true
             clipRadius: parent.radius
            pressed: root.pressed
            anchor: root
            active: enabled && (root.down || root.visualFocus || root.hovered)
            color: root.Material.rippleColor
        }
    }

}

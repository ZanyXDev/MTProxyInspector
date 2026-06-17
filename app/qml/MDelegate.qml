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
        spacing: 0
        anchors.fill: parent
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
            Label {
                Layout.preferredWidth:  32
                Layout.preferredHeight: 24

                text: root.ping+qsTr(" мс")
                font.family: root.font.family
                font.pixelSize: 18
                color: (root.ping < 100) ? root.themeGreen
                                         : root.themeRed


                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }


        }
    }

    background: Rectangle {

        implicitHeight: root.Material.delegateHeight
        color: root.Material.background

        layer.enabled: root.Material.elevation > 0
        layer.effect: ElevationEffect {
            elevation: root.Material.elevation
            fullWidth: true
        }
        radius: 12
        Ripple {
            width: parent.width
            height: parent.height

            clip: visible
            pressed: root.pressed
            anchor: root
            active: enabled && (root.down || root.visualFocus || root.hovered)
            color: root.Material.rippleColor
        }
    }
}

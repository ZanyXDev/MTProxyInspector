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
    required property int mtype
    required property bool isFavorite
    required property string secret
    property color themeRed: Material.color(Material.Red, Material.Shade800)
    property color themeGreen: Material.color(Material.Green, Material.Shade800)
    //tg://proxy?server=87.248.129.102&port=8443&secret=ee1603010200010001fc030386e24c3add626973636f7474692e79656b74616e65742e636f6d

    property string tgUrl:"tg://proxy?server="+domainName+"&port="+port+"&secret="+secret
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
            spacing: 16
            Item{
                Layout.preferredWidth: 16
            }
            Label {
                Layout.preferredWidth:  48
                Layout.fillHeight: true

                text: root.ping+qsTr("мс")
                font.family: root.font.family
                font.pixelSize: 18
                color: (root.ping < 100) ? root.themeGreen : root.themeRed
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.preferredWidth:  48
                Layout.fillHeight: true

                text: root.port
                font.family: root.font.family
                font.pixelSize: 18

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                Layout.preferredWidth:  48
                Layout.fillHeight: true

                text: root.getProxyType(root.mtype)
                font.family: root.font.family
                font.pixelSize: 18

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Item{
                Layout.fillWidth: true
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
            Layout.preferredHeight: 42
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            spacing: 8

            RoundButton{
                Layout.alignment: Qt.AlignRight
                implicitWidth: 42
                implicitHeight: 42
                icon.source:  "qrc:/qt/qml/assets/images/like.png"
                icon.color:(root.isFavorite) ? Material.accentColor : Material.iconDisabledColor
                Material.elevation: 4
                onClicked: {
                    root.isFavorite =!root.isFavorite
                }
            }
            RoundButton{
                Layout.alignment: Qt.AlignRight
                implicitWidth: 42
                implicitHeight: 42
                icon.source:  "qrc:/qt/qml/assets/images/share.png"
                icon.color:(root.ping < 100) ? root.themeGreen : root.themeRed
                Material.elevation: 4
                onClicked: {
                    Qt.openUrlExternally(root.tgUrl)
                }

            }
            Item{
                Layout.fillWidth: true
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

    function getProxyType( index ){
        if (index === 1) return qsTr("Socks5")
        if (index === 2) return qsTr("Padding")
        if (index === 3) return qsTr("FakeTls")
        return qsTr("Unknow")
    }
}

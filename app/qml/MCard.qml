import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
    id: root
    property string title: ""
    property string subtitle: ""
    property real  baseSize: 16
    property alias contentItemData: contentColumn.data

    Material.elevation: 2
    padding: 0
    background: Rectangle {
        color: Material.backgroundColor
        radius: 8
        border.width: 0
    }
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: contentColumn
                anchors.fill: parent
                anchors.margins: baseSize
                spacing: baseSize / 2
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: title !== "" || subtitle !== "" ? 56 : 0
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: baseSize
                spacing: 2

                Label {
                    text: root.title
                    font.pixelSize:baseSize
                    font.bold: true
                    visible: text !== ""
                }

                Label {
                    text: root.subtitle
                    font.pixelSize: baseSize - 4
                    opacity: 0.7
                    visible: text !== ""
                }
            }
        }
    }
}

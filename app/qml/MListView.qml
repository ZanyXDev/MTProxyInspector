import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Controls.Material

ListView{
    id: root
    Material.background: darkMode ? solarizedBase03 : solarizedBase3
    Material.foreground: darkMode ? solarizedBase0 : solarizedBase00

    highlight: Rectangle {
        color: darkMode ? solarizedBase2 : solarizedBase02
        //color: Material.color(Material.foreground, Material.Shade200)
        radius: 5
        opacity: 0.7
        border.color:"red"
        border.width: 3

        // Анимация перемещения подсветки
        Behavior on y {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
    // Подсветка при наведении мыши
    //hoverEnabled: true
    ScrollIndicator.vertical: ScrollIndicator { }
    Component.onCompleted: {
        console.log(`highlight ${root.highlight}`)
    }
}
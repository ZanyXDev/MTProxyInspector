import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Controls.Material

Button {
    id:root
    property bool effectsOn: false
    property real antimationTime: 200



    state: pressed ? "buttonDown" : "buttonUp"

    // 1. Invisible source item (the background shape)
    background: Rectangle {
        id: buttonBackground
        width: root.width
        height: root.height

        border.width: 2
        radius: 8
        visible: false // Source must be hidden so it renders only as an effect
    }
    // 2. MultiEffect overlay rendering the shadow and background color
    MultiEffect {

        source: buttonBackground
        anchors.fill: buttonBackground
        autoPaddingEnabled: true

        shadowEnabled: true
        shadowColor: Material.accent
        shadowBlur: 1.0
        shadowHorizontalOffset: 2
        shadowVerticalOffset: 6

        // Adjust appearance dynamically when the button is pressed
        opacity: root.pressed ? 0.8 : 1.0
    }
    states: [
        State {
            name: "buttonDown"
            PropertyChanges {
                target: root
                scale: 0.7
            }
        },
        State {
            name: "buttonUp"
            PropertyChanges {
                target: root
                scale: 1.0
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: scale
            easing.type: Easing.InOutQuad
            duration: root.antimationTime
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: root.antimationTime
            easing.type: Easing.OutQuad
        }
    }

}
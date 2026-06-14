import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

T.ItemDelegate {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: 16
    verticalPadding: 8
    spacing: 16

    icon.width: 24
    icon.height: 24

    contentItem: IconLabel {
        spacing: root.spacing
        mirrored: root.mirrored
        display: root.display
        alignment: root.display === IconLabel.IconOnly || root.display === IconLabel.TextUnderIcon ? Qt.AlignCenter : Qt.AlignLeft

        icon: root.icon
        defaultIconColor: root.enabled ? root.Material.foreground : root.Material.hintTextColor
        text: root.text
        font: root.font
        color: defaultIconColor
    }

    background: Rectangle {
        implicitHeight: root.Material.delegateHeight
        color: "transparent"
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

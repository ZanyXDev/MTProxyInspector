import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
  id: root
  property alias radius: bgrRect.radius

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
  RowLayout {
    anchors.fill: parent
    spacing: 0 // Убираем отступы между кнопками, они займут всю ширину

    // 1. Россия
    ToolButton {
      Layout.fillWidth: true
      Layout.fillHeight: true
      display: AbstractButton.TextUnderIcon // Иконка сверху, текст снизу

      text: qsTr("Россия")
      icon.source: "qrc:/qt/qml/assets/images/flag_ru.png"
      icon.color: "transparent" // Важно для цветных иконок (флагов), чтобы не перекрашивались темой
      icon.width: 28
      icon.height: 28

      //font.family: appWnd.droidFont.name
      font.pixelSize: 12
      //Material.foreground: appWnd.Material.foreground

      onClicked: {
        console.log("Фильтр: Россия")
        // Вызов метода из Core для фильтрации прокси
      }
    }
  }
}
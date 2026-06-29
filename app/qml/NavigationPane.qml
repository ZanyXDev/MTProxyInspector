import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
  id: root

  width: parent.width
  height: 72
  opacity: 0.7
  // 0..6 (рекомендуется 2..4 для футеров)
  Material.elevation: 3

  // Явный фон обязателен для корректной отрисовки тени
  Material.background: appWnd.Material.background

  // Чтобы левая/правая тень не обрезалась краями окна
  anchors.leftMargin: 0
  anchors.rightMargin: 0

  RowLayout {
    anchors.fill: parent
    spacing: 0 // Убираем отступы между кнопками, они займут всю ширину
    Item { Layout.fillWidth: true }
    ToolButton {

      Layout.fillHeight: true

      flat: true
      display: AbstractButton.TextUnderIcon // Иконка сверху, текст снизу

      text: qsTr("Избранное")
      icon.source: "qrc:/qt/qml/assets/images/about.png"
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

    ToolButton {
      Layout.fillHeight: true
      flat: true
      display: AbstractButton.TextUnderIcon // Иконка сверху, текст снизу

      text: qsTr("Россия")
      icon.source: "qrc:/qt/qml/assets/images/flags/ru.svg"
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

    ToolButton {
      Layout.fillHeight: true
      display: AbstractButton.TextUnderIcon // Иконка сверху, текст снизу

      text: qsTr("Европа")
      icon.source: "qrc:/qt/qml/assets/images/flags/eu.svg"
     icon.color: "transparent" // Важно для цветных иконок (флагов), чтобы не перекрашивались темой
      icon.width: 28
      icon.height: 28

      //font.family: appWnd.droidFont.name
      font.pixelSize: 12
      //Material.foreground: appWnd.Material.foreground

      onClicked: {
        console.log("Фильтр: Europe")
        // Вызов метода из Core для фильтрации прокси
      }
    }
    ToolButton {
      Layout.fillHeight: true
      flat: true
      display: AbstractButton.TextUnderIcon // Иконка сверху, текст снизу

      text: qsTr("Все")
      icon.source: "qrc:/qt/qml/assets/images/cloud-refresh.png"
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
    ToolButton {
      Layout.fillHeight: true
      flat: true
      display: AbstractButton.TextUnderIcon // Иконка сверху, текст снизу

      text: qsTr("Настройки")
      icon.source: "qrc:/qt/qml/assets/images/settings.png"
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


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item{
    id:root

    property url frontImageSource
    property url backImageSource
    property bool showEmptyCard: false  // Игрок выбрал правильную пару карт, скрываем
    property bool useShader: false      // по умолчанию не используем шейдер
    signal clicked

    // угол поворота (0..180)

    Loader {
        id: loader
        anchors.fill: parent

        source: (root.useShader ? "ShaderFlip.qml" : "SimpleFlip.qml")
        // ✅ Передаем свойства сразу при создании элемента
        onItemChanged: {
            if (item) {
                item.frontImageSource = root.frontImageSource
                item.backImageSource  = root.backImageSource
                item.showEmptyCard    = root.showEmptyCard
                if (appWnd.isDebugModeOFF){
                    // ✅ Проверяем размеры ПОСЛЕ завершения компоновки
                    Qt.callLater(function() {
                        console.log(`[UI.DEBUG] MemoCard.qml POST-LAYOUT: ` +
                                    `loader: ${loader.width}×${loader.height}, ` +
                                    `item: ${item.width}×${item.height}`)
                    })
                }
            }
        }
    }

    MouseArea {
        ///TODO Добавить ховер и другие варианты
        id:mArea
        anchors.fill: parent
        enabled: (loader.item) && ( !loader.item.isFlippingBack) // Блокируем клик во время авто-возврата
        onClicked: {
            if (loader.item){
                if (! loader.item.showEmptyCard){
                    root.clicked()
                    loader.item.toggleFlip()
                    //autoHideDebugTimer.start()
                }
            }
        }
    }
    Timer {
        id: autoHideDebugTimer
        interval: 600
        running: false
        repeat: false
        triggeredOnStart: false

        onTriggered: {
            if (loader.item){
                loader.item.showEmptyCard = true
            }
        }
    }
}

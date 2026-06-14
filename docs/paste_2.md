    // ... ваш существующий код ...

    footer: Pane {
        id: navBar
        padding: 0
        topPadding: 0
        bottomPadding: 0
        
        // Явно задаем цвет фона окна, чтобы избежать дефолтного поведения Material
        Material.background: appWnd.Material.background 
        Material.elevation: 8 // Добавляем тень сверху, как в Material Design
        
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
                
                font.family: appWnd.droidFont.name
                font.pixelSize: 12
                Material.foreground: appWnd.Material.foreground

                onClicked: {
                    console.log("Фильтр: Россия")
                    // Вызов метода из Core для фильтрации прокси
                }
            }

            // 2. Европа
            ToolButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                display: AbstractButton.TextUnderIcon
                
                text: qsTr("Европа")
                icon.source: "qrc:/qt/qml/assets/images/flag_eu.png"
                icon.color: "transparent" 
                icon.width: 28
                icon.height: 28
                
                font.family: appWnd.droidFont.name
                font.pixelSize: 12
                Material.foreground: appWnd.Material.foreground

                onClicked: console.log("Фильтр: Европа")
            }

            // 3. Все (Мир)
            ToolButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                display: AbstractButton.TextUnderIcon
                
                text: qsTr("Все")
                icon.source: "qrc:/qt/qml/assets/images/globe.png"
                // Если иконка монохромная (черно-белая), закомментируйте строку ниже, 
                // чтобы она красилась в цвет темы (Material.foreground)
                icon.color: "transparent" 
                icon.width: 28
                icon.height: 28
                
                font.family: appWnd.droidFont.name
                font.pixelSize: 12
                Material.foreground: appWnd.Material.foreground

                onClicked: console.log("Фильтр: Все")
            }

            // 4. Избранное (Сердечко)
            ToolButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                display: AbstractButton.TextUnderIcon
                
                text: qsTr("Избранное")
                icon.source: "qrc:/qt/qml/assets/images/heart.png"
                icon.color: "transparent" // Или solarizedRed, если хотите красное сердечко
                icon.width: 28
                icon.height: 28
                
                font.family: appWnd.droidFont.name
                font.pixelSize: 12
                Material.foreground: appWnd.Material.foreground

                onClicked: console.log("Фильтр: Избранное")
            }

            // 5. Перезагрузка
            ToolButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                display: AbstractButton.TextUnderIcon
                
                text: qsTr("Обновить") // "Перезагрузка" может быть длинно, "Обновить" компактнее
                icon.source: "qrc:/qt/qml/assets/images/reload.png"
                // Для монохромной иконки лучше не ставить transparent, 
                // тогда она будет автоматически менять цвет при смене темы
                icon.width: 26
                icon.height: 26
                
                font.family: appWnd.droidFont.name
                font.pixelSize: 12
                Material.foreground: appWnd.Material.foreground

                onClicked: {
                    console.log("Действие: Перезагрузка списка")
                    // Вызов Core.reloadProxyList() или аналогичного слота
                }
            }
        }
    }

    // ... остальной ваш код (BusyIndicator, Connections и т.д.) ...

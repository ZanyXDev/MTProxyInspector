#Чтобы qmllint и QtCreator находили модуль при разработке,
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qt/qml")

# Qt автоматически сгенерирует QQmlExtensionPlugin и qmldir
qt_add_qml_module(UIPlugin
    URI io.github.zanyxdev.memopvp.ui
    VERSION 1.0
    QML_FILES
        MemoCard.qml
	SimpleFlip.qml
)

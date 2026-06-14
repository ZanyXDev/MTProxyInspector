#Чтобы qmllint и QtCreator находили модуль при разработке,
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qt/qml")

find_package(Qt6 REQUIRED COMPONENTS Gui)

# Qt автоматически сгенерирует QQmlExtensionPlugin и qmldir
qt_add_qml_module(CorePlugin
    URI io.github.zanyxdev.mtproxyinspector.core
    VERSION 1.0
    SOURCES
        core.cpp core.h
)

target_link_libraries(CorePlugin PRIVATE Qt6::Gui)

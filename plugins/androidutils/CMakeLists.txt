#Чтобы qmllint и QtCreator находили модуль при разработке,
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qt/qml")

find_package(Qt6 REQUIRED COMPONENTS Gui)

# Qt автоматически сгенерирует QQmlExtensionPlugin и qmldir
qt_add_qml_module(AndroidUtilsPlugin
    URI io.github.zanyxdev.mtproxyinspector.androidutils
    VERSION 1.0
    SOURCES
        androidutils.cpp androidutils.h
)

target_link_libraries(AndroidUtilsPlugin PRIVATE Qt6::Gui)

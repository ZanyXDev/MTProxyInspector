cmake_minimum_required(VERSION 3.16)
project(qmlImageProviderPlugin LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick)

qt_standard_project_setup(REQUIRES 6.10)

#Чтобы qmllint и QtCreator находили модуль при разработке,
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qt/qml")

qt6_add_qml_module(qmlImageProviderPlugin
    URI "ImageProviderCore"
    PLUGIN_TARGET qmlImageProviderPlugin
    NO_GENERATE_PLUGIN_SOURCE
    CLASS_NAME ImageProviderPlugin
    OUTPUT_DIRECTORY "${QML_MODULE_OUTPUT_DIR}"  # ✅ Фиксируем путь
    SOURCES
        imageproviderplugin.h
        imagepackprovider.h
        imagepackprovider.cpp
        imagedatamanager.h
        imagedatamanager.cpp
)

target_link_libraries(qmlImageProviderPlugin PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
)


# ✅ Установка: копируем плагин и qmldir в правильную директорию
install(TARGETS qmlImageProviderPlugin
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt/qml/ImageProviderCore"
)

# ✅ Копируем сгенерированный qmldir (если qt6_add_qml_module не делает это автоматически)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/ImageProviderCore/qmldir"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt/qml/ImageProviderCore"
    OPTIONAL  # Не ошибка, если файл ещё не сгенерирован при первой конфигурации
)
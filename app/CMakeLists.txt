#Чтобы qmllint и QtCreator находили модуль при разработке,
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qt/qml")

qt_add_executable(${APP_NAME} main.cpp)

qt_add_resources(${APP_NAME} "images"
    PREFIX
        "/qt/qml"
    FILES
    ../assets/images/ic_launcher-playstore.png
    ../assets/images/more_vert.png
    ../assets/images/about.png
    ../assets/images/about@2x.png
    ../assets/images/moon.png
    ../assets/images/moon@2x.png
    ../assets/images/sun.png
    ../assets/images/sun@2x.png
    ../assets/images/settings.png
    ../assets/images/settings@2x.png
    ../assets/images/cloud-refresh.png
    ../assets/images/cloud-refresh@2x.png
    ../assets/images/cloud-refresh@3x.png
    ../assets/images/cloud-refresh@4x.png
    ../assets/images/question-mark.png
    ../assets/images/question-mark@2x.png
    ../assets/images/question-mark@3x.png
    ../assets/images/question-mark@4x.png
    ../assets/images/european-flag.png
    ../assets/images/russia-flag.png
)

qt_add_resources(${APP_NAME} "fonts"
    PREFIX
        "/qt/qml"
    FILES
    ../assets/fonts/Buira/Buira.otf
    ../assets/fonts/681-font.otf
    ../assets/fonts/droidsansmono.ttf
    ../assets/fonts/nasalization-rg.otf
)

set(QML_FILES
    qml/Main.qml
    qml/MButton.qml
)

qt_add_qml_module(${APP_NAME}
    URI io.github.zanyxdev.mtproxyinspector
    VERSION 1.0
    QML_FILES ${QML_FILES}   
)

# После qt_add_qml_module(...) добавьте:
target_compile_definitions(${APP_NAME} PRIVATE
    $<$<CONFIG:Debug>:
        QML_DEV_IMPORT_PATH="${QT_QML_OUTPUT_DIRECTORY}"
    >
)

target_link_libraries(${APP_NAME}
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick          # <-- обязательно, если есть #include <QQuickWindow>
)


install(TARGETS ${APP_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# === DEPLOYMENT CONFIG ===
#include(GNUInstallDirs)

# === MODERN DEPLOYMENT (Qt 6.5+) ===
qt_generate_deploy_app_script(
    TARGET ${APP_NAME}
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
    # Qt автоматически просканирует QML-импорты, скопирует либы, плагины и создаст qt.conf
)
install(SCRIPT ${deploy_script})

#Чтобы qmllint и QtCreator находили модуль при разработке,
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qt/qml")

qt_add_executable(${APP_NAME}
    main.cpp
)

qt_add_resources(${APP_NAME} "images"
    PREFIX
        "/qt/qml"
    FILES
    ../assets/images/ic_launcher-playstore.png
    ../assets/images/more_vert.png
    ../assets/images/about.png
    ../assets/images/about@2x.png
    ../assets/images/about@3x.png
    ../assets/images/about@4x.png
    ../assets/images/moon.png
    ../assets/images/moon@2x.png
    ../assets/images/moon@3x.png
    ../assets/images/moon@4x.png
    ../assets/images/sun.png
    ../assets/images/sun@2x.png
    ../assets/images/sun@3x.png
    ../assets/images/sun@4x.png
    ../assets/images/settings.png
    ../assets/images/settings@2x.png
    ../assets/images/settings@3x.png
    ../assets/images/settings@4x.png
    ../assets/images/cloud-refresh.png
    ../assets/images/cloud-refresh@2x.png
    ../assets/images/cloud-refresh@3x.png
    ../assets/images/cloud-refresh@4x.png
    ../assets/images/question-mark.png
    ../assets/images/question-mark@2x.png
    ../assets/images/question-mark@3x.png
    ../assets/images/question-mark@4x.png
    ../assets/images/online.png
    ../assets/images/online@2x.png
    ../assets/images/online@3x.png
    ../assets/images/online@4x.png
    ../assets/images/offline.png
    ../assets/images/offline@2x.png
    ../assets/images/offline@3x.png
    ../assets/images/offline@4x.png
    ../assets/images/flags/eu.svg
    ../assets/images/flags/ru.svg
    ../assets/images/ok.png
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
    qml/MainTest.qml
    qml/Main.qml
    qml/MButton.qml
    qml/MCard.qml
    qml/MListView.qml
    qml/MItemDelegate.qml
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
         Qt6::Network
)

if(ANDROID)
    set_target_properties(${APP_NAME} PROPERTIES
        #QT_ANDROID_ABIS "armeabi-v7a;arm64-v8a;x86;x86_64"
        #QT_ANDROID_BUILD_ALL_ABIS ON
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android/"
        QT_ANDROID_PACKAGE_NAME ${APP_PACKAGE_NAME}
        #QT_ANDROID_APP_NAME ${APP_NAME}
        QT_ANDROID_APP_ICON "@mipmap/ic_launcher"
        QT_ANDROID_TARGET_SDK_VERSION 36

        # Minimal version Android 8.0
        QT_ANDROID_MIN_SDK_VERSION 26
        QT_ANDROID_VERSION_NAME ${APP_VERSION}
        QT_ANDROID_VERSION_CODE ${APP_VERSION_CODE}
    )

    qt_add_android_permission(${APP_NAME}
        NAME android.permission.BLUETOOTH_SCAN
        NAME android.permission.ACCESS_NETWORK_STATE
        NAME android.permission.INTERNET
        NAME android.permission.ACCESS_COARSE_LOCATION
        ATTRIBUTES
            minSdkVersion 31
            usesPermissionFlags neverForLocation
    )

# ----------------------------------------------------------------------------
message(STATUS "[ANDROID] QT_ANDROID_PACKAGE_SOURCE_DIR = ${QT_ANDROID_PACKAGE_SOURCE_DIR}")
message(STATUS "[ANDROID] QT_ANDROID_PACKAGE_NAME       = ${QT_ANDROID_PACKAGE_NAME}")
message(STATUS "[ANDROID] QT_ANDROID_APP_NAME           = ${QT_ANDROID_APP_NAME}")
message(STATUS "[ANDROID] QT_ANDROID_APP_ICON           = ${QT_ANDROID_APP_ICON}")
# ----------------------------------------------------------------------------
endif()

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

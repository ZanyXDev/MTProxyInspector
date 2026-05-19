cmake_minimum_required(VERSION 3.16)
project(tst_imagedatamanager LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Test Qml )

# Устанавливаем путь к скомпилированному QML модулю
set(QML_MODULE_PATH "${CMAKE_BINARY_DIR}/qt/qml")

# ─────────────────────────────────────────────────────────────
# Тест ImageDataManager
# ─────────────────────────────────────────────────────────────
qt_add_executable(tst_imagedatamanager
    tst_imagedatamanager.h
    tst_imagedatamanager.cpp
)

target_include_directories(tst_imagedatamanager PRIVATE
    ${CMAKE_SOURCE_DIR}/src/core/plugins/imageprovider
)

target_link_libraries(tst_imagedatamanager PRIVATE
    Qt6::Core    
    Qt6::Qml
    Qt6::Test    
)

add_test(NAME ImageDataManagerTest
    COMMAND tst_imagedatamanager
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

# ─────────────────────────────────────────────────────────────
set_tests_properties(ImageDataManagerTest  PROPERTIES
    TIMEOUT 30
    ENVIRONMENT "QT_QPA_PLATFORM=offscreen"  # Для headless-запуска в CI
)

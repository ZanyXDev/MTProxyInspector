cmake_minimum_required(VERSION 3.16)
project(tst_boardgenerator LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Test Qml)

qt_add_executable(tst_boardgenerator
    tst_testboardgenerator.h
    tst_testboardgenerator.cpp
)

# ✅ КРИТИЧНО: Явное включение AUTOMOC для этого таргета
set_target_properties(tst_boardgenerator PROPERTIES
    AUTOMOC ON
    AUTOUIC ON
    AUTORCC OFF
)

target_include_directories(tst_boardgenerator PRIVATE
    ${CMAKE_SOURCE_DIR}/src/core
)

target_link_libraries(tst_boardgenerator PRIVATE
    Qt6::Core
    Qt6::Test
    Qt6::Qml
    coreLibplugin
)

add_test(NAME tst_boardgenerator COMMAND tst_boardgenerator)
set_tests_properties(tst_boardgenerator PROPERTIES
    TIMEOUT 30
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)
cmake_minimum_required(VERSION 3.20)

set (APP_NAME "MTProxyInspector")
set (APP_NAME_ANDROID "MTProxy Inspector")
set (APP_PACKAGE_NAME "io.github.zanyxdev.mtproxyinspector")

# --- 1. Получаем версию из Git тега ---
execute_process(
    COMMAND git describe --tags --abbrev=0
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_TAG
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
    RESULT_VARIABLE GIT_RESULT
)

if(GIT_RESULT EQUAL 0 AND GIT_TAG)
    # Убираем префикс 'v' или 'V', если он есть (например, v0.1.3 -> 0.1.3)
    string(REGEX REPLACE "^[vV]" "" APP_VERSION "${GIT_TAG}")
    message(STATUS "✓ App version from Git tag: ${APP_VERSION}")
else()
    # Fallback: если тегов нет (или git недоступен), читаем из файла
    if(EXISTS "${CMAKE_SOURCE_DIR}/version.txt")
        file(READ "${CMAKE_SOURCE_DIR}/version.txt" APP_VERSION_RAW)
        string(STRIP "${APP_VERSION_RAW}" APP_VERSION)
        message(STATUS "✓ App version from version.txt: ${APP_VERSION}")
    else()
        set(APP_VERSION "0.0.1")
        message(WARNING "⚠ Could not get version from Git or version.txt. Using default: ${APP_VERSION}")
    endif()
endif()

# --- 2. Автоматический расчет APP_VERSION_CODE для Android ---
# Android требует целое число для versionCode.
# Алгоритм: Major * 10000 + Minor * 100 + Patch (например, 0.1.3 -> 103)
string(REPLACE "." ";" VERSION_LIST ${APP_VERSION})
list(LENGTH VERSION_LIST VERSION_LIST_LENGTH)

if(VERSION_LIST_LENGTH GREATER_EQUAL 3)
    list(GET VERSION_LIST 0 VER_MAJOR)
    list(GET VERSION_LIST 1 VER_MINOR)
    list(GET VERSION_LIST 2 VER_PATCH)

    # Очищаем от возможных суффиксов (например, если тег был 0.1.3-beta, patch станет "3-beta")
    string(REGEX MATCH "^[0-9]+" VER_MAJOR "${VER_MAJOR}")
    string(REGEX MATCH "^[0-9]+" VER_MINOR "${VER_MINOR}")
    string(REGEX MATCH "^[0-9]+" VER_PATCH "${VER_PATCH}")

    math(EXPR APP_VERSION_CODE "${VER_MAJOR} * 10000 + ${VER_MINOR} * 100 + ${VER_PATCH}")
else()
    set(APP_VERSION_CODE "1")
endif()

message(STATUS "✓ App version code: ${APP_VERSION_CODE}")

project(${APP_NAME} VERSION ${APP_VERSION} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(QT_QML_GENERATE_QMLLS_INI ON)
set(CMAKE_VERBOSE_MAKEFILE ON)

# --------- Чтобы qmllint и QtCreator находили модуль при разработке ---------
#
# https://forum.qt.io/topic/146086/usage-of-import_path-in-qt_add_qml_module/4
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qt/qml")
set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY} CACHE STRING "Import paths for Qt Creator's code model" FORCE)
# ----------------------------------------------------------------------------

# ------------------------- tune speed build ----------------------------------
# 1. Включить Unity Build (объединяет .cpp файлы → меньше компиляций)
# ----------------------------------------------------------------------------
set(CMAKE_UNITY_BUILD OFF)
set(CMAKE_UNITY_BUILD_BATCH_SIZE 4)  # баланс между скоростью и инкрементальностью

# ----------------------------------------------------------------------------

# Compile definitions (аналог DEFINES в .pro)
add_compile_definitions(
    VERSION_STR="${APP_VERSION}"
    PACKAGE_NAME_STR="${APP_PACKAGE_NAME}"
    ACTIVITY_NAME_STR="${APP_NAME}"
    QT_DEPRECATED_WARNINGS
    # QT_NO_CAST_FROM_ASCII
    # QT_NO_CAST_TO_ASCII
)
# ----------------------------------------------------------------------------

# -------------------------- Debug options -----------------------------------
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    # Отключить избыточную генерацию QML cache в Debug
    set(QT_QMLCACHE_GENERATOR_AOT_COMPILER_ENABLED OFF)
endif()
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# CCache интеграция (если установлен)
# ----------------------------------------------------------------------------
find_program(CCACHE_PROGRAM ccache)

if(CCACHE_PROGRAM)
    set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    # Для ccache: установить base_dir через окружение
    set(ENV{CCACHE_BASEDIR} "${CMAKE_SOURCE_DIR}")

    # Ключевые настройки для ccache + Qt:
    set(ENV{CCACHE_COMPRESS} "true")           # сжатие кэша
    set(ENV{CCACHE_COMPRESSLEVEL} "6")         # баланс скорость/размер
    set(ENV{CCACHE_MAXSIZE} "10G")             # лимит кэша
    set(ENV{CCACHE_SLOPPINESS} "pch_defines,time_macros") # для PCH

    # Для Qt MOC: игнорировать временные метки в сгенерированных файлах
    set(ENV{CCACHE_EXCLUDE} ".*_autogen/mocs_compilation.cpp")

    message(STATUS "✓ Using ccache: ${CCACHE_PROGRAM}")
    message(STATUS "✓ CCACHE_BASEDIR: $ENV{CCACHE_BASEDIR}")
    message(STATUS "✓ ccache configured: $ENV{CCACHE_MAXSIZE} max, compression=$ENV{CCACHE_COMPRESSLEVEL}")
endif()

# ----------------------------------------------------------------------------

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick ShaderTools)
qt_standard_project_setup(REQUIRES 6.10)

add_subdirectory(app)
add_subdirectory(plugins)

# ----------------------------------------------------------------------------
# QTest интеграция
# ----------------------------------------------------------------------------
set(BUILD_TEST ON)
if (BUILD_TEST)
    enable_testing()
    # Добавляем подпроект с тестами
    #add_subdirectory(tests)
endif()

# ----------------------------------------------------------------------------
message(STATUS "[CMAKE] CMAKE_VERSION               = ${CMAKE_VERSION}")
message(STATUS "[CMAKE] CMAKE_PREFIX_PATH           = ${CMAKE_PREFIX_PATH}")
message(STATUS "[SYSTEM] (HOST) SYSTEM NAME         = ${CMAKE_HOST_SYSTEM_NAME}")
message(STATUS "[SYSTEM] (HOST) SYSTEM VERSION      = ${CMAKE_HOST_SYSTEM_VERSION}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM NAME       = ${CMAKE_SYSTEM_NAME}")
message(STATUS "[SYSTEM] (TARGET) SYSTEM VERSION    = ${CMAKE_SYSTEM_VERSION}")
message(STATUS "[PROJECT] SOURCE_DIR                = ${CMAKE_CURRENT_SOURCE_DIR}")
message(STATUS "[PROJECT] BUILD_TYPE                = ${CMAKE_BUILD_TYPE}")
message(STATUS "[PROJECT] TOOLCHAIN_FILE            = ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "[PROJECT] CMAKE_INSTALL_LIBDIR      = ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "[PROJECT] QT_HOST_PATH              = ${QT_HOST_PATH}")
# ----------------------------------------------------------------------------

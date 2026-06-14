#! /bin/sh

# 0. Очистка (если была ошибка конфигурации)
rm -rf build/*

# 1. Настройка (Release)
cmake -B build -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="$(pwd)/deploy"

# 2. Сборка
cmake --build build -j$(nproc)

# 3. Установка в папку deploy/
cmake --install build

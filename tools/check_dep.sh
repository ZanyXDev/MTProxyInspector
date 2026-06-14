#! /bin/bash
cd ../build
cmake --graphviz=deps.dot ..
dot -Tpng deps.dot -o deps.png  # визуализация зависимостей

#!/usr/bin/env bash
# setup_lsp.sh — Генерация LSP-конфигов для Qt6/QML разработки
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== MTProxyInspector LSP Setup ==="

# 1. Определяем build директорию
BUILD_DIR="${PROJECT_DIR}/build/Desktop-Debug"
if [ ! -d "$BUILD_DIR" ]; then
    echo "[ERROR] Build directory not found: $BUILD_DIR"
    echo "Run CMake configure first: cmake -B build/Desktop-Debug -G Ninja"
    exit 1
fi

# 2. Проверяем compile_commands.json (для clangd)
if [ -f "$BUILD_DIR/compile_commands.json" ]; then
    echo "[OK] compile_commands.json found"
else
    echo "[WARN] compile_commands.json not found — enable CMAKE_EXPORT_COMPILE_COMMANDS"
fi

# 3. Проверяем .qmlls.build.ini (для qmlls)
QT_BUILD_INI="$BUILD_DIR/.qt/.qmlls.build.ini"
if [ -f "$QT_BUILD_INI" ]; then
    echo "[OK] .qmlls.build.ini found at $QT_BUILD_INI"
else
    echo "[ERROR] .qmlls.build.ini not found — set QT_QML_GENERATE_QMLLS_INI=ON in CMake"
    exit 1
fi

# 4. Генерируем .qmlls.ini для каждого QML-модуля
generate_qmlls_ini() {
    local target_dir="$1"
    local rel_path="$2"
    local ini_file="$target_dir/.qmlls.ini"

    cat > "$ini_file" <<EOF
[General]
buildDir=$rel_path/.qt
EOF
    echo "[CREATED] $ini_file -> buildDir=$rel_path/.qt"
}

generate_qmlls_ini "$PROJECT_DIR/app"               "../build/Desktop-Debug"
generate_qmlls_ini "$PROJECT_DIR/plugins/core"       "../../build/Desktop-Debug"
generate_qmlls_ini "$PROJECT_DIR/plugins/androidutils" "../../build/Desktop-Debug"

# 5. Проверяем clangd
if command -v clangd &>/dev/null; then
    echo "[OK] clangd found: $(clangd --version | head -1)"
else
    echo "[WARN] clangd not found — install it for C++ LSP:"
    echo "       sudo apt install clangd    # Debian/Ubuntu"
    echo "       sudo pacman -S clangd      # Arch"
    echo "       brew install llvm          # macOS"
fi

# 6. Проверяем qmlls
if command -v qmlls &>/dev/null; then
    echo "[OK] qmlls found: $(qmlls --version 2>&1 | head -1)"
else
    echo "[WARN] qmlls not found — install Qt6 QML tools or add to PATH:"
    echo "       export PATH=/opt/qt/6.x.x/gcc_64/bin:\$PATH"
fi

echo ""
echo "=== LSP Setup Complete ==="
echo "Restart your editor to activate LSP."

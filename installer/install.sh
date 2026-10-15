#!/bin/sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
prefix="${1:-/usr}"
build_dir="${WINUX11_BUILD_DIR:-$root/build}"
jobs="${WINUX11_BUILD_JOBS:-2}"

if ! command -v cmake >/dev/null 2>&1 || ! command -v ninja >/dev/null 2>&1; then
    printf '%s\n' 'WINUX11: CMake and Ninja are required. On Ubuntu: sudo apt install build-essential cmake ninja-build pkg-config qt6-base-dev qt6-declarative-dev qt6-wayland-dev qt6-wayland qml6-module-qtqml-workerscript qml6-module-qtquick-templates qml6-module-qtquick qml6-module-qtquick-controls qml6-module-qtquick-layouts qml6-module-qtwebengine libxkbcommon-dev' >&2
    exit 2
fi

printf '%s\n' 'WINUX11: configuring...'
cmake -S "$root" -B "$build_dir" -G Ninja -DCMAKE_BUILD_TYPE=Release -DWINUX11_BUILD_TESTS=ON
printf '%s\n' 'WINUX11: building...'
cmake --build "$build_dir" --parallel "$jobs"
printf '%s\n' 'WINUX11: running tests...'
ctest --test-dir "$build_dir" --output-on-failure

printf 'WINUX11: installing into %s...\n' "$prefix"
if [ "$prefix" = /usr ] && [ "$(id -u)" -ne 0 ]; then
    if ! command -v sudo >/dev/null 2>&1; then
        printf '%s\n' 'WINUX11: sudo is required to install into /usr.' >&2
        exit 2
    fi
    sudo cmake --install "$build_dir" --prefix "$prefix"
else
    cmake --install "$build_dir" --prefix "$prefix"
fi

if [ "${WINUX11_INSTALL_WINE:-0}" = 1 ]; then
    if ! command -v apt-get >/dev/null 2>&1; then
        printf '%s\n' 'WINUX11: WINUX11_INSTALL_WINE=1 requires apt-get; install Wine with your distribution package manager.' >&2
        exit 2
    fi
    if [ "$(id -u)" -eq 0 ]; then
        apt-get install -y wine
    else
        sudo apt-get install -y wine
    fi
fi

if command -v update-desktop-database >/dev/null 2>&1 && [ "$prefix" = /usr ]; then
    update-desktop-database "$prefix/share/applications" >/dev/null 2>&1 || true
fi

printf '%s\n' 'WINUX11: installation completed.'
printf '%s\n' 'Choose WINUX11 at the login screen. If the graphical login is stuck, switch to a TTY and run: Winux11'
if [ "${WINUX11_INSTALL_WINE:-0}" != 1 ]; then
    printf '%s\n' 'Windows app compatibility is optional. To install Wine during setup: WINUX11_INSTALL_WINE=1 sh installer/install.sh'
fi

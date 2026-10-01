#!/bin/sh
set -eu
prefix=${1:-/usr}
cmake --install build --prefix "$prefix"
install -Dm755 session/winux11-session "$prefix/bin/winux11-session"
install -Dm644 session/winux11.desktop "$prefix/share/wayland-sessions/winux11.desktop"
printf '%s\n' 'WINUX11 installed. Select the WINUX11 Wayland session from your display manager.'

#!/bin/sh
set -eu
root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
runtime="$(mktemp -d)"
state="$(mktemp -d)"
cleanup() { rm -rf "$runtime" "$state"; }
trap cleanup EXIT INT TERM
export XDG_RUNTIME_DIR="$runtime"
chmod 700 "$runtime" "$state"
export WINUX11_WAYLAND_DISPLAY="wayland-winux11-smoke"
export WINUX11_LOG_FILE="$state/session.log"
export WINUX11_HEADLESS_SMOKE=1
unset WAYLAND_DISPLAY
export WINUX11_PREFIX="${WINUX11_PREFIX:-$root/build-smoke/root}"
command -v xvfb-run >/dev/null 2>&1 || { echo "WINUX11 smoke: xvfb-run is required"; exit 2; }
[ -x "$WINUX11_PREFIX/bin/winux11-compositor" ] && [ -x "$WINUX11_PREFIX/bin/winux11-shell" ] || { echo "WINUX11 smoke: installed binaries missing"; exit 3; }
set +e
timeout 10s xvfb-run -a env QT_QPA_PLATFORM=xcb sh "$root/session/winux11-session"
rc=$?
set -e
if [ "$rc" -ne 124 ] && [ "$rc" -ne 0 ]; then
    echo "WINUX11 smoke: session exited unexpectedly with $rc"
    if [ -f "$WINUX11_LOG_FILE" ]; then tail -n 100 "$WINUX11_LOG_FILE"; fi
    exit "$rc"
fi
if [ ! -S "$XDG_RUNTIME_DIR/$WINUX11_WAYLAND_DISPLAY" ]; then
    echo "WINUX11 smoke: compositor never created the Wayland socket"
    if [ -f "$WINUX11_LOG_FILE" ]; then tail -n 100 "$WINUX11_LOG_FILE"; fi
    exit 4
fi
echo "WINUX11 smoke: compositor created its Wayland socket and stayed alive"

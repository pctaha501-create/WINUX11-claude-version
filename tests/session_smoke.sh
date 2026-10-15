#!/bin/sh
set -eu
root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
runtime="$(mktemp -d)"
state="$(mktemp -d)"
cleanup() { rm -rf "$runtime" "$state"; }
trap cleanup EXIT INT TERM
export XDG_RUNTIME_DIR="$runtime"
export XDG_STATE_HOME="$state"
chmod 700 "$runtime" "$state"
export WINUX11_WAYLAND_DISPLAY="wayland-winux11-smoke"
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
    if [ -f "$state/winux11/session.log" ]; then tail -n 100 "$state/winux11/session.log"; fi
    exit "$rc"
fi
echo "WINUX11 smoke: compositor/socket/session startup path completed"

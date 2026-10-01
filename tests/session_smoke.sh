#!/bin/sh
set -eu
root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
runtime="$(mktemp -d)"
cleanup(){ rm -rf "$runtime"; }
trap cleanup EXIT INT TERM
export XDG_RUNTIME_DIR="$runtime"
chmod 700 "$runtime"
export WAYLAND_DISPLAY="wayland-winux11-smoke"
export WINUX11_PREFIX="${WINUX11_PREFIX:-$root/build-smoke/root}"
command -v xvfb-run >/dev/null 2>&1 || { echo "WINUX11 smoke: xvfb-run is required"; exit 2; }
[ -x "$WINUX11_PREFIX/bin/winux11-compositor" ] && [ -x "$WINUX11_PREFIX/bin/winux11-shell" ] || { echo "WINUX11 smoke: installed binaries missing"; exit 3; }
set +e
timeout 10s xvfb-run -a env QT_QPA_PLATFORM=xcb "$root/session/winux11-session"
rc=$?
set -e
[ "$rc" -eq 124 ] || [ "$rc" -eq 0 ] || { echo "WINUX11 smoke: session exited unexpectedly with $rc"; exit "$rc"; }
echo "WINUX11 smoke: compositor/socket/session startup path completed"

#!/bin/sh
set -eu
root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
runtime="$(mktemp -d)"
state="$(mktemp -d)"
cleanup() {
    if [ -n "${runner_pid:-}" ]; then
        kill "$runner_pid" 2>/dev/null || true
        wait "$runner_pid" 2>/dev/null || true
    fi
    rm -rf "$runtime" "$state"
}
trap cleanup EXIT INT TERM
export XDG_RUNTIME_DIR="$runtime"
chmod 700 "$runtime" "$state"
export WINUX11_WAYLAND_DISPLAY="wayland-winux11-smoke"
export WINUX11_LOG_FILE="$state/session.log"
export WINUX11_HEADLESS_SMOKE=1
unset WAYLAND_DISPLAY
export WINUX11_PREFIX="${WINUX11_PREFIX:-$root/build-smoke/root}"
command -v xvfb-run >/dev/null 2>&1 || { echo "WINUX11 smoke: xvfb-run is required"; exit 2; }
command -v timeout >/dev/null 2>&1 || { echo "WINUX11 smoke: timeout is required"; exit 2; }
[ -x "$WINUX11_PREFIX/bin/winux11-compositor" ] && [ -x "$WINUX11_PREFIX/bin/winux11-shell" ] || { echo "WINUX11 smoke: installed binaries missing"; exit 3; }
timeout 8s xvfb-run -a env QT_QPA_PLATFORM=xcb sh "$root/session/winux11-session" &
runner_pid=$!
ready=0
i=0
while [ "$i" -lt 140 ]; do
    if [ -S "$XDG_RUNTIME_DIR/$WINUX11_WAYLAND_DISPLAY" ]; then
        ready=1
        break
    fi
    if ! kill -0 "$runner_pid" 2>/dev/null; then break; fi
    sleep 0.05
    i=$((i + 1))
done
if [ "$ready" -ne 1 ]; then
    echo "WINUX11 smoke: compositor did not create its Wayland socket"
    if [ -f "$WINUX11_LOG_FILE" ]; then tail -n 100 "$WINUX11_LOG_FILE"; fi
    set +e
    wait "$runner_pid"
    rc=$?
    set -e
    runner_pid=
    [ "$rc" -eq 0 ] || exit "$rc"
    exit 4
fi
echo "WINUX11 smoke: compositor created the Wayland socket"
set +e
wait "$runner_pid"
rc=$?
set -e
runner_pid=
if [ "$rc" -ne 0 ]; then
    echo "WINUX11 smoke: session exited with status $rc"
    if [ -f "$WINUX11_LOG_FILE" ]; then tail -n 100 "$WINUX11_LOG_FILE"; fi
    exit "$rc"
fi
echo "WINUX11 smoke: headless session exited cleanly"

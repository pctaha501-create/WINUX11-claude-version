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
unset WINUX11_HEADLESS_SMOKE
unset WAYLAND_DISPLAY
export WINUX11_PREFIX="${WINUX11_PREFIX:-$root/build-smoke/root}"
# Regression test: leave an orphaned Unix socket at the dedicated nested
# Wayland path. The session launcher must remove it and start normally.
python3 - "$XDG_RUNTIME_DIR/$WINUX11_WAYLAND_DISPLAY" <<'PY'
import socket, sys
sock = socket.socket(socket.AF_UNIX)
sock.bind(sys.argv[1])
sock.close()  # Deliberately leave the stale socket path behind.
PY
command -v xvfb-run >/dev/null 2>&1 || { echo "WINUX11 smoke: xvfb-run is required"; exit 2; }
command -v timeout >/dev/null 2>&1 || { echo "WINUX11 smoke: timeout is required"; exit 2; }
[ -x "$WINUX11_PREFIX/bin/winux11-compositor" ] && [ -x "$WINUX11_PREFIX/bin/winux11-shell" ] || { echo "WINUX11 smoke: installed binaries missing"; exit 3; }
timeout 8s xvfb-run -a env QT_QPA_PLATFORM=xcb sh "$root/session/winux11-session" &
runner_pid=$!
socket_ready=0
shell_ready=0
i=0
while [ "$i" -lt 120 ]; do
    if [ -S "$XDG_RUNTIME_DIR/$WINUX11_WAYLAND_DISPLAY" ]; then socket_ready=1; fi
    if [ -f "$WINUX11_LOG_FILE" ] && grep -q "Starting WINUX11 shell" "$WINUX11_LOG_FILE"; then shell_ready=1; break; fi
    if ! kill -0 "$runner_pid" 2>/dev/null; then break; fi
    sleep 0.05
    i=$((i + 1))
done
if [ "$socket_ready" -ne 1 ] || [ "$shell_ready" -ne 1 ]; then
    echo "WINUX11 smoke: compositor socket or shell startup was not observed"
    if [ -f "$WINUX11_LOG_FILE" ]; then tail -n 120 "$WINUX11_LOG_FILE"; fi
    set +e
    wait "$runner_pid"
    rc=$?
    set -e
    runner_pid=
    [ "$rc" -eq 124 ] || exit "$rc"
    exit 4
fi
echo "WINUX11 smoke: compositor socket ready and shell launch observed"
set +e
wait "$runner_pid"
rc=$?
set -e
runner_pid=
if [ "$rc" -ne 124 ]; then
    echo "WINUX11 smoke: session ended before the expected 8-second timeout (status $rc)"
    if [ -f "$WINUX11_LOG_FILE" ]; then tail -n 120 "$WINUX11_LOG_FILE"; fi
    exit 5
fi
if grep -q "WINUX11 shell exited with status 1" "$WINUX11_LOG_FILE"; then
    echo "WINUX11 smoke: shell exited with an error"
    tail -n 120 "$WINUX11_LOG_FILE"
    exit 6
fi
echo "WINUX11 smoke: compositor and shell remained active until the timeout"

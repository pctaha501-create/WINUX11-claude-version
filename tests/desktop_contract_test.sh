#!/bin/sh
set -eu
compositor=$1
qml=$2
controller_header=$3
controller_source=$4

if grep -Eq 'sendConfigure[[:space:]]*\([[:space:]]*QSize[[:space:]]*\([[:space:]]*\)' "$compositor"; then
    echo "FAIL: invalid empty QSize is sent in an XDG configure" >&2
    exit 1
fi
if ! grep -q 'isShellSurface' "$compositor" || ! grep -q 'initialWidth' "$compositor" || ! grep -q 'm_shellSurfaceAssigned' "$compositor"; then
    echo "FAIL: root shell is not assigned a valid output-sized surface" >&2
    exit 1
fi
if ! grep -q 'm_pendingCommands' "$controller_header" || ! grep -q 'flushPendingCommands' "$controller_source"; then
    echo "FAIL: shell IPC command queue/reconnect support is missing" >&2
    exit 1
fi
if ! grep -q 'NumberAnimation' "$qml" || ! grep -q '#bd1b2637' "$qml"; then
    echo "FAIL: glass desktop styling or lightweight motion is missing" >&2
    exit 1
fi
echo "WINUX11 compositor, IPC and glass desktop contracts passed"

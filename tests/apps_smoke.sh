#!/bin/sh
set -eu
prefix="${WINUX11_PREFIX:-/usr}"
tmp="$(mktemp -d)"
cleanup() { rm -rf "$tmp"; }
trap cleanup EXIT INT TERM

apps="terminal explorer settings taskmanager browser security screenshot softwarecenter network downloader archive calculator clock calendar editor photos mediaplayer music camera recorder systemtools"
for app in $apps; do
    executable="$prefix/bin/winux11-$app"
    log="$tmp/$app.log"
    if [ ! -x "$executable" ]; then
        printf 'WINUX11 app smoke: missing executable %s\n' "$executable" >&2
        exit 2
    fi

    limit=3
    [ "$app" = browser ] && limit=5
    set +e
    timeout "${limit}s" env QT_QPA_PLATFORM=xcb QT_QUICK_BACKEND=software QTWEBENGINE_DISABLE_SANDBOX=1 "$executable" >"$log" 2>&1
    rc=$?
    set -e

    if [ "$rc" -ne 124 ]; then
        printf 'WINUX11 app smoke: %s exited before timeout (status %s)\n' "$app" "$rc" >&2
        cat "$log" >&2
        exit 1
    fi
    if grep -Eiq 'failed to load component|module .* is not installed|type .* unavailable|ReferenceError:|TypeError:|QQmlApplicationEngine.*failed' "$log"; then
        printf 'WINUX11 app smoke: QML/runtime error in %s\n' "$app" >&2
        cat "$log" >&2
        exit 1
    fi
    printf 'WINUX11 app smoke: %s stayed alive\n' "$app"
done

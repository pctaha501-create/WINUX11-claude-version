#!/bin/sh
set -eu
prefix="${1:-/usr}"
cmake --install build --prefix "$prefix"
install -Dm755 session/winux11-session "$prefix/bin/winux11-session"
install -Dm644 session/winux11.desktop "$prefix/share/xsessions/winux11.desktop"
install -Dm644 session/winux11-wayland.desktop "$prefix/share/wayland-sessions/winux11-wayland.desktop"

# Add the requested short systemctl name as an alias for the configured display manager.
# Never overwrite an existing unit with the same name.
if [ "$prefix" = /usr ] && [ "$(id -u)" -eq 0 ] && command -v systemctl >/dev/null 2>&1; then
    unit_dir=/etc/systemd/system
    alias_unit="$unit_dir/WINUX11.service"
    if [ -L "$alias_unit" ] && [ "$(readlink "$alias_unit")" = display-manager.service ]; then
        :
    elif [ -e "$alias_unit" ] || [ -L "$alias_unit" ]; then
        printf '%s\n' "WINUX11: leaving existing $alias_unit untouched" >&2
    elif [ -e "$unit_dir/display-manager.service" ] || systemctl cat display-manager.service >/dev/null 2>&1; then
        ln -s display-manager.service "$alias_unit"
        systemctl daemon-reload
        printf '%s\n' 'Created systemctl alias: systemctl restart WINUX11'
    else
        printf '%s\n' 'WINUX11: no display-manager.service found; skipped systemctl alias' >&2
    fi
fi
printf '%s\n' 'WINUX11 installed. Select WINUX11 at the login screen; use WINUX11 (Native Wayland) only when native graphics access is working.'

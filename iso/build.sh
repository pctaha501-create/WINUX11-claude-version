#!/bin/sh
set -eu
if [ "${WINUX11_ISO_ENABLE:-0}" != "1" ]; then
  echo "WINUX11 ISO generation is intentionally disabled." >&2
  exit 2
fi
command -v lb >/dev/null 2>&1 || { echo "live-build (lb) is required" >&2; exit 1; }
root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
out="${WINUX11_ISO_OUTPUT:-$root/out/iso}"
mkdir -p "$out"
cd "$root"
lb config --distribution bookworm --archive-areas "main contrib non-free-firmware"
mkdir -p config/package-lists
cp iso/winux11.list.chroot config/package-lists/winux11.list.chroot
mkdir -p config/includes.chroot/usr/share/wayland-sessions
mkdir -p config/includes.chroot/usr/bin
cp session/winux11.desktop config/includes.chroot/usr/share/wayland-sessions/winux11.desktop
cp session/winux11-session config/includes.chroot/usr/bin/winux11-session
echo "Install completed WINUX11 binaries into config/includes.chroot/usr before invoking lb build."
lb build
mv live-image-*.iso "$out/WINUX11.iso"

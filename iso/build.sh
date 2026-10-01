#!/bin/sh
set -eu
if [ "$(id -u)" -ne 0 ]; then
 command -v sudo >/dev/null 2>&1 || { echo "WINUX11 ISO: root privileges are required (sudo unavailable)" >&2; exit 1; }
 exec sudo -E sh "$0" "$@"
fi
[ "${WINUX11_ISO_ENABLE:-0}" = "1" ] || { echo "WINUX11 ISO generation is intentionally disabled unless WINUX11_ISO_ENABLE=1." >&2; exit 2; }
command -v lb >/dev/null 2>&1 || { echo "live-build (lb) is required" >&2; exit 1; }
root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
build="${WINUX11_BUILD_DIR:-$root/build}"
[ -f "$build/install_manifest.txt" ] || { echo "Build/install manifest missing. Build WINUX11 before ISO creation." >&2; exit 1; }
out="${WINUX11_ISO_OUTPUT:-$root/out/iso}"
rm -rf "$root/iso/config"
mkdir -p "$root/iso/config/package-lists" "$root/iso/config/includes.chroot"
cp "$root/iso/winux11.list.chroot" "$root/iso/config/package-lists/winux11.list.chroot"
mkdir -p "$root/iso/config/includes.chroot/usr/bin" "$root/iso/config/includes.chroot/usr/share/wayland-sessions"
cmake --install "$build" --prefix "$root/iso/config/includes.chroot/usr"
install -Dm755 "$root/session/winux11-session" "$root/iso/config/includes.chroot/usr/bin/winux11-session"
install -Dm644 "$root/session/winux11.desktop" "$root/iso/config/includes.chroot/usr/share/wayland-sessions/winux11.desktop"
mkdir -p "$out"
cd "$root/iso"
lb config --distribution noble --architectures amd64 --archive-areas "main contrib non-free non-free-firmware" --binary-images iso-hybrid --debian-installer false --apt-recommends true
lb build
mkdir -p "$out"
iso="$(find "$root/iso" -maxdepth 1 -type f -name '*.iso' -print -quit)"
[ -n "$iso" ] || { echo "live-build completed but no ISO was produced" >&2; exit 1; }
mv "$iso" "$out/WINUX11-amd64.iso"
sha256sum "$out/WINUX11-amd64.iso" > "$out/WINUX11-amd64.iso.sha256"
echo "WINUX11 ISO: $out/WINUX11-amd64.iso"

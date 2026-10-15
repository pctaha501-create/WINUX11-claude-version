# WINUX11

WINUX11 is an independent Linux desktop environment built from zero around Wayland, Qt 6, QML and Linux system APIs. It targets a polished Windows-11-like workflow without copying Windows code or another WINUX11 implementation.

Architecture: Linux → Wayland → WINUX11 compositor → WINUX11 shell → system services → applications.

The compositor is a real Qt Wayland compositor. It creates an XDG shell, a Wayland output, and QWaylandQuickShellSurfaceItem instances for client surfaces, while the shell is rendered in the compositor's Qt Quick scene.

Core applications are real Linux/Qt processes rather than mock data. Missing capabilities are reported instead of being treated as success.

## Build and test

Install the Qt 6, Qt Wayland, CMake, Ninja, and compiler development packages for your distribution, then run:

```sh
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel 2
ctest --test-dir build --output-on-failure
sudo cmake --install build --prefix /usr
```

The CI workflow validates QML syntax, compiles the project, runs tests, verifies installed files, and starts a session smoke test.

## Native Linux applications and tools

WINUX11 runs native Linux applications. Use the Terminal for standard Linux commands and development tools, or install packages through Software Center. From the Start search, enter an executable name such as `firefox`, `gimp`, or `vlc`; if it is installed and on `PATH`, WINUX11 can launch it directly. Flatpak commands such as `flatpak run org.mozilla.firefox` can also be entered in search when Flatpak is installed.

## Windows applications

Windows desktop programs are supported through Wine compatibility, not by running the Windows kernel. Install Wine from Software Center, then use Files to open an `.exe` program or an `.msi` installer. Compatibility depends on the specific program, its version, drivers, and extra runtime components. Some programs will need additional setup or will not work; no Wine-based Linux desktop can guarantee that every Windows app runs without errors. For important software, test the exact application and version before relying on it.

## Recover the graphical login

If the graphical login/display manager is stuck, switch to a text console with **Ctrl+Alt+F3**, sign in, and run:

```sh
Winux11
```

The command restarts the display manager and can close any graphical sessions, so run it from a TTY when recovering a missing GUI. If it fails, inspect the service with `systemctl status display-manager gdm3` and review the session log at `~/.local/state/winux11/session.log` where available.

The ISO is intentionally a later stage; the desktop/session must mature before image construction.

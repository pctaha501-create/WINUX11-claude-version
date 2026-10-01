# WINUX11

WINUX11 is an independent Linux desktop environment built from zero around Wayland, Qt 6, QML and Linux system APIs. It targets a polished Windows-11-like workflow without copying Windows code or another WINUX11 implementation.

Architecture: Linux → Wayland → WINUX11 compositor → WINUX11 shell → system services → applications.

The compositor is a real Qt Wayland compositor. It creates an XDG shell, a Wayland output, and QWaylandQuickShellSurfaceItem instances for client surfaces, while the shell is rendered in the compositor's Qt Quick scene.

Core applications are real Linux/Qt processes rather than mock data. Missing capabilities are reported instead of being treated as success.

Build with CMake + Ninja:

cmake --preset release
cmake --build build/release
ctest --test-dir build/release --output-on-failure

The ISO is intentionally a later stage; the desktop/session must mature before image construction.

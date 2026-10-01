# WINUX11

WINUX11 is an independent Linux desktop environment built from zero around Wayland, Qt 6, QML and Linux system APIs. It targets a polished Windows-11-like workflow without copying Windows code or another WINUX11 implementation.

Architecture: Linux → Wayland → WINUX11 compositor → WINUX11 shell → system services → applications.

This repository is developed as a real desktop environment, not a web mockup. System-facing features use Linux APIs/utilities and fail closed when capabilities are unavailable.

Build with CMake + Ninja:

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
ctest --test-dir build --output-on-failure
```

The ISO is intentionally a later stage; the desktop/session must mature before image construction.

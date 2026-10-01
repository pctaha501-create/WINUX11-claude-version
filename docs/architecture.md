# WINUX11 architecture

- compositor/: real Qt Wayland compositor and XDG toplevel lifecycle/state.
- shell/: QML desktop shell; window lifecycle remains in C++ compositor code.
- services/: bounded Linux command execution, system information and filesystem APIs.
- applications/: independently launchable Qt applications.
- session/: display-manager session entry and launcher.
- tests/: executable smoke/unit tests for core services.
- installer/: CMake-based installation entry point.

Privileged operations are kept out of QML. Capability discovery is explicit so missing NetworkManager, PipeWire, Wine, apt, or hardware does not crash the desktop.

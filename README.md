# Win-To-Linux

Win-To-Linux is a Linux desktop environment and toolset inspired by the familiar workflow of Windows 11. It is built with C++20, Qt 6, QML, CMake, and Linux system APIs. It aims to preserve native Linux capabilities; it is not a replacement Linux kernel or a Windows kernel emulator.

The current repository retains its historical GitHub name, WINUX11-claude-version. The repository name has not been changed.

## Build and test

Install the Qt 6, Qt Wayland, CMake, Ninja, and compiler development packages for your distribution, then run:

    cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
    cmake --build build --parallel 2
    ctest --test-dir build --output-on-failure
    sudo cmake --install build --prefix /usr

## Linux Mode

The System information view reports the host distribution using /etc/os-release and classifies common distro families. The package service builds separate argument-array commands for apt/apt-get, dnf/yum, pacman, and zypper. Unknown distributions or unavailable managers fail safely rather than silently invoking apt. See docs/linux-mode.md.

The adapter tests validate command construction, not real package transactions. The existing GUI invokes install/remove only when a user activates the Software Center controls; package operations may still fail because of repository state, permissions, network access, or distro-specific package naming. No package changes occur automatically during startup.

## Native Linux applications

The existing application targets are native Linux processes. An application is available only if the executable is installed and reachable in the current environment; a UI entry alone is not proof that an external program exists.

## Windows application compatibility

The project contains Wine-related compatibility code, but support depends on the exact Windows program, version, architecture, and runtime dependencies. It cannot guarantee that every .exe or .msi application works.

## Graphical-session diagnostics

The earlier project history recorded a failure where the shell could not connect to the target Wayland display even though the launcher had seen a socket path. A socket file alone is insufficient proof of readiness: verify a live listener and a successful connection before changing the login manager or default session. The Winux11 recovery helper may restart the display manager and close graphical sessions; use it only from a recovery TTY when appropriate.

## Current milestone

- [x] Read-only distro metadata parsing and family classification.
- [x] Detect whether a family-appropriate package-manager executable is present.
- [x] Safe generic fallback for unknown or missing distro metadata.
- [x] Distro-specific package command construction with argument arrays.
- [x] Automated tests for distro detection and package command plans.
- [ ] Confirm graphical-session startup and live Wayland connection.
- [ ] Validate real package transactions on each target distribution.
- [ ] Add distro-specific CI/build packaging matrix and interactive GUI validation.

The project remains under development; unchecked items are not represented as complete.

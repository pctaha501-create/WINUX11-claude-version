# Win-To-Linux

Win-To-Linux is a Linux desktop environment and toolset inspired by the familiar workflow of Windows 11. It is built with C++20, Qt 6, QML, CMake, and Linux system APIs. The product aims to preserve native Linux capabilities while providing a cohesive desktop experience; it is not a replacement Linux kernel or a Windows kernel emulator.

The current repository still has its historical GitHub name, WINUX11-claude-version. That repository name has not been changed.

Architecture: Linux → Wayland compositor → desktop shell → system services → applications.

## Build and test

Install the Qt 6, Qt Wayland, CMake, Ninja, and compiler development packages for your distribution, then run:

    cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
    cmake --build build --parallel 2
    ctest --test-dir build --output-on-failure
    sudo cmake --install build --prefix /usr

The test suite includes service tests and a read-only Linux distribution detector test. A successful build or unit-test run does not, by itself, prove that the graphical session works on every compositor, GPU, or virtual machine.

## Linux Mode

The System information view reports the host distribution using /etc/os-release, classifies common distro families, and reports a package-manager executable only when it is found. Unknown distributions fall back to a generic mode. See docs/linux-mode.md.

This is the detection foundation, not a claim that all package operations are already portable. The existing package service still has apt-specific install/remove behavior. Package installation, removal, updates, privilege escalation, and security-tool execution must remain separate explicit actions; detection alone does not run them.

## Native Linux applications

WINUX11-era application targets currently run native Linux processes. The terminal can run standard Linux commands, and software launching depends on the requested executable being installed and available in the environment. A UI entry is not proof that an external program is installed.

## Windows application compatibility

The project contains Wine-related compatibility code, but support depends on the exact Windows program, version, architecture, and runtime dependencies. It cannot guarantee that every .exe or .msi application works.

## Graphical-session diagnostics

The earlier project history recorded a failure where the shell could not connect to the target Wayland display even though the launcher had seen a socket path. Treat the existence of a socket file as insufficient proof of readiness: verify a live listener and a successful connection before changing the login manager or default session. The Winux11 recovery helper may restart the display manager and close graphical sessions; use it only from a recovery TTY when appropriate.

## Current milestone

- [x] Read-only distro metadata parsing and family classification.
- [x] Detect whether a family-appropriate package-manager executable is present.
- [x] Safe generic fallback for unknown or missing distro metadata.
- [x] Automated fixture-based tests for Ubuntu, Kali, Fedora, Arch, openSUSE, and unknown/missing cases.
- [ ] Multi-distro package operations with explicit consent and safe process execution.
- [ ] Reproducible graphical-session connection and startup verification.
- [ ] Distro-specific build/package matrix and interactive GUI validation.

The repository is still under development; unchecked items are not represented as complete.

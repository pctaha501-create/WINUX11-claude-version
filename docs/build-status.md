# Build validation policy

The project never records a successful build unless CMake configuration, compilation and tests actually complete. Local environments without Qt 6 development packages must report configuration as unavailable; GitHub CI is the authoritative Linux build environment until a matching local Qt toolchain is installed.

The first CI job installs the Qt 6 Wayland and WebEngine development packages, configures with Ninja, builds Release, and executes the service tests.

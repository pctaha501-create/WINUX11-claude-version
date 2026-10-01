# Build validation policy

WINUX11's CI uses Ubuntu 24.04 and validates the real CMake/Ninja build and tests. Qt Wayland Compositor is resolved explicitly through its own CMake package because the Ubuntu packaging exposes Qt6WaylandCompositor as a standalone configuration package.

A build is not called successful until GitHub Actions reports success for configure, build, test and install validation.

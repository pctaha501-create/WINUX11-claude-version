# Win-To-Linux Linux Mode: detection foundation

This milestone adds read-only host distribution detection to the existing Qt 6 service layer.

## Data source and fallback

- Reads /etc/os-release; it does not execute or source the file as shell code.
- Preserves ID, ID_LIKE, PRETTY_NAME/NAME, and VERSION_ID.
- Classifies Debian-family distributions (including Ubuntu and Kali), Red Hat-family distributions, Arch-family distributions, and openSUSE.
- Unknown distributions use the generic family. Missing or unreadable metadata uses safe unknown defaults.
- Looks for a package-manager executable appropriate to the detected family (apt-get/apt, dnf/yum, pacman, or zypper). For an unknown family, it only reports a manager if a known executable is actually found on PATH.
- Reports manager availability separately from distro identity. Detecting a family does not prove that repositories, permissions, or a package operation are working.

The result is included in SystemInfo::snapshot() and is visible in the existing Settings → System information view.

## Safety boundary

This detector is read-only. It never installs, removes, or updates packages, never requests root privileges, and never launches security tools. Package operations must be a separate, explicit user-approved workflow. The existing package service still contains Debian/apt-specific operations; this milestone does not claim that package installation is multi-distro ready.

## Tests

win-to-linux-distro-test uses temporary os-release fixtures and fake executable paths to test Ubuntu, Kali, Fedora, Arch, openSUSE, unknown-distribution fallback, and missing metadata without changing the host system.

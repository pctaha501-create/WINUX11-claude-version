# Win-To-Linux Linux Mode

## Host detection

The detector reads /etc/os-release as data, never sources or executes it. It identifies Debian-family distributions (including Ubuntu and Kali), Red Hat-family distributions, Arch-family distributions, and openSUSE. Unknown systems use a generic fallback. The System information view reports the detected identity and whether a family-appropriate package-manager executable is present.

## Package-manager command adapters

The package service now creates argument-array command plans for apt/apt-get, dnf/yum, pacman, and zypper. Update checks are read-only commands appropriate to each manager. Install/remove operations are sent through pkexec and use manager-specific arguments; they are invoked only when the user activates the corresponding Software Center action. Package names are validated before command execution. The process runner does not invoke a shell, so package-name input is not interpolated into a command string.

This does not prove that repository configuration, network access, privilege authentication, or package installation works on every distro. CI tests the command plans, not real package transactions. Real install/remove actions remain environment-dependent and must be validated separately on each supported distro.

## Safety boundaries

The detector and command-plan tests never install, remove, or update packages. No package transaction is run automatically at startup. Unknown/unavailable package managers return an explicit unsupported result instead of silently falling back to apt.

## Tests

The detector tests use temporary os-release fixtures and fake executable paths for Ubuntu, Kali, Fedora, Arch, openSUSE, unknown distributions, and missing metadata. The package-adapter tests verify manager-specific argument arrays and unsupported fallback without running package managers.

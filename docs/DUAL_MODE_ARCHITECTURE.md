# WINUX11: Dual-Kernel Windows/Linux Architecture

## Product goal

Build a bootable operating-system product with two separate environments:

- **Windows Mode** boots a genuine, user-licensed Microsoft Windows installation and uses the Windows NT kernel, Windows services, native Windows applications, drivers, and system APIs.
- **Linux Mode** boots WINUX11 Linux and the Linux kernel, using a Windows-11-inspired shell plus native Linux applications and developer/security tools.

A Linux kernel cannot run the Windows NT kernel natively inside the same kernel instance. A desktop shell cannot switch kernels in-place. Moving between these environments requires a reboot, unless Windows is run as a virtual machine, which has different RAM and performance costs.

## Chosen architecture: dual boot

1. UEFI firmware and a shared EFI System Partition.
2. A boot manager with separate entries for Windows Boot Manager and WINUX11 Linux.
3. A genuine Windows installation, installed and activated by the owner under Microsoft's license.
4. A separate Linux root filesystem containing the WINUX11 desktop, apps, services, and Linux kernel.
5. A mode-switch service in each environment that selects the next boot target and restarts only after explicit confirmation.
6. A recovery path that preserves both boot entries and never overwrites the other OS's EFI files.

The switch button must say **Switch to Windows Mode (restart required)** or **Switch to Linux Mode (restart required)**. It must never imply an instantaneous kernel swap.

## Windows Mode

Windows Mode is not a reimplementation. It boots the actual installed Windows OS, preserving Windows compatibility and system features. WINUX11 may offer optional startup-app controls and optimization guidance, but must not patch protected Windows binaries, bypass activation, silently disable security protections, or promise lower memory usage on every machine.

Download Windows directly from Microsoft's official page: https://www.microsoft.com/software-download/windows11. The ISO is not committed to GitHub, mirrored, or bundled into WINUX11 releases. Installation requires the user's own valid license and compatible hardware.

## Linux Mode

- Linux kernel and Linux-native system services.
- WINUX11 compositor/shell with a high-fidelity Windows-11-like desktop layout.
- A dark Linux-oriented appearance profile with Linux app names/icons, enabled by a desktop toggle without changing the kernel.
- Native Linux programs and tools, launcher, file associations, terminal, package management, developer tools, and system monitoring.
- Real application launches and visible error handling, not mock windows.

## Two separate switches

1. **Appearance profile**: Windows-style / Linux-dark. Changes shell theme, icon set, labels, launcher organization, and desktop presentation immediately. It does not change the OS or kernel.
2. **Operating-system mode**: Windows Mode / Linux Mode. Selects which installed OS boots next and requires a restart. The UI must explain the restart and ask for confirmation.

Never label a theme switch as a kernel switch.

## RAM and performance requirements

Memory usage is measured, not promised. Record idle and workload RSS/PSS, boot-to-desktop time, startup services, CPU/GPU load, and application launch time on identical hardware. Linux Mode should have a minimal default service set and lazy-start optional services. Windows Mode uses the real Windows kernel and can only be optimized within supported settings; it cannot inherit Linux's lower baseline while Windows itself is running.

## Security and data boundaries

- Never mount or modify Windows system partitions read-write from Linux by default.
- Do not share Windows credentials or authentication tokens with Linux services.
- Do not copy proprietary Windows executables, DLLs, fonts, wallpapers, icons, or other assets into this public repository unless the specific asset's license permits redistribution.
- Keep user-selected ISO files and extracted non-redistributable assets local and outside Git.
- Verify ISO hashes where Microsoft publishes them and keep a recovery USB/backup before partition changes.
- Boot-mode changes must be reversible and require explicit user confirmation.

## Delivery phases and acceptance gates

### Phase 0 — Architecture and safety
- Document dual-boot topology and constraints.
- Detect UEFI/BIOS, Secure Boot, disk layout, and existing OS without changing partitions.
- Provide a dry-run boot-entry inspector.

### Phase 1 — Stable Linux Mode
- Fix compositor startup, Wayland socket lifecycle, invalid xdg_toplevel sizes, focus handling, and shell crash reporting.
- Pass clean build, unit tests, QML validation, install validation, and a repeatable VM smoke test before enabling automatic session entry.
- Preserve a safe route back to the current Ubuntu desktop.

### Phase 2 — Visual and interaction parity
- Build a tokenized theme system, vector icon set, responsive taskbar/Start/search/quick settings/notification center, window animations, keyboard navigation, accessibility, and RTL support.
- Use licensed or original assets in the public repository; allow a local-only asset import pipeline for reference assets.
- Test every visible control and keyboard shortcut.

### Phase 3 — Linux application ecosystem
- Complete Files, Settings, Terminal, text editor, task manager, software center, archive utility, screenshot, calculator, media apps, and package-management integration.
- Launch real Linux applications through desktop-entry metadata and handle failures visibly.

### Phase 4 — Windows installation and boot integration
- Only after explicit confirmation and a verified backup: inspect disks read-only, then provide a guided installer that never repartitions automatically.
- Detect Windows Boot Manager and add a reversible boot-menu entry without replacing Windows EFI files.
- Implement next-boot selection with authorization, confirmation, timeout, and recovery safeguards.

### Phase 5 — Performance and release validation
- Compare screenshots at identical resolution/scaling.
- Run functional, accessibility, boot/recovery, filesystem-boundary, and security tests.
- Publish measured RAM/performance results with hardware and workload stated.
- Do not claim complete until release gates pass on physical hardware and a VM.

## Explicit non-goals

- Reimplementing the entire proprietary Windows OS from scratch.
- Embedding Microsoft's Windows kernel into the Linux kernel.
- Redistributing the Windows ISO or proprietary Windows binaries from this public repository.
- Claiming exact one-pixel parity or universally lower RAM usage before measurement.
- Automatically modifying disks, boot records, Secure Boot, or Windows settings without informed confirmation.

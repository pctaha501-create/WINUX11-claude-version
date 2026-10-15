# WINUX11 — Windows-first runtime architecture

## Product decision

WINUX11 must start into the Windows desktop by default. The user must not be dropped into a Linux desktop first, and changing the visual style must never trigger a reboot or a second boot/loading sequence.

## Runtime model

- **Primary desktop:** a genuine, user-licensed Windows installation is the host and the default boot target.
- **Linux environment:** Linux tools and applications are integrated through WSL2 (or another explicitly selected virtualization backend when WSL2 is unavailable). Linux workloads may use a Linux kernel inside the managed virtualized environment, while Windows remains the host.
- **No fake kernel switch:** Windows NT and Linux cannot both replace one another as the active host kernel in the same running OS session. A true dual-boot switch would require reboot, so it is not the default interaction for this product.
- **Appearance profiles:** Windows-inspired and Linux-dark profiles are UI themes, not operating-system/kernel switches. Switching profiles applies immediately without rebooting.
- **Boot experience:** show a WINUX11 branded, animated startup experience during startup where the platform permits it, then transition into the Windows desktop. Do not show a second artificial loading screen when changing themes or opening Linux tools.

## Branding

The desktop footer/status area may show concise attribution such as `WINUX11 · Microsoft Windows · Linux · MMD Studio`. WINUX11 is an independent project; attribution must not imply endorsement by Microsoft or Linux kernel contributors. Use approved/original artwork and avoid redistributing proprietary Microsoft binaries, fonts, wallpapers, or extracted system assets in the public repository.

## Boot animation requirements

- Use an original WINUX11 identity and a polished motion design: layered light trails/particles, restrained glow, a progress indicator tied to real startup milestones where available, and short status text.
- Respect reduced-motion and accessibility settings.
- Keep the animation lightweight, avoid blocking the host desktop startup, and fall back to a static branded screen if animation support is unavailable.
- Never fake precise progress when no real progress signal exists; use milestone labels or an indeterminate animation instead.
- The animation must not delay access to the desktop once the host is ready.

## Safety and implementation gates

1. Treat the existing unstable Linux compositor/shell as a separate issue; do not make it the required login path for the Windows-first product.
2. Build and test a Windows-first launcher/experience before adding boot integration.
3. Keep any bootloader or disk-layout changes opt-in, documented, backed up, and reversible. Never repartition or alter the user's boot configuration automatically.
4. Measure cold boot time, idle RAM, CPU/GPU use, and theme-switch latency on supported hardware before making performance claims.
5. Do not claim a complete OS or pixel-perfect Windows parity until tested against explicit acceptance criteria.

## Windows ISO and proprietary assets

Obtain Windows installation media directly from Microsoft's official download page and use it only under the applicable license terms. Keep the ISO and proprietary system assets out of the public GitHub repository. The repository may include instructions and tooling for a local-only asset/reference workflow, not redistributed Windows files.

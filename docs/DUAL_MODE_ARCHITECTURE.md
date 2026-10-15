# WINUX11 — Windows-first runtime architecture

## Product decision

WINUX11 must start into the Windows desktop by default. The user must not be dropped into a Linux desktop first, and changing the visual style must never trigger a reboot or a second boot/loading sequence.

## Runtime model

- **Primary desktop:** a genuine, user-licensed Windows installation is the host and the default boot target.
- **Linux environment:** Linux tools and applications are integrated through WSL2 (or another explicitly selected virtualization backend when WSL2 is unavailable). Linux workloads may use a Linux kernel inside the managed virtualized environment, while Windows remains the host.
- **No fake kernel switch:** Windows NT and Linux cannot both replace one another as the active host kernel in the same running OS session. A true dual-boot switch would require reboot, so it is not the default interaction for this product.
- **Appearance profiles:** Windows-inspired and Linux-dark profiles are UI themes, not operating-system/kernel switches. Switching profiles applies immediately without rebooting.
- **Boot experience:** show a WINUX11 branded, animated startup experience during startup where the platform permits it, then transition into the Windows desktop. Do not show a second artificial loading screen when changing themes or opening Linux tools.

## Desktop branding preference

- Provide a setting at **Settings → Desktop → Branding** named **Show desktop attribution**.
- The attribution is enabled by default and displays `WINUX11` with the secondary line `Microsoft Windows · Linux · MMD Studio` in a compact desktop footer/status area.
- Users can turn the setting off to remove the entire attribution block from the desktop. It must not leave a blank reserved area when hidden.
- Allow users to edit the title and secondary line; persist the preference across sign-ins and restarts.
- The branding preference is independent of theme selection and must update immediately without rebooting.
- Keep contrast accessible and the footer unobtrusive. Attribution must not imply official endorsement by Microsoft or Linux kernel contributors; WINUX11 is an independent project.

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

Obtain Windows installation media directly from Microsoft's official download page and use it only under the applicable license terms. Keep the ISO and proprietary Windows system assets out of the public GitHub repository. The repository may include instructions and tooling for a local-only asset/reference workflow, not redistributed Windows files.

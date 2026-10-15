# WINUX11 asset and startup experience pipeline

## Public repository policy

The public repository should contain original WINUX11 artwork, code, design tokens, and documentation. Do not commit a Windows ISO or extracted proprietary Windows system assets (including system fonts, wallpapers, icons, sounds, or binaries) unless redistribution is explicitly authorized.

## Windows reference media

Download official Windows installation media from Microsoft's Windows 11 download page: https://www.microsoft.com/software-download/windows11. Review the applicable license terms before using any extracted material. Keep the ISO and extracted reference assets local to the developer machine; do not upload them to this repository.

## Desktop attribution setting

Add a **Settings → Desktop → Branding** preference named **Show desktop attribution**. It is on by default and shows a compact footer with `WINUX11` and `Microsoft Windows · Linux · MMD Studio`. Turning it off removes the entire footer and its reserved layout space. Let users edit both text lines and persist their choice across sign-ins/restarts. Apply changes immediately, without rebooting. Keep the feature independent of the active appearance profile.

## WINUX11 startup animation

Create an original, lightweight animation using project-owned assets. Suggested sequence:

1. Fade in the WINUX11 mark over a dark, softly illuminated background.
2. Introduce moving light trails and a small amount of particle motion; avoid heavy full-screen effects.
3. Display concise startup milestones only when the application/platform can observe them. Otherwise use an indeterminate progress treatment rather than fabricated percentages.
4. Transition smoothly to the desktop without delaying the point at which the user can interact.
5. Respect reduced-motion settings and provide a static fallback.

## Runtime constraints

- Windows is the default host and startup target.
- Linux applications run through WSL2 or a documented virtualization backend.
- Appearance switching is a live UI preference and must not reboot the machine.
- Do not use a custom Linux compositor as the mandatory Windows login shell.
- Validate cold boot time, idle resource use, fallback behavior, and theme-switch latency on real supported configurations.

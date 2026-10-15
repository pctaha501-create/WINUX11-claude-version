# WINUX11 Asset Pipeline and Windows Visual Reference

## Goal

Create a repeatable asset workflow for a high-fidelity Windows-11-like interface while keeping the public repository redistributable and builds reproducible.

## Public assets

The repository may contain original SVG icons, original wallpapers, original QML animations, and assets whose license explicitly permits redistribution. Each third-party asset must have a recorded source URL and license in assets/ATTRIBUTIONS.md.

## Local-only Microsoft reference assets

A developer may download a Windows ISO from Microsoft's official download page and inspect its contents locally for visual research. Do not upload the ISO or proprietary extracted files to the public GitHub repository. Keep local imports outside the Git worktree or in an ignored local directory such as .local-assets/. Include only a manifest and import scripts in Git. The import tool must refuse to copy files into tracked paths unless the user confirms that the files are licensed for redistribution.

## Suggested local inspection workflow

1. Download the ISO directly from Microsoft: https://www.microsoft.com/software-download/windows11
2. Verify the ISO's integrity using Microsoft's published hash when available.
3. Mount/read the ISO without installing Windows.
4. Inspect sources/install.wim or sources/install.esd using a suitable WIM/ESD reader. Do not modify the source image.
5. Record candidate resource paths and screenshots in a local research manifest; avoid extracting entire Windows system trees unnecessarily.
6. For each candidate asset, decide whether to recreate it as an original SVG/QML equivalent, use it only as a local reference, or include it only after confirming redistribution rights.
7. Test theme rendering at 100%, 125%, and 150% scaling, plus dark/light variants and RTL layouts.

## UI implementation principles

- Prefer scalable SVG icons and consistent icon sizes/strokes over copied opaque binaries.
- Use design tokens for colors, radii, spacing, elevation, typography, animation duration, and easing.
- Animate opacity and transforms rather than expensive blur on low-end GPUs; provide reduced-motion and software-rendering fallbacks.
- Ensure interactive elements have accessible labels, focus indicators, keyboard navigation, and tested actions.
- Keep app identity and icon mapping in a registry so appearance profiles can swap desktop presentation without renaming or breaking executable paths.
- Separate visual profile changes from the OS boot-mode switch.

## Acceptance checklist

- No unlicensed or untracked binary assets enter public commits.
- Every visible icon maps to a real action or a clearly disabled capability.
- QML loads under the supported Qt runtime and software-rendering fallback.
- No invalid window sizes are sent to xdg_toplevel.
- UI transitions respect reduced-motion settings and do not block the event loop.
- Asset import, theme switching, and installation are covered by tests.

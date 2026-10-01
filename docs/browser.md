# Browser

WINUX11 uses Qt WebEngine Quick when the development component is installed. The browser target is deliberately optional at CMake configure time so the rest of the desktop remains buildable on systems that do not ship Qt WebEngine.

When Qt WebEngine is available, the browser application is the embedded QML WebEngine implementation. When it is unavailable, the installed winux11-browser binary delegates the requested URL to the system's registered browser instead of presenting a fake browser UI.

#include "compositor.h"

WindowSurface::WindowSurface(QWaylandXdgToplevel *topLevel, QObject *parent)
    : QObject(parent), m_topLevel(topLevel) {}

WinuxCompositor::WinuxCompositor(QObject *parent) : QWaylandCompositor(parent) {
    m_xdgShell.setCompositor(this);
    connect(&m_xdgShell, &QWaylandXdgShell::toplevelCreated,
            this, &WinuxCompositor::onNewToplevel);
    auto *output = new QWaylandOutput(this);
    output->setGeometry(QRect(0, 0, 1920, 1080));
    output->setPhysicalSize(QSize(600, 340));
    output->setScaleFactor(1.0);
    output->create();
}

void WinuxCompositor::onNewToplevel(QWaylandXdgToplevel *toplevel) {
    auto *window = new WindowSurface(toplevel, this);
    m_windows.push_back(window);
    connect(toplevel, &QObject::destroyed, this, &WinuxCompositor::onToplevelDestroyed);
    connect(toplevel, &QWaylandXdgToplevel::requestActivate, this,
            [this, window] { activate(window); });
    connect(toplevel, &QWaylandXdgToplevel::setMinimized, this,
            [window] { window->setMinimized(true); });
    connect(toplevel, &QWaylandXdgToplevel::setMaximized, this,
            [window] { window->setMaximized(true); });
    connect(toplevel, &QWaylandXdgToplevel::unsetMaximized, this,
            [window] { window->setMaximized(false); });
    connect(toplevel, &QWaylandXdgToplevel::setFullscreen, this,
            [window] { window->setFullscreen(true); });
    connect(toplevel, &QWaylandXdgToplevel::unsetFullscreen, this,
            [window] { window->setFullscreen(false); });
    emit windowAdded(window);
    activate(window);
    toplevel->sendConfigure();
}

void WinuxCompositor::onToplevelDestroyed() {
    for (int i = m_windows.size() - 1; i >= 0; --i) {
        if (m_windows[i]->topLevel().isNull()) {
            auto *removed = m_windows.takeAt(i);
            if (m_active == removed) m_active = nullptr;
            emit windowRemoved(removed);
            removed->deleteLater();
        }
    }
}

void WinuxCompositor::activate(WindowSurface *window) {
    if (!window || !window->topLevel() || window->workspace() != m_activeWorkspace) return;
    if (m_active && m_active->topLevel()) m_active->topLevel()->setActivated(false);
    m_active = window;
    window->topLevel()->setActivated(true);
    emit activeWindowChanged(window);
}

void WinuxCompositor::moveWorkspace(WindowSurface *window, int workspace) {
    if (!window || !window->topLevel() || workspace < 0) return;
    window->setWorkspace(workspace);
    if (workspace != m_activeWorkspace) window->topLevel()->setActivated(false);
}

void WinuxCompositor::setWorkspace(int workspace) {
    if (workspace < 0 || workspace == m_activeWorkspace) return;
    m_activeWorkspace = workspace;
    if (m_active && m_active->topLevel()) m_active->topLevel()->setActivated(false);
    m_active = nullptr;
    for (auto *window : m_windows) {
        if (window->workspace() == workspace) {
            activate(window);
            break;
        }
    }
    emit workspaceChanged(workspace);
}

#pragma once
#include <QWaylandCompositor>
#include <QWaylandXdgShell>
#include <QWaylandOutput>
#include <QPointer>
#include <QVector>

class WindowSurface final : public QObject {
    Q_OBJECT
public:
    explicit WindowSurface(QWaylandXdgToplevel *topLevel, QObject *parent = nullptr);
    QWaylandXdgToplevel *topLevel() const { return m_topLevel; }
    int workspace() const { return m_workspace; }
    void setWorkspace(int value) { m_workspace = value; }
    bool minimized() const { return m_minimized; }
    bool maximized() const { return m_maximized; }
    bool fullscreen() const { return m_fullscreen; }
    void setMinimized(bool v) { m_minimized = v; }
    void setMaximized(bool v) { m_maximized = v; }
    void setFullscreen(bool v) { m_fullscreen = v; }
private:
    QPointer<QWaylandXdgToplevel> m_topLevel;
    int m_workspace = 0;
    bool m_minimized = false;
    bool m_maximized = false;
    bool m_fullscreen = false;
};

class WinuxCompositor final : public QWaylandCompositor {
    Q_OBJECT
public:
    explicit WinuxCompositor(QObject *parent = nullptr);
    int activeWorkspace() const { return m_activeWorkspace; }
    void activate(WindowSurface *window);
    void moveWorkspace(WindowSurface *window, int workspace);
    void setWorkspace(int workspace);
signals:
    void windowAdded(WindowSurface *window);
    void windowRemoved(WindowSurface *window);
    void activeWindowChanged(WindowSurface *window);
    void workspaceChanged(int workspace);
private slots:
    void onNewToplevel(QWaylandXdgToplevel *toplevel);
    void onToplevelDestroyed();
private:
    QWaylandXdgShell m_xdgShell;
    QVector<WindowSurface*> m_windows;
    QPointer<WindowSurface> m_active;
    int m_activeWorkspace = 0;
};

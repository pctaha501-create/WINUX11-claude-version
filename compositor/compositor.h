#pragma once
#include <QWaylandCompositor>
#include <QWaylandXdgShell>
#include <QWaylandOutput>
#include <QWaylandSeat>
#include <QWaylandQuickShellSurfaceItem>
#include <QQuickWindow>
#include <QQmlEngine>
#include <QPointer>
#include <QVector>

class WindowSurface final : public QObject {
    Q_OBJECT
public:
    explicit WindowSurface(QWaylandXdgToplevel *topLevel, QObject *parent = nullptr);
    QWaylandXdgToplevel *topLevel() const { return m_topLevel; }
    QWaylandQuickShellSurfaceItem *item() const { return m_item; }
    void setItem(QWaylandQuickShellSurfaceItem *item) { m_item = item; }
    int workspace() const { return m_workspace; }
    void setWorkspace(int value) { m_workspace = value; }
    bool minimized() const { return m_minimized; }
    void setMinimized(bool v) { m_minimized = v; }
private:
    QPointer<QWaylandXdgToplevel> m_topLevel;
    QPointer<QWaylandQuickShellSurfaceItem> m_item;
    int m_workspace = 0;
    bool m_minimized = false;
};

class WinuxCompositor final : public QWaylandCompositor {
    Q_OBJECT
public:
    explicit WinuxCompositor(QObject *parent = nullptr);
    void create() override;
    int activeWorkspace() const { return m_activeWorkspace; }
    void activate(WindowSurface *window);
    void moveWorkspace(WindowSurface *window, int workspace);
    void setWorkspace(int workspace);
signals:
    void windowAdded(WindowSurface *window);
    void windowRemoved(WindowSurface *window);
    void activeWindowChanged(WindowSurface *window);
    void workspaceChanged(int workspace);
protected:
    bool eventFilter(QObject *watched, QEvent *event) override;
private slots:
    void onNewToplevel(QWaylandXdgToplevel *toplevel, QWaylandXdgSurface *surface);
    void onToplevelDestroyed();
private:
    QQuickWindow m_window;
    QQmlEngine m_qmlEngine;
    QWaylandXdgShell m_xdgShell;
    QWaylandSeat *m_seat = nullptr;
    QWaylandOutput *m_output = nullptr;
    QVector<WindowSurface*> m_windows;
    QPointer<WindowSurface> m_active;
    int m_activeWorkspace = 0;
    bool m_initialized = false;
};

#pragma once
#include <QWaylandCompositor>
#include <QWaylandXdgShell>
#include <QWaylandOutput>
#include <QWaylandSeat>
#include <QWaylandQuickShellSurfaceItem>
#include <QQuickWindow>
#include <QPointer>
#include <QVariantList>
#include <QVector>
#include <QPointF>
#include <QRectF>
class ShellIpcServer;
class WindowSurface final:public QObject{
 Q_OBJECT
 Q_PROPERTY(QString title READ title NOTIFY titleChanged)
public:
 explicit WindowSurface(QWaylandXdgToplevel *topLevel,QObject *parent=nullptr);
 QString title()const;
 QWaylandXdgToplevel *topLevel()const{return m_topLevel;}
 QWaylandQuickShellSurfaceItem *item()const{return m_item;}
 void setItem(QWaylandQuickShellSurfaceItem *item){m_item=item;}
 int workspace()const{return m_workspace;}
 void setWorkspace(int value){m_workspace=value;}
 bool minimized()const{return m_minimized;}
 void setMinimized(bool v){m_minimized=v;}
 void saveGeometry();void restoreGeometry();
signals:void titleChanged();
private:
 QPointer<QWaylandXdgToplevel> m_topLevel;QPointer<QWaylandQuickShellSurfaceItem> m_item;
 int m_workspace=0;bool m_minimized=false;QRectF m_savedGeometry;bool m_hasSavedGeometry=false;
};
class WinuxCompositor final:public QWaylandCompositor{
 Q_OBJECT
public:
 explicit WinuxCompositor(QObject *parent=nullptr);
 void create()override;
 QVariantList windowList()const;
 Q_INVOKABLE void activateIndex(int index);
 Q_INVOKABLE bool launchApplication(const QString &name);
 Q_INVOKABLE void minimizeActive();
 Q_INVOKABLE void restoreWindow(int index);
 Q_INVOKABLE void closeActive();
 Q_INVOKABLE void maximizeActive();
 Q_INVOKABLE void toggleFullscreenActive();
 Q_INVOKABLE void snapActive(const QString &side);
 Q_INVOKABLE void moveActive(int dx,int dy);
 Q_INVOKABLE void resizeActive(int dw,int dh);
 int activeWorkspace()const{return m_activeWorkspace;}
 void activate(WindowSurface *window);void moveWorkspace(WindowSurface *window,int workspace);void setWorkspace(int workspace);
signals:void windowAdded(WindowSurface*);void windowRemoved(WindowSurface*);void activeWindowChanged(WindowSurface*);void workspaceChanged(int);void windowListChanged();
protected:bool eventFilter(QObject *watched,QEvent *event)override;
private slots:void onNewToplevel(QWaylandXdgToplevel*,QWaylandXdgSurface*);void onToplevelDestroyed();
private:
 QWaylandQuickShellSurfaceItem *windowAt(const QPointF &pos)const;
 WindowSurface *surfaceAt(const QPointF &pos)const;
 bool handlePointerEvent(QEvent *event);
 void finishPointerGrab();
 QQuickWindow m_window;QWaylandXdgShell m_xdgShell;QWaylandSeat *m_seat=nullptr;QWaylandOutput *m_output=nullptr;
 QVector<WindowSurface*> m_windows;QPointer<WindowSurface> m_active;int m_activeWorkspace=0;bool m_initialized=false;
 ShellIpcServer *m_shellIpc=nullptr;
 QPointer<WindowSurface> m_pointerGrabWindow;QPointF m_pointerGrabStart;QRectF m_pointerGrabGeometry;Qt::MouseButton m_pointerGrabButton=Qt::NoButton;bool m_pointerMoveGrab=false;bool m_pointerResizeGrab=false;int m_nextZ=1;
};
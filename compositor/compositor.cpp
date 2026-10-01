#include "compositor.h"
#include <QEvent>
#include <QKeyEvent>
#include <QProcess>
#include <QWaylandOutputMode>
#include <QQmlComponent>
#include <QUrl>
WindowSurface::WindowSurface(QWaylandXdgToplevel *topLevel,QObject *parent):QObject(parent),m_topLevel(topLevel){
 connect(topLevel,&QWaylandXdgToplevel::titleChanged,this,&WindowSurface::titleChanged);
}
QString WindowSurface::title()const{return m_topLevel?m_topLevel->title():QStringLiteral("Window");}
WinuxCompositor::WinuxCompositor(QObject *parent):QWaylandCompositor(parent),m_xdgShell(this){
 connect(&m_xdgShell,&QWaylandXdgShell::toplevelCreated,this,&WinuxCompositor::onNewToplevel);
 m_window.setTitle("WINUX11");m_window.setColor(QColor("#090b10"));m_window.resize(1920,1080);m_window.installEventFilter(this);
}
void WinuxCompositor::create(){
 if(m_initialized)return;m_initialized=true;QWaylandCompositor::create();
 m_seat=new QWaylandSeat(this,QWaylandSeat::Pointer|QWaylandSeat::Keyboard);m_seat->setObjectName("WINUX11 Seat");m_seat->initialize();
 m_output=new QWaylandOutput(this,&m_window);const QWaylandOutputMode mode(QSize(1920,1080),60000);
 m_output->addMode(mode,true);m_output->setCurrentMode(mode);m_output->setPhysicalSize(QSize(600,340));m_output->setScaleFactor(1);m_output->setManufacturer("WINUX11");m_output->setModel("WINUX11 Virtual Display");
 QQmlComponent shell(&m_qmlEngine);shell.loadUrl(QUrl("qrc:/shell_qml/Shell.qml"));if(shell.isReady())shell.create(m_window.contentItem());
 m_qmlEngine.rootContext()->setContextProperty("winuxCompositor",this);m_window.show();
}
bool WinuxCompositor::eventFilter(QObject *watched,QEvent *event){
 if(watched==&m_window&&m_seat&&event->type()==QEvent::KeyPress){
  auto *key=static_cast<QKeyEvent*>(event);
  if(key->modifiers().testFlag(Qt::ControlModifier)){
   if(key->key()>=Qt::Key_F1&&key->key()<=Qt::Key_F4){setWorkspace(key->key()-Qt::Key_F1);return true;}
  }
  if(key->modifiers().testFlag(Qt::AltModifier)&&key->key()==Qt::Key_Tab){activateIndex(m_active?((m_windows.indexOf(m_active)+1)%m_windows.size()):0);return true;}
  m_seat->sendFullKeyEvent(key);
 }
 return QWaylandCompositor::eventFilter(watched,event);
}
QVariantList WinuxCompositor::windowList()const{QVariantList out;for(auto *w:m_windows)out<<QVariant::fromValue(static_cast<QObject*>(w));return out;}
void WinuxCompositor::activateIndex(int index){if(index<0||index>=m_windows.size())return;activate(m_windows[index]);}
bool WinuxCompositor::launchApplication(const QString &name){
 const QHash<QString,QString> apps{{"Terminal","winux11-terminal"},{"Files","winux11-explorer"},{"Settings","winux11-settings"},{"Task Manager","winux11-taskmanager"},{"Security Center","winux11-security"},{"Browser","winux11-browser"}};
 const auto it=apps.find(name);if(it==apps.end())return false;return QProcess::startDetached(it.value(),{});
}
void WinuxCompositor::minimizeActive(){if(!m_active||!m_active->item())return;m_active->setMinimized(true);m_active->item()->setVisible(false);m_active=nullptr;emit windowListChanged();}
void WinuxCompositor::restoreWindow(int index){if(index<0||index>=m_windows.size())return;auto *w=m_windows[index];w->setMinimized(false);w->item()->setVisible(w->workspace()==m_activeWorkspace);activate(w);emit windowListChanged();}
void WinuxCompositor::closeActive(){if(m_active&&m_active->topLevel())m_active->topLevel()->sendClose();}
void WinuxCompositor::onNewToplevel(QWaylandXdgToplevel *toplevel,QWaylandXdgSurface *surface){
 Q_UNUSED(surface);auto *window=new WindowSurface(toplevel,this);m_windows.push_back(window);
 auto *item=new QWaylandQuickShellSurfaceItem(m_window.contentItem());item->setShellSurface(toplevel->xdgSurface());item->setFocusOnClick(true);item->setAutoCreatePopupItems(true);window->setItem(item);
 connect(toplevel,&QObject::destroyed,this,&WinuxCompositor::onToplevelDestroyed);connect(toplevel,&QWaylandXdgToplevel::activatedChanged,this,[this,window]{if(window->topLevel()&&window->topLevel()->activated())activate(window);});
 emit windowAdded(window);emit windowListChanged();activate(window);
}
void WinuxCompositor::onToplevelDestroyed(){for(int i=m_windows.size()-1;i>=0;--i)if(m_windows[i]->topLevel().isNull()){auto *r=m_windows.takeAt(i);if(m_active==r)m_active=nullptr;emit windowRemoved(r);r->deleteLater();}emit windowListChanged();}
void WinuxCompositor::activate(WindowSurface *window){
 if(!window||!window->topLevel()||window->workspace()!=m_activeWorkspace||window->minimized())return;if(m_active==window)return;
 if(m_active&&m_active->topLevel())m_active->topLevel()->sendConfigure(QSize(),{QWaylandXdgToplevel::ActivatedState});
 m_active=window;if(m_seat&&window->topLevel()->surface())m_seat->setKeyboardFocus(window->topLevel()->surface());
 window->topLevel()->sendConfigure(QSize(),{QWaylandXdgToplevel::ActivatedState});emit activeWindowChanged(window);emit windowListChanged();
}
void WinuxCompositor::moveWorkspace(WindowSurface *window,int workspace){if(!window||!window->item()||workspace<0)return;window->setWorkspace(workspace);window->item()->setVisible(workspace==m_activeWorkspace&&!window->minimized());emit windowListChanged();}
void WinuxCompositor::setWorkspace(int workspace){if(workspace<0||workspace==m_activeWorkspace)return;m_activeWorkspace=workspace;m_active=nullptr;if(m_seat)m_seat->setKeyboardFocus(nullptr);for(auto *w:m_windows)if(w->item())w->item()->setVisible(w->workspace()==workspace&&!w->minimized());for(auto *w:m_windows)if(w->workspace()==workspace&&!w->minimized()){activate(w);break;}emit workspaceChanged(workspace);emit windowListChanged();}

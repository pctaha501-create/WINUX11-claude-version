#include "compositor.h"
#include "shell_ipc.h"
#include <QEvent>
#include <QKeyEvent>
#include <QProcess>
#include <QWaylandOutputMode>
WinuxCompositor::WinuxCompositor(QObject *parent):QWaylandCompositor(parent),m_xdgShell(this){
 connect(&m_xdgShell,&QWaylandXdgShell::toplevelCreated,this,&WinuxCompositor::onNewToplevel);
 m_window.setTitle("WINUX11");m_window.setColor(QColor("#090b10"));m_window.resize(1920,1080);m_window.installEventFilter(this);
}
WindowSurface::WindowSurface(QWaylandXdgToplevel *topLevel,QObject *parent):QObject(parent),m_topLevel(topLevel){connect(topLevel,&QWaylandXdgToplevel::titleChanged,this,&WindowSurface::titleChanged);}
QString WindowSurface::title()const{return m_topLevel?m_topLevel->title():QStringLiteral("Window");}
void WinuxCompositor::create(){
 if(m_initialized)return;m_initialized=true;QWaylandCompositor::create();
 m_seat=new QWaylandSeat(this,QWaylandSeat::Pointer|QWaylandSeat::Keyboard);m_seat->initialize();
 m_output=new QWaylandOutput(this,&m_window);const QWaylandOutputMode mode(QSize(1920,1080),60000);m_output->addMode(mode,true);m_output->setCurrentMode(mode);m_output->setPhysicalSize(QSize(600,340));m_output->setScaleFactor(1);m_output->setManufacturer("WINUX11");m_output->setModel("WINUX11 Virtual Display");
 m_shellIpc=new ShellIpcServer(this,this);if(!m_shellIpc->start())qWarning()<<"WINUX11 shell IPC unavailable:"<<m_shellIpc->socketPath();
 m_window.show();
}
bool WinuxCompositor::eventFilter(QObject *watched,QEvent *event){
 if(watched==&m_window&&m_seat&&event->type()==QEvent::KeyPress){
  auto *key=static_cast<QKeyEvent*>(event);
  if(key->modifiers().testFlag(Qt::ControlModifier)&&key->key()>=Qt::Key_F1&&key->key()<=Qt::Key_F4){setWorkspace(key->key()-Qt::Key_F1);return true;}
  if(key->modifiers().testFlag(Qt::AltModifier)&&key->key()==Qt::Key_Tab){if(!m_windows.isEmpty())activateIndex(m_active?((m_windows.indexOf(m_active)+1)%m_windows.size()):0);return true;}
  m_seat->sendFullKeyEvent(key);
 }
 return QWaylandCompositor::eventFilter(watched,event);
}
QVariantList WinuxCompositor::windowList()const{QVariantList out;for(auto *w:m_windows)out<<QVariant::fromValue(static_cast<QObject*>(w));return out;}
void WinuxCompositor::activateIndex(int i){if(i>=0&&i<m_windows.size())activate(m_windows[i]);}
bool WinuxCompositor::launchApplication(const QString &name){
 const QHash<QString,QString> apps{{"Terminal","winux11-terminal"},{"Files","winux11-explorer"},{"Settings","winux11-settings"},{"Task Manager","winux11-taskmanager"},{"Security Center","winux11-security"},{"Browser","winux11-browser"},{"Software Center","winux11-softwarecenter"},{"Network","winux11-network"},{"Downloader","winux11-downloader"},{"Archive Manager","winux11-archive"},{"Screenshot","winux11-screenshot"}};
 const auto it=apps.find(name);return it!=apps.end()&&QProcess::startDetached(it.value(),{});
}
void WinuxCompositor::minimizeActive(){if(!m_active||!m_active->item())return;m_active->setMinimized(true);m_active->item()->setVisible(false);m_active=nullptr;emit windowListChanged();}
void WinuxCompositor::restoreWindow(int i){if(i<0||i>=m_windows.size())return;auto *w=m_windows[i];w->setMinimized(false);w->item()->setVisible(w->workspace()==m_activeWorkspace);activate(w);emit windowListChanged();}
void WinuxCompositor::closeActive(){if(m_active&&m_active->topLevel())m_active->topLevel()->sendClose();}
void WinuxCompositor::onNewToplevel(QWaylandXdgToplevel *toplevel,QWaylandXdgSurface *surface){
 Q_UNUSED(surface);auto *window=new WindowSurface(toplevel,this);m_windows.push_back(window);
 auto *item=new QWaylandQuickShellSurfaceItem(m_window.contentItem());item->setShellSurface(toplevel->xdgSurface());item->setFocusOnClick(true);item->setAutoCreatePopupItems(true);window->setItem(item);
 connect(toplevel,&QObject::destroyed,this,&WinuxCompositor::onToplevelDestroyed);connect(toplevel,&QWaylandXdgToplevel::activatedChanged,this,[this,window]{if(window->topLevel()&&window->topLevel()->activated())activate(window);});
 emit windowAdded(window);emit windowListChanged();activate(window);
}
void WinuxCompositor::onToplevelDestroyed(){for(int i=m_windows.size()-1;i>=0;--i)if(m_windows[i]->topLevel().isNull()){auto *r=m_windows.takeAt(i);if(m_active==r)m_active=nullptr;emit windowRemoved(r);r->deleteLater();}emit windowListChanged();}
void WinuxCompositor::activate(WindowSurface *w){if(!w||!w->topLevel()||w->workspace()!=m_activeWorkspace||w->minimized())return;if(m_active==w)return;if(m_active&&m_active->topLevel())m_active->topLevel()->sendConfigure(QSize(),{QWaylandXdgToplevel::ActivatedState});m_active=w;if(m_seat&&w->topLevel()->surface())m_seat->setKeyboardFocus(w->topLevel()->surface());w->topLevel()->sendConfigure(QSize(),{QWaylandXdgToplevel::ActivatedState});emit activeWindowChanged(w);emit windowListChanged();}
void WinuxCompositor::moveWorkspace(WindowSurface *w,int ws){if(!w||!w->item()||ws<0)return;w->setWorkspace(ws);w->item()->setVisible(ws==m_activeWorkspace&&!w->minimized());emit windowListChanged();}
void WinuxCompositor::setWorkspace(int ws){if(ws<0||ws==m_activeWorkspace)return;m_activeWorkspace=ws;m_active=nullptr;if(m_seat)m_seat->setKeyboardFocus(nullptr);for(auto *w:m_windows)if(w->item())w->item()->setVisible(w->workspace()==ws&&!w->minimized());for(auto *w:m_windows)if(w->workspace()==ws&&!w->minimized()){activate(w);break;}emit workspaceChanged(ws);emit windowListChanged();}

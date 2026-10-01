#include "shell_ipc.h"
#include "compositor.h"
#include <QDir>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QLocalSocket>
ShellIpcServer::ShellIpcServer(WinuxCompositor *c,QObject *p):QObject(p),m_compositor(c){
 connect(&m_server,&QLocalServer::newConnection,this,&ShellIpcServer::handleClient);
 connect(c,&WinuxCompositor::windowListChanged,this,&ShellIpcServer::broadcast);
 connect(c,&WinuxCompositor::workspaceChanged,this,&ShellIpcServer::broadcast);
}
bool ShellIpcServer::start(){
 const QString runtime=QStandardPaths::writableLocation(QStandardPaths::RuntimeLocation);
 m_path=(runtime.isEmpty()?QStringLiteral("/tmp"):runtime)+"/winux11-shell.sock";
 QLocalServer::removeServer(m_path);
 m_server.setSocketOptions(QLocalServer::UserAccessOption);
 if(!m_server.listen(m_path))return false;
 return true;
}
void ShellIpcServer::handleClient(){
 while(m_server.hasPendingConnections()){
  auto *s=m_server.nextPendingConnection();m_clients<<s;
  connect(s,&QLocalSocket::readyRead,this,[this,s]{while(s->canReadLine())handleLine(s,s->readLine());});
  connect(s,&QLocalSocket::disconnected,this,[this,s]{m_clients.removeAll(s);s->deleteLater();});
  sendState(s);
 }
}
void ShellIpcServer::sendState(QLocalSocket *s){
 QJsonObject root;root["workspace"]=m_compositor->activeWorkspace();
 QJsonArray windows;
 const auto list=m_compositor->windowList();
 for(const auto &v:list){auto *o=v.value<QObject*>();if(!o)continue;auto *w=qobject_cast<WindowSurface*>(o);
  if(!w)continue;windows.append(QJsonObject{{"title",w->title()},{"workspace",w->workspace()},{"minimized",w->minimized()}});
 }
 root["windows"]=windows;
 s->write(QJsonDocument(root).toJson(QJsonDocument::Compact)+"\n");s->flush();
}
void ShellIpcServer::broadcast(){for(auto *s:m_clients)if(s&&s->state()==QLocalSocket::ConnectedState)sendState(s);}
void ShellIpcServer::handleLine(QLocalSocket *s,const QByteArray &line){
 const QString cmd=QString::fromUtf8(line).trimmed();const auto p=cmd.split(' ',Qt::KeepEmptyParts);if(p.isEmpty())return;
 if(p[0]=="activate"&&p.size()>1)m_compositor->activateIndex(p[1].toInt());
 else if(p[0]=="workspace"&&p.size()>1)m_compositor->setWorkspace(p[1].toInt());
 else if(p[0]=="launch"&&p.size()>1)m_compositor->launchApplication(p.mid(1).join(" "));
 else if(p[0]=="minimize")m_compositor->minimizeActive();
 else if(p[0]=="close")m_compositor->closeActive();
 else if(p[0]=="restore"&&p.size()>1)m_compositor->restoreWindow(p[1].toInt());
}

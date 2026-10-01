#include "shell_controller.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
ShellController::ShellController(QObject *p):QObject(p){connect(&m_socket,&QLocalSocket::readyRead,this,&ShellController::readState);connect(&m_socket,&QLocalSocket::errorOccurred,this,[this]{emit connectionFailed(m_socket.errorString());});}
bool ShellController::connectToCompositor(){
 const QString runtime=QStandardPaths::writableLocation(QStandardPaths::RuntimeLocation);
 const QString path=(runtime.isEmpty()?QStringLiteral("/tmp"):runtime)+"/winux11-shell.sock";
 m_socket.connectToServer(path);return true;
}
void ShellController::readState(){
 m_buffer+=m_socket.readAll();
 while(true){const int nl=m_buffer.indexOf('\n');if(nl<0)break;const QByteArray line=m_buffer.left(nl);m_buffer.remove(0,nl+1);
  QJsonParseError e;const auto doc=QJsonDocument::fromJson(line,&e);if(e.error!=QJsonParseError::NoError||!doc.isObject())continue;
  const auto root=doc.object();m_workspace=root.value("workspace").toInt();m_windows.clear();
  for(const auto &v:root.value("windows").toArray())m_windows<<v.toObject().toVariantMap();emit stateChanged();
 }
}
void ShellController::command(const QString &line){if(m_socket.state()==QLocalSocket::ConnectedState)m_socket.write(line.toUtf8()+"\n");}

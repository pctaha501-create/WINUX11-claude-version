#pragma once
#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QLocalServer>
#include <QPointer>
class WinuxCompositor;
class ShellIpcServer final:public QObject{
 Q_OBJECT
public:
 explicit ShellIpcServer(WinuxCompositor *compositor,QObject *parent=nullptr);
 bool start();
 void broadcast();
 QString socketPath()const{return m_path;}
private:
 void handleClient();
 void sendState(QLocalSocket *socket);
 void handleLine(QLocalSocket *socket,const QByteArray &line);
 WinuxCompositor *m_compositor;
 QLocalServer m_server;
 QList<QPointer<QLocalSocket>> m_clients;
 QString m_path;
};

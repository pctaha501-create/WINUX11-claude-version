#pragma once
#include <QObject>
#include <QVariantList>
#include <QLocalSocket>
class ShellController final:public QObject{
 Q_OBJECT
 Q_PROPERTY(QVariantList windows READ windows NOTIFY stateChanged)
 Q_PROPERTY(int workspace READ workspace NOTIFY stateChanged)
public:
 explicit ShellController(QObject *parent=nullptr);
 QVariantList windows()const{return m_windows;}
 int workspace()const{return m_workspace;}
 Q_INVOKABLE bool connectToCompositor();
 Q_INVOKABLE void command(const QString &line);
signals:void stateChanged();void connectionFailed(const QString &message);
private:
 void readState();QLocalSocket m_socket;QVariantList m_windows;int m_workspace=0;QByteArray m_buffer;
};

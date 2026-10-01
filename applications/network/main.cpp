#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/system_control_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);SystemControlService service;QQmlApplicationEngine e;e.rootContext()->setContextProperty("systemControl",&service);e.load(QUrl("qrc:/Network.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

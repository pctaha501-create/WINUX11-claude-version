#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "shell_controller.h"
int main(int argc,char **argv){
 QGuiApplication app(argc,argv);ShellController controller;QQmlApplicationEngine engine;
 engine.rootContext()->setContextProperty("shellController",&controller);
 engine.load(QUrl("qrc:/Shell.qml"));if(engine.rootObjects().isEmpty())return 1;
 controller.connectToCompositor();return app.exec();
}

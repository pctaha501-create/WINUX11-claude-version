#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "terminal.h"
int main(int argc,char **argv){
 QGuiApplication app(argc,argv);Terminal terminal;QQmlApplicationEngine engine;
 engine.rootContext()->setContextProperty("terminal",&terminal);
 engine.load(QUrl(QStringLiteral("qrc:/Terminal.qml")));
 if(engine.rootObjects().isEmpty())return 1;return app.exec();
}

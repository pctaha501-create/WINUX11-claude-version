#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/system_tools_service.h"
int main(int argc,char **argv){
 QGuiApplication app(argc,argv);SystemToolsService service;QString mode="display";
 if(app.arguments().size()>1)mode=app.arguments().at(1);
 QQmlApplicationEngine e;e.rootContext()->setContextProperty("systemTools",&service);e.rootContext()->setContextProperty("toolMode",mode);
 e.load(QUrl("qrc:/SystemTools.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();
}

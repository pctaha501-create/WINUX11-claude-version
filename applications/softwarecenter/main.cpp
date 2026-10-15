#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/package_service.h"
#include "../../compatibility/wine_manager.h"
int main(int argc,char **argv){
 QGuiApplication app(argc,argv);
 PackageService packages;
 WineManager wineManager;
 QQmlApplicationEngine engine;
 engine.rootContext()->setContextProperty("packages",&packages);
 engine.rootContext()->setContextProperty("wineManager",&wineManager);
 engine.load(QUrl(QStringLiteral("qrc:/SoftwareCenter.qml")));
 if(engine.rootObjects().isEmpty())return 1;
 return app.exec();
}

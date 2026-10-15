#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/package_service.h"
#include "../../compatibility/wine_manager.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);PackageService packages;WineManager wineManager;QQmlApplicationEngine e;e.rootContext()->setContextProperty("packages",&packages);e.rootContext()->setContextProperty("wineManager",&wineManager);e.load(QUrl("qrc:/SoftwareCenter.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

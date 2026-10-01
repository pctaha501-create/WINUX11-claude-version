#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/package_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);PackageService packages;QQmlApplicationEngine e;e.rootContext()->setContextProperty("packages",&packages);e.load(QUrl("qrc:/SoftwareCenter.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

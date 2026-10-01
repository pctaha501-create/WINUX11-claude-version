#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/screenshot_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);ScreenshotService service;QQmlApplicationEngine e;e.rootContext()->setContextProperty("screenshotService",&service);e.load(QUrl("qrc:/Screenshot.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

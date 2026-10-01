#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/media_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);MediaService media;QQmlApplicationEngine e;e.rootContext()->setContextProperty("media",&media);e.load(QUrl("qrc:/Music.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

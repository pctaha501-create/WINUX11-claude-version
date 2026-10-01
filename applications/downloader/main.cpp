#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/download_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);DownloadService d;QQmlApplicationEngine e;e.rootContext()->setContextProperty("downloads",&d);e.load(QUrl("qrc:/Downloader.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

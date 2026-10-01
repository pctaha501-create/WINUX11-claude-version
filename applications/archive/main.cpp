#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/archive_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);ArchiveService a;QQmlApplicationEngine e;e.rootContext()->setContextProperty("archiveService",&a);e.load(QUrl("qrc:/Archive.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

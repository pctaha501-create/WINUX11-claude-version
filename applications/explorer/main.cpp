#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardPaths>
#include "../../services/filesystem_service.h"
#include "../../compatibility/wine_manager.h"
int main(int argc,char **argv){
 QGuiApplication app(argc,argv);FilesystemService filesystem;WineManager wineManager;QQmlApplicationEngine engine;
 engine.rootContext()->setContextProperty("homePath",QStandardPaths::writableLocation(QStandardPaths::HomeLocation));
 engine.rootContext()->setContextProperty("filesystem",&filesystem);
 engine.rootContext()->setContextProperty("wineManager",&wineManager);
 engine.load(QUrl(QStringLiteral("qrc:/Explorer.qml")));
 if(engine.rootObjects().isEmpty())return 1;return app.exec();
}

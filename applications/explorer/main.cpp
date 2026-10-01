#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "../../services/filesystem_service.h"
int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    FilesystemService filesystem;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("filesystem", &filesystem);
    engine.load(QUrl("qrc:/Explorer.qml"));
    if (engine.rootObjects().isEmpty()) return 1;
    return app.exec();
}

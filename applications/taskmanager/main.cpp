#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/process_service.h"
int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    ProcessService processes;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("processService", &processes);
    engine.load(QUrl(QStringLiteral("qrc:/TaskManager.qml")));
    if (engine.rootObjects().isEmpty()) return 1;
    return app.exec();
}

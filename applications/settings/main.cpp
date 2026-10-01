#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "../../services/system_info.h"
int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    SystemInfo info;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("systemInfo", &info);
    engine.load(QUrl("qrc:/Settings.qml"));
    if (engine.rootObjects().isEmpty()) return 1;
    return app.exec();
}

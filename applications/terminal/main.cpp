#include "terminal.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    Terminal terminal;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("terminal", &terminal);
    engine.load(QUrl("qrc:/Terminal.qml"));
    if (engine.rootObjects().isEmpty()) return 1;
    terminal.start();
    return app.exec();
}

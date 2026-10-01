#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>
int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    QDir proc("/proc");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("procDir", proc);
    engine.load(QUrl("qrc:/TaskManager.qml"));
    if (engine.rootObjects().isEmpty()) return 1;
    return app.exec();
}

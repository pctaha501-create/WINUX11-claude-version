#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngineQuick/QtWebEngineQuick>
int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    QtWebEngineQuick::initialize();
    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/Browser.qml"));
    if (engine.rootObjects().isEmpty()) return 1;
    return app.exec();
}

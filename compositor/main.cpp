#include "compositor.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCoreApplication>
#include <QDir>

int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName("WINUX11");
    QCoreApplication::setApplicationVersion("0.1.0");
    WinuxCompositor compositor;
    if (!compositor.create()) return 1;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("winuxCompositor", &compositor);
    const auto qml = QDir(QCoreApplication::applicationDirPath())
        .absoluteFilePath("../../share/winux11/qml/Shell.qml");
    engine.load(QUrl::fromLocalFile(qml));
    if (engine.rootObjects().isEmpty()) return 2;
    return app.exec();
}

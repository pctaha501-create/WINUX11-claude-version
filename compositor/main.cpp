#include "compositor.h"
#include <QGuiApplication>
int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName("WINUX11");
    QCoreApplication::setApplicationVersion("0.1.0");
    WinuxCompositor compositor;
    compositor.create();
    return app.exec();
}

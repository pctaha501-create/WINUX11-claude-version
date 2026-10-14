#include "compositor.h"
#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QCoreApplication>
#include <QGuiApplication>

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName("WINUX11");
    QCoreApplication::setApplicationVersion("0.1.0");

    QCommandLineParser parser;
    parser.setApplicationDescription("WINUX11 Wayland compositor");
    parser.addHelpOption();
    parser.addVersionOption();
    const QCommandLineOption socketOption(
        QStringList{QStringLiteral("wayland-socket-name")},
        QStringLiteral("Name of the Wayland socket to create."),
        QStringLiteral("name"),
        qEnvironmentVariable("WINUX11_WAYLAND_DISPLAY", QStringLiteral("wayland-winux11")));
    parser.addOption(socketOption);
    parser.process(app);

    WinuxCompositor compositor;
    compositor.setSocketName(parser.value(socketOption));
    compositor.create();
    return app.exec();
}

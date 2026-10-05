#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/system_info.h"
#include "../../services/system_control_service.h"
#include "../../services/system_tools_service.h"

int main(int argc, char **argv) {
    QGuiApplication app(argc, argv);
    SystemInfo systemInfo;
    SystemControlService systemControl;
    SystemToolsService systemTools;
    QQmlApplicationEngine engine;
    auto *ctx = engine.rootContext();
    ctx->setContextProperty("systemInfo", &systemInfo);
    ctx->setContextProperty("systemControl", &systemControl);
    ctx->setContextProperty("systemTools", &systemTools);
    engine.load(QUrl(QStringLiteral("qrc:/Settings.qml")));
    if (engine.rootObjects().isEmpty()) return 1;
    return app.exec();
}

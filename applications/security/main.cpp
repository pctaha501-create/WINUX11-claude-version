#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/security_service.h"
#include "../../services/system_control_service.h"
int main(int argc,char **argv){
    QGuiApplication app(argc,argv);
    SecurityService security;
    SystemControlService system;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("securityService",&security);
    engine.rootContext()->setContextProperty("systemControl",&system);
    engine.load(QUrl(QStringLiteral("qrc:/Security.qml")));
    if(engine.rootObjects().isEmpty()) return 1;
    return app.exec();
}

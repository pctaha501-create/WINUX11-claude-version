#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/calculator_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);CalculatorService c;QQmlApplicationEngine e;e.rootContext()->setContextProperty("calculator",&c);e.load(QUrl("qrc:/Calculator.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

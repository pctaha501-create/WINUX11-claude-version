#include <QGuiApplication>
#include <QQmlApplicationEngine>
int main(int argc,char **argv){QGuiApplication app(argc,argv);QQmlApplicationEngine e;e.load(QUrl("qrc:/Clock.qml"));if(e.rootObjects().isEmpty())return 1;return app.exec();}

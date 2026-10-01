#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../../services/text_editor_service.h"
int main(int argc,char **argv){QGuiApplication app(argc,argv);TextEditorService e;QQmlApplicationEngine q;q.rootContext()->setContextProperty("editorService",&e);q.load(QUrl("qrc:/Editor.qml"));if(q.rootObjects().isEmpty())return 1;return app.exec();}

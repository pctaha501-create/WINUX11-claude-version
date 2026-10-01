#include <QGuiApplication>
#include <QDesktopServices>
#include <QUrl>
int main(int argc,char **argv){
 QGuiApplication app(argc,argv);
 const QString target=app.arguments().size()>1?app.arguments().at(1):QStringLiteral("https://www.qt.io");
 if(!QDesktopServices::openUrl(QUrl(target))) return 1;
 return 0;
}

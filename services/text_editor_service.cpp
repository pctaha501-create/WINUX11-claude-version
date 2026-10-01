#include "text_editor_service.h"
#include <QFile>
QString TextEditorService::read(const QString &path)const{QFile f(path);if(!f.open(QIODevice::ReadOnly|QIODevice::Text))return {};return QString::fromUtf8(f.readAll());}
bool TextEditorService::write(const QString &path,const QString &text)const{QFile f(path);if(!f.open(QIODevice::WriteOnly|QIODevice::Text))return false;return f.write(text.toUtf8())==text.toUtf8().size();}

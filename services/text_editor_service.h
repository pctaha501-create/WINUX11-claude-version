#pragma once
#include <QObject>
class TextEditorService final:public QObject{
 Q_OBJECT
public:
 using QObject::QObject;
 Q_INVOKABLE QString read(const QString &path)const;
 Q_INVOKABLE bool write(const QString &path,const QString &text)const;
};

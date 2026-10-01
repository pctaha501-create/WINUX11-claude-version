#pragma once
#include <QObject>
class SystemToolsService final:public QObject{
 Q_OBJECT
public:
 using QObject::QObject;
 Q_INVOKABLE QString query(const QString &mode)const;
};

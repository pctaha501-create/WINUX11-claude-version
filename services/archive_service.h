#pragma once
#include <QObject>
class ArchiveService final:public QObject{
 Q_OBJECT
public:
 using QObject::QObject;
 Q_INVOKABLE bool extractTar(const QString &archive,const QString &destination)const;
 Q_INVOKABLE bool createTar(const QString &source,const QString &archive)const;
};

#pragma once
#include <QObject>
#include <QVariantList>
class PackageService final:public QObject{
 Q_OBJECT
public:
 using QObject::QObject;
 Q_INVOKABLE QVariantList upgradable()const;
 Q_INVOKABLE bool install(const QString &package)const;
 Q_INVOKABLE bool remove(const QString &package)const;
};

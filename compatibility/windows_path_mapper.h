#pragma once
#include <QObject>
#include <QString>
class WindowsPathMapper final:public QObject{
 Q_OBJECT
public:
 using QObject::QObject;
 Q_INVOKABLE QString toLinuxPath(const QString &windowsPath) const;
 Q_INVOKABLE QString toWindowsPath(const QString &linuxPath) const;
 Q_INVOKABLE QString compatibilityRoot() const;
};

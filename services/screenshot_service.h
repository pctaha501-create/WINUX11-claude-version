#pragma once
#include <QObject>
#include <QString>
class ScreenshotService final:public QObject{
 Q_OBJECT
public:
 using QObject::QObject;
 Q_INVOKABLE bool captureScreen(const QString &path) const;
};

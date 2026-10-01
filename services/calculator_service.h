#pragma once
#include <QObject>
class CalculatorService final:public QObject{
 Q_OBJECT
public:
 using QObject::QObject;
 Q_INVOKABLE QString evaluate(const QString &expression)const;
};

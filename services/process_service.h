#pragma once
#include <QObject>
#include <QVariantList>
class ProcessService final : public QObject {
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE QVariantList processes() const;
    Q_INVOKABLE bool terminateProcess(qint64 pid) const;
};

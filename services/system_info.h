#pragma once
#include <QObject>
#include <QVariantMap>
class SystemInfo final : public QObject {
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE QVariantMap snapshot() const;
};

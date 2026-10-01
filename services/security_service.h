#pragma once
#include <QObject>
#include <QVariantList>
class SecurityService final : public QObject {
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE QVariantList listeningPorts() const;
    Q_INVOKABLE QVariantList activeConnections() const;
    Q_INVOKABLE QVariantList firewallState() const;
};

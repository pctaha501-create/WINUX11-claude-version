#pragma once
#include <QObject>
#include <QVariantList>
#include <QVariantMap>
class SystemControlService final : public QObject {
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE QVariantMap networkState() const;
    Q_INVOKABLE QVariantMap audioState() const;
    Q_INVOKABLE QVariantList storageState() const;
    Q_INVOKABLE QVariantList users() const;
    Q_INVOKABLE QVariantList packageUpdates() const;
    Q_INVOKABLE QVariantMap firewallState() const;
    Q_INVOKABLE bool setNetworkEnabled(bool enabled) const;
    Q_INVOKABLE bool setAudioVolume(int percent) const;
};

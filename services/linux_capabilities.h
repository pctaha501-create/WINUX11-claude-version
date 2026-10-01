#pragma once
#include <QObject>
#include <QVariantList>
class LinuxCapabilities final : public QObject {
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE QVariantList available() const;
};

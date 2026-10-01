#pragma once
#include <QObject>
#include <QStringList>
#include <QVariantList>
class WineManager final : public QObject {
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE QVariantList detect() const;
    Q_INVOKABLE bool launch(const QString &executable, const QStringList &args = {}, const QString &prefix = {}) const;
};

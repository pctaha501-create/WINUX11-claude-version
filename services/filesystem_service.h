#pragma once
#include <QObject>
#include <QVariantList>
class FilesystemService final : public QObject {
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE QVariantList list(const QString &path, bool includeHidden = false) const;
    Q_INVOKABLE bool createDirectory(const QString &path) const;
    Q_INVOKABLE bool removePath(const QString &path) const;
    Q_INVOKABLE bool renamePath(const QString &from, const QString &to) const;
};

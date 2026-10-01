#include "filesystem_service.h"
#include <QDir>
#include <QFileInfo>
QVariantList FilesystemService::list(const QString &path, bool includeHidden) const {
    QVariantList out;
    QDir d(path);
    if (!d.exists()) return out;
    auto flags = QDir::AllEntries | QDir::NoDotAndDotDot | QDir::System;
    if (includeHidden) flags |= QDir::Hidden;
    for (const auto &i : d.entryInfoList(flags, QDir::DirsFirst | QDir::Name)) {
        out << QVariantMap{
            {"name", i.fileName()},
            {"path", i.absoluteFilePath()},
            {"directory", i.isDir()},
            {"size", i.isDir() ? 0 : i.size()},
            {"modified", i.lastModified()},
            {"permissions", int(i.permissions())}
        };
    }
    return out;
}
bool FilesystemService::createDirectory(const QString &path) const { return QDir().mkpath(path); }
bool FilesystemService::removePath(const QString &path) const {
    QFileInfo i(path);
    if (i.isDir()) return QDir(path).removeRecursively();
    return QFile::remove(path);
}
bool FilesystemService::renamePath(const QString &from, const QString &to) const {
    return QFile::rename(from, to);
}

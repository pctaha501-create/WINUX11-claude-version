#pragma once

#include <QStringList>
#include <QVariantMap>

struct LinuxDistroInfo {
    QString id = QStringLiteral("unknown");
    QString idLike;
    QString prettyName = QStringLiteral("Unknown Linux");
    QString versionId;
    QString family = QStringLiteral("generic");
    QString packageManager = QStringLiteral("unavailable");
    bool packageManagerAvailable = false;
    bool osReleaseReadable = false;

    QVariantMap toVariantMap() const;
};

class LinuxDistroDetector final {
public:
    static LinuxDistroInfo detect(
        const QString &osReleasePath = QStringLiteral("/etc/os-release"),
        const QStringList &executableSearchPaths = {});
};

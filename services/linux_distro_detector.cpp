#include "linux_distro_detector.h"

#include <QFile>
#include <QMap>
#include <QRegularExpression>
#include <QStandardPaths>
#include <QTextStream>

namespace {
QStringList splitWords(const QString &value)
{
    return value.toLower().split(QRegularExpression(QStringLiteral("\\s+")),
                                 Qt::SkipEmptyParts);
}

QString unquoteOsReleaseValue(QString value)
{
    value = value.trimmed();
    if (value.size() >= 2
        && ((value.front() == QLatin1Char('"') && value.back() == QLatin1Char('"'))
            || (value.front() == QLatin1Char('\'') && value.back() == QLatin1Char('\'')))) {
        const QChar quote = value.front();
        value = value.mid(1, value.size() - 2);
        if (quote == QLatin1Char('"')) {
            value.replace(QStringLiteral("\\\\"), QStringLiteral("\\"));
            value.replace(QStringLiteral("\\\""), QStringLiteral("\""));
        }
    }
    return value;
}

QString familyForId(const QString &id)
{
    static const QStringList debianIds{
        QStringLiteral("debian"), QStringLiteral("ubuntu"), QStringLiteral("kali"),
        QStringLiteral("linuxmint"), QStringLiteral("pop"), QStringLiteral("elementary")
    };
    static const QStringList redHatIds{
        QStringLiteral("fedora"), QStringLiteral("rhel"), QStringLiteral("centos"),
        QStringLiteral("rocky"), QStringLiteral("almalinux"), QStringLiteral("ol"),
        QStringLiteral("amzn")
    };
    static const QStringList archIds{
        QStringLiteral("arch"), QStringLiteral("manjaro"), QStringLiteral("endeavouros")
    };

    if (debianIds.contains(id))
        return QStringLiteral("debian");
    if (redHatIds.contains(id))
        return QStringLiteral("redhat");
    if (archIds.contains(id))
        return QStringLiteral("arch");
    if (id.startsWith(QStringLiteral("opensuse")) || id == QStringLiteral("suse"))
        return QStringLiteral("suse");
    return {};
}

QString packageManagerForFamily(const QString &family, const QStringList &searchPaths)
{
    QStringList candidates;
    if (family == QStringLiteral("debian"))
        candidates = {QStringLiteral("apt-get"), QStringLiteral("apt")};
    else if (family == QStringLiteral("redhat"))
        candidates = {QStringLiteral("dnf"), QStringLiteral("yum")};
    else if (family == QStringLiteral("arch"))
        candidates = {QStringLiteral("pacman")};
    else if (family == QStringLiteral("suse"))
        candidates = {QStringLiteral("zypper")};
    else
        candidates = {QStringLiteral("apt-get"), QStringLiteral("apt"), QStringLiteral("dnf"),
                      QStringLiteral("yum"), QStringLiteral("pacman"), QStringLiteral("zypper")};

    for (const QString &candidate : candidates) {
        if (!QStandardPaths::findExecutable(candidate, searchPaths).isEmpty())
            return candidate;
    }
    return QStringLiteral("unavailable");
}
} // namespace

QVariantMap LinuxDistroInfo::toVariantMap() const
{
    return {
        {QStringLiteral("distroId"), id},
        {QStringLiteral("distroIdLike"), idLike},
        {QStringLiteral("distroName"), prettyName},
        {QStringLiteral("distroVersion"), versionId},
        {QStringLiteral("distroFamily"), family},
        {QStringLiteral("packageManager"), packageManager},
        {QStringLiteral("packageManagerAvailable"), packageManagerAvailable},
        {QStringLiteral("osReleaseReadable"), osReleaseReadable}
    };
}

LinuxDistroInfo LinuxDistroDetector::detect(const QString &osReleasePath,
                                             const QStringList &executableSearchPaths)
{
    LinuxDistroInfo info;
    QFile file(osReleasePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        info.packageManager = packageManagerForFamily(info.family, executableSearchPaths);
        info.packageManagerAvailable = info.packageManager != QStringLiteral("unavailable");
        return info;
    }

    info.osReleaseReadable = true;
    QMap<QString, QString> values;
    QTextStream stream(&file);
    while (!stream.atEnd()) {
        const QString line = stream.readLine().trimmed();
        if (line.isEmpty() || line.startsWith(QLatin1Char('#')))
            continue;
        const qsizetype separator = line.indexOf(QLatin1Char('='));
        if (separator <= 0)
            continue;
        const QString key = line.left(separator).trimmed();
        if (!key.isEmpty())
            values.insert(key, unquoteOsReleaseValue(line.mid(separator + 1)));
    }

    info.id = values.value(QStringLiteral("ID"), QStringLiteral("unknown")).toLower();
    info.idLike = values.value(QStringLiteral("ID_LIKE"));
    info.prettyName = values.value(QStringLiteral("PRETTY_NAME"),
                                   values.value(QStringLiteral("NAME"),
                                                QStringLiteral("Unknown Linux")));
    info.versionId = values.value(QStringLiteral("VERSION_ID"));
    info.family = familyForId(info.id);
    if (info.family.isEmpty()) {
        for (const QString &token : splitWords(info.idLike)) {
            info.family = familyForId(token);
            if (!info.family.isEmpty())
                break;
        }
    }
    if (info.family.isEmpty())
        info.family = QStringLiteral("generic");

    info.packageManager = packageManagerForFamily(info.family, executableSearchPaths);
    info.packageManagerAvailable = info.packageManager != QStringLiteral("unavailable");
    return info;
}

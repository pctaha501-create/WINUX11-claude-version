#include "linux_distro_detector.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QTemporaryDir>
#include <QDebug>

namespace {
bool writeFile(const QString &path, const QByteArray &contents)
{
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        return false;
    return file.write(contents) == contents.size();
}

bool makeExecutable(const QString &directory, const QString &name)
{
    const QString path = QDir(directory).filePath(name);
    if (!writeFile(path, "#!/bin/sh\nexit 0\n"))
        return false;
    QFile file(path);
    return file.setPermissions(QFile::ReadOwner | QFile::WriteOwner | QFile::ExeOwner
                               | QFile::ReadGroup | QFile::ExeGroup
                               | QFile::ReadOther | QFile::ExeOther);
}

bool expect(bool condition, const char *message)
{
    if (!condition)
        qCritical() << "FAIL:" << message;
    return condition;
}
}

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);
    QTemporaryDir temp;
    if (!expect(temp.isValid(), "temporary directory must be created"))
        return 1;

    const QString root = temp.path();
    const QString bin = QDir(root).filePath(QStringLiteral("bin"));
    if (!QDir().mkpath(bin))
        return 1;

    const QString ubuntuFile = QDir(root).filePath(QStringLiteral("ubuntu-os-release"));
    if (!writeFile(ubuntuFile,
                   "NAME=Ubuntu\nID=ubuntu\nID_LIKE=debian\nVERSION_ID=\"25.10\"\n"
                   "PRETTY_NAME=\"Ubuntu 25.10\"\n")
        || !makeExecutable(bin, QStringLiteral("apt-get")))
        return 1;
    const auto ubuntu = LinuxDistroDetector::detect(ubuntuFile, {bin});
    if (!expect(ubuntu.id == QStringLiteral("ubuntu"), "Ubuntu ID is detected")
        || !expect(ubuntu.family == QStringLiteral("debian"), "Ubuntu maps to Debian family")
        || !expect(ubuntu.prettyName == QStringLiteral("Ubuntu 25.10"), "quoted PRETTY_NAME is parsed")
        || !expect(ubuntu.versionId == QStringLiteral("25.10"), "VERSION_ID is parsed")
        || !expect(ubuntu.packageManager == QStringLiteral("apt-get"), "apt-get is detected")
        || !expect(ubuntu.packageManagerAvailable, "available package manager is reported"))
        return 1;

    const QString kaliFile = QDir(root).filePath(QStringLiteral("kali-os-release"));
    if (!writeFile(kaliFile, "ID=kali\nID_LIKE=debian\nPRETTY_NAME='Kali GNU/Linux'\n"))
        return 1;
    const auto kali = LinuxDistroDetector::detect(kaliFile, {bin});
    if (!expect(kali.id == QStringLiteral("kali"), "Kali is identified specifically")
        || !expect(kali.family == QStringLiteral("debian"), "Kali uses Debian family classification")
        || !expect(kali.packageManager == QStringLiteral("apt-get"), "Kali uses detected apt-get"))
        return 1;

    const QString fedoraFile = QDir(root).filePath(QStringLiteral("fedora-os-release"));
    if (!writeFile(fedoraFile, "ID=fedora\nVERSION_ID=42\nPRETTY_NAME=\"Fedora Linux 42\"\n")
        || !makeExecutable(bin, QStringLiteral("dnf")))
        return 1;
    const auto fedora = LinuxDistroDetector::detect(fedoraFile, {bin});
    if (!expect(fedora.family == QStringLiteral("redhat"), "Fedora maps to Red Hat family")
        || !expect(fedora.packageManager == QStringLiteral("dnf"), "dnf is detected"))
        return 1;

    const QString archFile = QDir(root).filePath(QStringLiteral("arch-os-release"));
    if (!writeFile(archFile, "ID=arch\nID_LIKE=\n")
        || !makeExecutable(bin, QStringLiteral("pacman")))
        return 1;
    const auto arch = LinuxDistroDetector::detect(archFile, {bin});
    if (!expect(arch.family == QStringLiteral("arch"), "Arch is detected")
        || !expect(arch.packageManager == QStringLiteral("pacman"), "pacman is detected"))
        return 1;

    const QString suseFile = QDir(root).filePath(QStringLiteral("suse-os-release"));
    if (!writeFile(suseFile, "ID=opensuse-tumbleweed\n")
        || !makeExecutable(bin, QStringLiteral("zypper")))
        return 1;
    const auto suse = LinuxDistroDetector::detect(suseFile, {bin});
    if (!expect(suse.family == QStringLiteral("suse"), "openSUSE is detected")
        || !expect(suse.packageManager == QStringLiteral("zypper"), "zypper is detected"))
        return 1;

    const QString unknownFile = QDir(root).filePath(QStringLiteral("unknown-os-release"));
    const QString emptyBin = QDir(root).filePath(QStringLiteral("empty-bin"));
    if (!writeFile(unknownFile, "ID=madeup\nID_LIKE=someunknownfamily\n")
        || !QDir().mkpath(emptyBin))
        return 1;
    const auto unknown = LinuxDistroDetector::detect(unknownFile, {emptyBin});
    if (!expect(unknown.id == QStringLiteral("madeup"), "unknown distro ID is preserved")
        || !expect(unknown.family == QStringLiteral("generic"), "unknown distro uses generic fallback")
        || !expect(unknown.packageManager == QStringLiteral("unavailable"), "missing manager is not guessed")
        || !expect(!unknown.packageManagerAvailable, "missing manager is marked unavailable"))
        return 1;

    const auto missing = LinuxDistroDetector::detect(QDir(root).filePath(QStringLiteral("missing")));
    if (!expect(!missing.osReleaseReadable, "missing os-release is reported")
        || !expect(missing.id == QStringLiteral("unknown"), "missing os-release has safe fallback"))
        return 1;

    qInfo() << "Linux distro detection tests passed";
    return 0;
}

#include "package_manager_adapter.h"

#include <QCoreApplication>
#include <QDebug>

namespace {
bool expect(bool condition, const char *message)
{
    if (!condition)
        qCritical() << "FAIL:" << message;
    return condition;
}

LinuxDistroInfo distro(const QString &manager)
{
    LinuxDistroInfo info;
    info.id = QStringLiteral("test");
    info.family = QStringLiteral("generic");
    info.packageManager = manager;
    info.packageManagerAvailable = manager != QStringLiteral("unavailable");
    return info;
}
}

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);

    const auto aptInstall = PackageManagerAdapter::install(distro(QStringLiteral("apt-get")), QStringLiteral("curl"));
    if (!expect(aptInstall.supported && aptInstall.program == QStringLiteral("pkexec"), "apt install is supported")
        || !expect(aptInstall.arguments == QStringList{QStringLiteral("apt-get"), QStringLiteral("install"),
                                                       QStringLiteral("-y"), QStringLiteral("curl")},
                   "apt install arguments are passed separately"))
        return 1;

    const auto dnfRemove = PackageManagerAdapter::remove(distro(QStringLiteral("dnf")), QStringLiteral("curl"));
    if (!expect(dnfRemove.supported, "dnf removal is supported")
        || !expect(dnfRemove.arguments == QStringList{QStringLiteral("dnf"), QStringLiteral("remove"),
                                                      QStringLiteral("-y"), QStringLiteral("curl")},
                   "dnf remove arguments are correct"))
        return 1;

    const auto pacmanInstall = PackageManagerAdapter::install(distro(QStringLiteral("pacman")), QStringLiteral("curl"));
    if (!expect(pacmanInstall.arguments == QStringList{QStringLiteral("pacman"), QStringLiteral("-S"),
                                                       QStringLiteral("--noconfirm"), QStringLiteral("curl")},
                "pacman install arguments are correct"))
        return 1;

    const auto zypperRemove = PackageManagerAdapter::remove(distro(QStringLiteral("zypper")), QStringLiteral("curl"));
    if (!expect(zypperRemove.arguments == QStringList{QStringLiteral("zypper"),
                                                      QStringLiteral("--non-interactive"),
                                                      QStringLiteral("remove"), QStringLiteral("curl")},
                "zypper removal arguments are correct"))
        return 1;

    const auto yumUpdates = PackageManagerAdapter::upgradable(distro(QStringLiteral("yum")));
    if (!expect(yumUpdates.supported && yumUpdates.program == QStringLiteral("yum")
                && yumUpdates.arguments == QStringList{QStringLiteral("check-update")},
                "yum update check is supported"))
        return 1;

    const auto unknown = PackageManagerAdapter::install(distro(QStringLiteral("unavailable")), QStringLiteral("curl"));
    if (!expect(!unknown.supported && !unknown.error.isEmpty(), "unknown package manager fails safely"))
        return 1;

    qInfo() << "Package manager adapter tests passed";
    return 0;
}

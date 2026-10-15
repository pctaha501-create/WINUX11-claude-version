#include "package_manager_adapter.h"

namespace {
PackageCommand unsupported()
{
    return {{}, {}, 30000, false,
            QStringLiteral("No supported package manager is available for this Linux distribution.")};
}

PackageCommand command(QString program, QStringList arguments, int timeoutMs = 30000)
{
    return {std::move(program), std::move(arguments), timeoutMs, true, {}};
}
}

PackageCommand PackageManagerAdapter::upgradable(const LinuxDistroInfo &distro)
{
    if (!distro.packageManagerAvailable)
        return unsupported();

    const QString &manager = distro.packageManager;
    if (manager == QStringLiteral("apt-get"))
        return command(manager, {QStringLiteral("-s"), QStringLiteral("upgrade")}, 30000);
    if (manager == QStringLiteral("apt"))
        return command(manager, {QStringLiteral("list"), QStringLiteral("--upgradable")}, 30000);
    if (manager == QStringLiteral("dnf") || manager == QStringLiteral("yum"))
        return command(manager, {QStringLiteral("check-update")}, 60000);
    if (manager == QStringLiteral("pacman"))
        return command(manager, {QStringLiteral("-Qu")}, 30000);
    if (manager == QStringLiteral("zypper"))
        return command(manager, {QStringLiteral("--non-interactive"), QStringLiteral("list-updates")}, 60000);
    return unsupported();
}

PackageCommand PackageManagerAdapter::install(const LinuxDistroInfo &distro, const QString &package)
{
    if (!distro.packageManagerAvailable)
        return unsupported();

    const QString &manager = distro.packageManager;
    if (manager == QStringLiteral("apt-get"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("install"), QStringLiteral("-y"), package}, 120000);
    if (manager == QStringLiteral("apt"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("install"), QStringLiteral("-y"), package}, 120000);
    if (manager == QStringLiteral("dnf") || manager == QStringLiteral("yum"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("install"), QStringLiteral("-y"), package}, 120000);
    if (manager == QStringLiteral("pacman"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("-S"), QStringLiteral("--noconfirm"), package}, 120000);
    if (manager == QStringLiteral("zypper"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("--non-interactive"), QStringLiteral("install"), package}, 120000);
    return unsupported();
}

PackageCommand PackageManagerAdapter::remove(const LinuxDistroInfo &distro, const QString &package)
{
    if (!distro.packageManagerAvailable)
        return unsupported();

    const QString &manager = distro.packageManager;
    if (manager == QStringLiteral("apt-get"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("remove"), QStringLiteral("-y"), package}, 120000);
    if (manager == QStringLiteral("apt"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("remove"), QStringLiteral("-y"), package}, 120000);
    if (manager == QStringLiteral("dnf") || manager == QStringLiteral("yum"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("remove"), QStringLiteral("-y"), package}, 120000);
    if (manager == QStringLiteral("pacman"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("-R"), QStringLiteral("--noconfirm"), package}, 120000);
    if (manager == QStringLiteral("zypper"))
        return command(QStringLiteral("pkexec"), {manager, QStringLiteral("--non-interactive"), QStringLiteral("remove"), package}, 120000);
    return unsupported();
}

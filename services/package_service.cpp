#include "package_service.h"
#include "command_runner.h"
#include "linux_distro_detector.h"
#include "package_manager_adapter.h"
#include <QRegularExpression>

namespace {
bool validPackage(const QString &package)
{
    return QRegularExpression(QStringLiteral("^[A-Za-z0-9][A-Za-z0-9+._:-]{0,127}$"))
        .match(package).hasMatch();
}

QVariantMap packageError(const QString &message, const QString &family = QStringLiteral("generic"))
{
    return {{QStringLiteral("available"), false},
            {QStringLiteral("error"), message},
            {QStringLiteral("distroFamily"), family}};
}

QStringList usefulUpdateLines(const QString &manager, const QString &output)
{
    QStringList lines;
    for (QString line : output.split(QLatin1Char('\n'), Qt::SkipEmptyParts)) {
        line = line.trimmed();
        if (line.isEmpty())
            continue;

        if (manager == QStringLiteral("apt-get")) {
            if (line.startsWith(QStringLiteral("Inst ")))
                lines << line.mid(5).trimmed();
            continue;
        }
        if (manager == QStringLiteral("apt")) {
            if (!line.startsWith(QStringLiteral("Listing")))
                lines << line;
            continue;
        }
        if (line.startsWith(QStringLiteral("Last metadata expiration"))
            || line.startsWith(QStringLiteral("Updating Subscription Management"))
            || line.startsWith(QStringLiteral("Loading repository data"))
            || line.startsWith(QStringLiteral("Reading installed packages"))
            || line.startsWith(QStringLiteral("S | Repository"))
            || line.startsWith(QStringLiteral("Repository"))
            || line.startsWith(QStringLiteral("Name"))
            || line.startsWith(QStringLiteral("Obsoleting"))
            || line.startsWith(QStringLiteral("Dependencies resolved"))
            || line.startsWith(QStringLiteral("No packages marked"))
            || line.startsWith(QStringLiteral("No updates found"))
            || line.startsWith(QStringLiteral("No matching Packages"))
            || line.startsWith(QStringLiteral("---")))
            continue;
        lines << line;
    }
    return lines;
}
}

QVariantList PackageService::upgradable() const
{
    const auto distro = LinuxDistroDetector::detect();
    const auto plan = PackageManagerAdapter::upgradable(distro);
    if (!plan.supported)
        return {packageError(plan.error, distro.family)};

    const auto result = CommandRunner::run(plan.program, plan.arguments, plan.timeoutMs);
    const bool dnfStyle = distro.packageManager == QStringLiteral("dnf")
        || distro.packageManager == QStringLiteral("yum");
    const bool successful = result.started
        && (result.exitCode == 0 || (dnfStyle && result.exitCode == 100));
    if (!successful) {
        const QString detail = !result.stderrText.trimmed().isEmpty()
            ? result.stderrText.trimmed()
            : QStringLiteral("The package manager could not check for updates.");
        return {packageError(detail, distro.family)};
    }

    QVariantList output;
    const auto lines = usefulUpdateLines(distro.packageManager, result.stdoutText);
    for (const QString &line : lines)
        output << line;
    return output;
}

bool PackageService::install(const QString &package) const
{
    if (!validPackage(package))
        return false;
    const auto distro = LinuxDistroDetector::detect();
    const auto plan = PackageManagerAdapter::install(distro, package);
    if (!plan.supported)
        return false;
    const auto result = CommandRunner::run(plan.program, plan.arguments, plan.timeoutMs);
    return result.started && result.exitCode == 0;
}

bool PackageService::remove(const QString &package) const
{
    if (!validPackage(package))
        return false;
    const auto distro = LinuxDistroDetector::detect();
    const auto plan = PackageManagerAdapter::remove(distro, package);
    if (!plan.supported)
        return false;
    const auto result = CommandRunner::run(plan.program, plan.arguments, plan.timeoutMs);
    return result.started && result.exitCode == 0;
}

#pragma once

#include "linux_distro_detector.h"
#include <QString>
#include <QStringList>

struct PackageCommand {
    QString program;
    QStringList arguments;
    int timeoutMs = 30000;
    bool supported = false;
    QString error;
};

class PackageManagerAdapter final {
public:
    static PackageCommand upgradable(const LinuxDistroInfo &distro);
    static PackageCommand install(const LinuxDistroInfo &distro, const QString &package);
    static PackageCommand remove(const LinuxDistroInfo &distro, const QString &package);
};

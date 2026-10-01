#include "linux_capabilities.h"
#include "command_runner.h"
#include <QFileInfo>
QVariantList LinuxCapabilities::available() const {
    const QStringList programs = {
        "systemctl","nmcli","wpctl","bluetoothctl","ip","df","lsblk","apt","gsettings","ss","ufw","wine","proton"
    };
    QVariantList out;
    for (const auto &p : programs) {
        const auto r = CommandRunner::run("sh", {"-c", "command -v -- " + p}, 1000);
        out << QVariantMap{{"name",p},{"available",r.started && r.exitCode == 0},
                           {"path",r.stdoutText.trimmed()}};
    }
    return out;
}

#include "system_info.h"
#include "command_runner.h"
#include <QFile>
#include <QTextStream>
#include <QSysInfo>
QVariantMap SystemInfo::snapshot() const {
    QVariantMap m{
        {"kernel", QSysInfo::kernelVersion()},
        {"product", QSysInfo::prettyProductName()},
        {"arch", QSysInfo::currentCpuArchitecture()}
    };
    const auto r = CommandRunner::run("systemctl", {"is-system-running"}, 1500);
    m["systemd"] = r.started ? r.stdoutText.trimmed() : "unavailable";
    QFile mem("/proc/meminfo");
    if (mem.open(QIODevice::ReadOnly)) {
        QTextStream s(&mem);
        while (!s.atEnd()) {
            const auto line = s.readLine();
            if (line.startsWith("MemTotal:")) {
                m["memoryTotalKiB"] = line.section(' ', 1, 1).toLongLong();
                break;
            }
        }
    }
    return m;
}

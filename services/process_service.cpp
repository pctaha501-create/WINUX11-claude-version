#include "process_service.h"
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QRegularExpression>
#include <signal.h>
#include <unistd.h>
QVariantList ProcessService::processes() const {
    QVariantList out;
    const QDir proc("/proc");
    const auto entries = proc.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    for (const auto &entry : entries) {
        bool ok = false;
        const qint64 pid = entry.toLongLong(&ok);
        if (!ok) continue;
        QFile stat("/proc/" + entry + "/stat");
        if (!stat.open(QIODevice::ReadOnly)) continue;
        const QString line = QString::fromLocal8Bit(stat.readAll());
        const int open = line.indexOf('(');
        const int close = line.lastIndexOf(')');
        if (open < 0 || close <= open) continue;
        const QString name = line.mid(open + 1, close - open - 1);
        const QStringList fields = line.mid(close + 2).split(' ', Qt::SkipEmptyParts);
        if (fields.size() < 20) continue;
        const qint64 utime = fields.value(11).toLongLong();
        const qint64 stime = fields.value(12).toLongLong();
        out << QVariantMap{{"pid",pid},{"name",name},{"state",fields.value(0)},
                           {"cpuTicks",utime + stime}};
    }
    return out;
}
bool ProcessService::terminateProcess(qint64 pid) const {
    if (pid <= 1 || pid == getpid()) return false;
    return ::kill(static_cast<pid_t>(pid), SIGTERM) == 0;
}

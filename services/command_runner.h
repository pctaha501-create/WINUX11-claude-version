#pragma once
#include <QProcess>
#include <QStringList>
struct CommandResult {
    int exitCode = -1;
    bool timedOut = false;
    bool started = false;
    QString stdoutText;
    QString stderrText;
};
class CommandRunner final {
public:
    static CommandResult run(const QString &program, const QStringList &args, int timeoutMs = 5000);
};

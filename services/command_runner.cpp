#include "command_runner.h"
CommandResult CommandRunner::run(const QString &program, const QStringList &args, int timeoutMs) {
    CommandResult result;
    QProcess p;
    p.setProgram(program);
    p.setArguments(args);
    p.start();
    if (!p.waitForStarted(timeoutMs)) return result;
    result.started = true;
    if (!p.waitForFinished(timeoutMs)) {
        result.timedOut = true;
        p.kill();
        p.waitForFinished(1000);
    }
    result.exitCode = p.exitCode();
    result.stdoutText = QString::fromLocal8Bit(p.readAllStandardOutput());
    result.stderrText = QString::fromLocal8Bit(p.readAllStandardError());
    return result;
}

#include <QCoreApplication>
#include "../services/command_runner.h"
int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    const auto ok = CommandRunner::run("sh", {"-c", "printf ok"});
    if (!ok.started || ok.exitCode != 0 || ok.stdoutText != "ok") return 1;
    const auto missing = CommandRunner::run("/definitely/not/a/real/command", {});
    if (missing.started) return 2;
    const auto timeout = CommandRunner::run("sh", {"-c", "sleep 2"}, 50);
    if (!timeout.started || !timeout.timedOut) return 3;
    return 0;
}

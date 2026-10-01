#include "wine_manager.h"
#include "../services/command_runner.h"
#include <QProcess>
QVariantList WineManager::detect() const {
    QVariantList out;
    for (const QString &program : {"wine","wine64","proton"}) {
        const auto r = CommandRunner::run("sh", {"-c", "command -v -- " + program}, 1500);
        out << QVariantMap{{"name",program},{"available",r.started && r.exitCode == 0},{"path",r.stdoutText.trimmed()}};
    }
    return out;
}
bool WineManager::launch(const QString &executable, const QStringList &args, const QString &prefix) const {
    if (executable.isEmpty()) return false;
    QStringList env = QProcess::systemEnvironment();
    if (!prefix.isEmpty()) env << "WINEPREFIX=" + prefix;
    QProcess process;
    process.setProgram("wine");
    process.setArguments(QStringList{executable} + args);
    process.setEnvironment(env);
    return process.startDetached();
}

#include "wine_manager.h"
#include "../services/command_runner.h"
#include <QFileInfo>
#include <QProcess>
#include <QProcessEnvironment>
#include <QStandardPaths>
QVariantList WineManager::detect() const {
    QVariantList out;
    for (const QString &program : {"wine","wine64","proton"}) {
        const auto r = CommandRunner::run("sh", {"-c", "command -v -- " + program}, 1500);
        out << QVariantMap{{"name",program},{"available",r.started && r.exitCode == 0},{"path",r.stdoutText.trimmed()}};
    }
    return out;
}
bool WineManager::launch(const QString &executable, const QStringList &args, const QString &prefix) const {
    const QFileInfo file(executable);
    if (executable.isEmpty() || !file.exists() || !file.isFile()) return false;
    const QString wine = QStandardPaths::findExecutable(QStringLiteral("wine"));
    if (wine.isEmpty()) return false;

    QStringList wineArgs;
    if (file.suffix().compare(QStringLiteral("msi"), Qt::CaseInsensitive) == 0)
        wineArgs << QStringLiteral("msiexec") << QStringLiteral("/i") << file.absoluteFilePath();
    else
        wineArgs << file.absoluteFilePath();
    wineArgs << args;

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    if (!prefix.isEmpty()) env.insert(QStringLiteral("WINEPREFIX"), prefix);
    QProcess process;
    process.setProgram(wine);
    process.setArguments(wineArgs);
    process.setProcessEnvironment(env);
    return process.startDetached();
}

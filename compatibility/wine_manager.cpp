#include "wine_manager.h"
#include <QFileInfo>
#include <QProcess>
#include <QProcessEnvironment>
#include <QStandardPaths>

QVariantList WineManager::detect() const {
    QVariantList out;
    for (const QString &program : {QStringLiteral("wine"), QStringLiteral("wine64"), QStringLiteral("proton")}) {
        const QString path = QStandardPaths::findExecutable(program);
        out << QVariantMap{{"name", program}, {"available", !path.isEmpty()}, {"path", path}};
    }
    return out;
}

bool WineManager::launch(const QString &executable, const QStringList &args, const QString &prefix) const {
    const QFileInfo file(executable);
    if (executable.isEmpty() || !file.exists() || !file.isFile())
        return false;

    const QString wine = QStandardPaths::findExecutable(QStringLiteral("wine"));
    if (wine.isEmpty())
        return false;

    QStringList wineArgs;
    if (file.suffix().compare(QStringLiteral("msi"), Qt::CaseInsensitive) == 0) {
        wineArgs << QStringLiteral("msiexec") << QStringLiteral("/i") << file.absoluteFilePath();
    } else if (file.suffix().compare(QStringLiteral("exe"), Qt::CaseInsensitive) == 0) {
        wineArgs << file.absoluteFilePath();
    } else {
        return false;
    }
    wineArgs << args;

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    if (!prefix.isEmpty())
        env.insert(QStringLiteral("WINEPREFIX"), prefix);

    QProcess process;
    process.setProgram(wine);
    process.setArguments(wineArgs);
    process.setProcessEnvironment(env);
    return process.startDetached();
}

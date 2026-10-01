#include "security_service.h"
#include "command_runner.h"
#include <QRegularExpression>
static QVariantList lines(const QString &text) {
    QVariantList out;
    for (const auto &line : text.split('\n', Qt::SkipEmptyParts)) out << line.trimmed();
    return out;
}
QVariantList SecurityService::listeningPorts() const {
    const auto r = CommandRunner::run("ss", {"-lntupH"}, 3000);
    return r.started ? lines(r.stdoutText) : QVariantList{QVariantMap{{"error","ss unavailable"}}};
}
QVariantList SecurityService::activeConnections() const {
    const auto r = CommandRunner::run("ss", {"-ntupH"}, 3000);
    return r.started ? lines(r.stdoutText) : QVariantList{QVariantMap{{"error","ss unavailable"}}};
}
QVariantList SecurityService::firewallState() const {
    auto r = CommandRunner::run("ufw", {"status"}, 3000);
    if (!r.started) r = CommandRunner::run("sh", {"-c", "systemctl is-active firewalld"}, 3000);
    if (!r.started) return {QVariantMap{{"available",false},{"status","unavailable"}}};
    return {QVariantMap{{"available",true},{"status",r.stdoutText.trimmed()},{"exitCode",r.exitCode}}};
}

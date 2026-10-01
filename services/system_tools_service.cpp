#include "system_tools_service.h"
#include "command_runner.h"
QString SystemToolsService::query(const QString &mode) const {
    QString program;
    QStringList args;
    if (mode == "display") {
        const auto check = CommandRunner::run("sh", {"-c", "command -v -- wlr-randr"}, 1000);
        if (check.started && check.exitCode == 0) { program = "wlr-randr"; args = {"--json"}; }
        else { program = "xrandr"; args = {"--query"}; }
    } else if (mode == "sound") {
        program = "wpctl"; args = {"status"};
    } else if (mode == "printers") {
        program = "lpstat"; args = {"-p", "-d"};
    } else if (mode == "startup") {
        program = "systemctl"; args = {"--user", "list-unit-files", "--type=service", "--no-pager", "--no-legend"};
    } else if (mode == "bluetooth") {
        program = "bluetoothctl"; args = {"show"};
    } else if (mode == "wifi") {
        program = "nmcli"; args = {"device", "wifi", "list", "--rescan", "no"};
    } else if (mode == "privacy") {
        program = "sh";
        args = {"-c", "printf 'session=%s\\nuser=%s\\nwayland=%s\\n' \"$XDG_SESSION_TYPE\" \"$USER\" \"$WAYLAND_DISPLAY\""};
    } else {
        return QStringLiteral("Unsupported system tool mode");
    }
    const auto r = CommandRunner::run(program, args, 5000);
    if (!r.started) return QStringLiteral("Unavailable: ") + program;
    return r.stdoutText.isEmpty() ? r.stderrText : r.stdoutText;
}

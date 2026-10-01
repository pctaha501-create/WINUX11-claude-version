#include "terminal.h"
Terminal::Terminal(QObject *p) : QObject(p) {
    connect(&m_process, &QProcess::readyReadStandardOutput, this, [this] {
        emit output(QString::fromLocal8Bit(m_process.readAllStandardOutput()));
    });
    connect(&m_process, &QProcess::readyReadStandardError, this, [this] {
        emit output(QString::fromLocal8Bit(m_process.readAllStandardError()));
    });
    connect(&m_process, qOverload<int, QProcess::ExitStatus>(&QProcess::finished),
            this, [this](int code, QProcess::ExitStatus) { emit exited(code); });
}
void Terminal::start() {
    if (m_process.state() != QProcess::NotRunning) return;
    QString shell = qEnvironmentVariable("SHELL");
    if (shell.isEmpty()) shell = "/bin/sh";
    m_process.setProgram(shell);
    m_process.setArguments({"-i"});
    m_process.start();
}
void Terminal::write(const QString &text) {
    if (m_process.state() != QProcess::NotRunning) m_process.write(text.toLocal8Bit());
}
void Terminal::interrupt() {
    if (m_process.state() != QProcess::NotRunning) m_process.kill();
}

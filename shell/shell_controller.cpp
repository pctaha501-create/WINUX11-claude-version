#include "shell_controller.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QGuiApplication>

ShellController::ShellController(QObject *parent) : QObject(parent) {
    m_reconnectTimer.setSingleShot(true);
    m_reconnectTimer.setInterval(750);
    connect(&m_socket, &QLocalSocket::readyRead, this, &ShellController::readState);
    connect(&m_socket, &QLocalSocket::connected, this, [this] {
        m_reconnectTimer.stop();
        flushPendingCommands();
    });
    connect(&m_socket, &QLocalSocket::disconnected, this, &ShellController::scheduleReconnect);
    connect(&m_socket, &QLocalSocket::errorOccurred, this,
            [this](QLocalSocket::LocalSocketError) {
        emit connectionFailed(m_socket.errorString());
        QTimer::singleShot(0, this, [this] { scheduleReconnect(); });
    });
    connect(&m_reconnectTimer, &QTimer::timeout, this, [this] {
        if (!m_socketPath.isEmpty() && m_socket.state() == QLocalSocket::UnconnectedState)
            m_socket.connectToServer(m_socketPath);
    });
    if (auto *clipboard = QGuiApplication::clipboard())
        connect(clipboard, &QClipboard::dataChanged, this, &ShellController::clipboardChanged);
}

bool ShellController::connectToCompositor() {
    if (m_socketPath.isEmpty()) {
        const QString runtime = QStandardPaths::writableLocation(QStandardPaths::RuntimeLocation);
        m_socketPath = (runtime.isEmpty() ? QStringLiteral("/tmp") : runtime)
                       + QStringLiteral("/winux11-shell.sock");
    }
    if (m_socket.state() == QLocalSocket::ConnectedState ||
        m_socket.state() == QLocalSocket::ConnectingState)
        return true;
    m_socket.connectToServer(m_socketPath);
    QTimer::singleShot(0, this, [this] { scheduleReconnect(); });
    return true;
}

void ShellController::scheduleReconnect() {
    if (!m_socketPath.isEmpty() &&
        m_socket.state() == QLocalSocket::UnconnectedState &&
        !m_reconnectTimer.isActive())
        m_reconnectTimer.start();
}

void ShellController::command(const QString &line) {
    const QString trimmed = line.trimmed();
    if (trimmed.isEmpty()) return;

    if (m_socket.state() == QLocalSocket::ConnectedState && m_pendingCommands.isEmpty()) {
        if (m_socket.write(trimmed.toUtf8() + '\n') >= 0)
            return;
        emit connectionFailed(m_socket.errorString());
    }

    constexpr qsizetype maxPendingCommands = 256;
    if (m_pendingCommands.size() >= maxPendingCommands) {
        emit connectionFailed(QStringLiteral("WINUX11 command queue is full; command discarded."));
        return;
    }
    m_pendingCommands.append(trimmed);
    connectToCompositor();
}

void ShellController::flushPendingCommands() {
    while (m_socket.state() == QLocalSocket::ConnectedState && !m_pendingCommands.isEmpty()) {
        const QByteArray message = m_pendingCommands.constFirst().toUtf8() + '\n';
        if (m_socket.write(message) < 0) {
            emit connectionFailed(m_socket.errorString());
            return;
        }
        m_pendingCommands.removeFirst();
    }
}

void ShellController::readState() {
    m_buffer += m_socket.readAll();
    while (true) {
        const int newline = m_buffer.indexOf('\n');
        if (newline < 0) break;
        const QByteArray line = m_buffer.left(newline);
        m_buffer.remove(0, newline + 1);
        QJsonParseError error;
        const auto document = QJsonDocument::fromJson(line, &error);
        if (error.error != QJsonParseError::NoError || !document.isObject()) continue;
        const auto root = document.object();
        m_workspace = root.value(QStringLiteral("workspace")).toInt();
        m_windows.clear();
        for (const auto &value : root.value(QStringLiteral("windows")).toArray())
            m_windows << value.toObject().toVariantMap();
        emit stateChanged();
    }
}

QString ShellController::clipboardText() const {
    const auto *clipboard = QGuiApplication::clipboard();
    return clipboard ? clipboard->text(QClipboard::Clipboard) : QString();
}

void ShellController::setClipboardText(const QString &text) {
    if (auto *clipboard = QGuiApplication::clipboard())
        clipboard->setText(text, QClipboard::Clipboard);
}

void ShellController::clearClipboard() {
    if (auto *clipboard = QGuiApplication::clipboard())
        clipboard->clear(QClipboard::Clipboard);
}

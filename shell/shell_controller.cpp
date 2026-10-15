#include "shell_controller.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QGuiApplication>
#include <QTimer>

ShellController::ShellController(QObject *p) : QObject(p), m_reconnectTimer(new QTimer(this))
{
    m_reconnectTimer->setSingleShot(true);
    connect(m_reconnectTimer, &QTimer::timeout, this, [this] { connectToCompositor(); });
    connect(&m_socket, &QLocalSocket::connected, this, [this] {
        m_reconnectTimer->stop();
        while (m_socket.state() == QLocalSocket::ConnectedState && !m_pendingCommands.isEmpty()) {
            const QByteArray payload = m_pendingCommands.head().toUtf8() + "\n";
            if (m_socket.write(payload) < 0)
                break;
            m_pendingCommands.dequeue();
        }
    });
    connect(&m_socket, &QLocalSocket::readyRead, this, &ShellController::readState);
    const auto retryConnection = [this] {
        if (!m_reconnectTimer->isActive())
            m_reconnectTimer->start(500);
    };
    connect(&m_socket, &QLocalSocket::errorOccurred, this, [this, retryConnection] {
        emit connectionFailed(m_socket.errorString());
        retryConnection();
    });
    connect(&m_socket, &QLocalSocket::disconnected, this, retryConnection);
    if (auto *cb = QGuiApplication::clipboard())
        connect(cb, &QClipboard::dataChanged, this, &ShellController::clipboardChanged);
}

bool ShellController::connectToCompositor()
{
    if (m_socket.state() == QLocalSocket::ConnectedState ||
        m_socket.state() == QLocalSocket::ConnectingState)
        return true;
    const QString runtime = QStandardPaths::writableLocation(QStandardPaths::RuntimeLocation);
    const QString path = (runtime.isEmpty() ? QStringLiteral("/tmp") : runtime) + "/winux11-shell.sock";
    m_socket.connectToServer(path);
    return true;
}

void ShellController::readState()
{
    m_buffer += m_socket.readAll();
    while (true) {
        const int nl = m_buffer.indexOf('\n');
        if (nl < 0)
            break;
        const QByteArray line = m_buffer.left(nl);
        m_buffer.remove(0, nl + 1);
        QJsonParseError e;
        const auto doc = QJsonDocument::fromJson(line, &e);
        if (e.error != QJsonParseError::NoError || !doc.isObject())
            continue;
        const auto root = doc.object();
        m_workspace = root.value("workspace").toInt();
        m_windows.clear();
        for (const auto &v : root.value("windows").toArray())
            m_windows << v.toObject().toVariantMap();
        emit stateChanged();
    }
}

void ShellController::command(const QString &line)
{
    const QString clean = line.trimmed();
    if (clean.isEmpty())
        return;
    if (m_socket.state() == QLocalSocket::ConnectedState) {
        if (m_socket.write(clean.toUtf8() + "\n") >= 0)
            return;
    }
    // Do not silently lose a click when IPC is still connecting or reconnecting.
    if (m_pendingCommands.size() < 256)
        m_pendingCommands.enqueue(clean);
    connectToCompositor();
}

QString ShellController::clipboardText() const
{
    const auto *cb = QGuiApplication::clipboard();
    return cb ? cb->text(QClipboard::Clipboard) : QString();
}
void ShellController::setClipboardText(const QString &text)
{
    if (auto *cb = QGuiApplication::clipboard()) cb->setText(text, QClipboard::Clipboard);
}
void ShellController::clearClipboard()
{
    if (auto *cb = QGuiApplication::clipboard()) cb->clear(QClipboard::Clipboard);
}

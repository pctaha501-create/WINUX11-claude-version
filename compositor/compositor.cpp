#include "compositor.h"
#include <QEvent>
#include <QKeyEvent>
#include <QWaylandOutputMode>
#include <QQmlComponent>
#include <QUrl>

WindowSurface::WindowSurface(QWaylandXdgToplevel *topLevel, QObject *parent)
    : QObject(parent), m_topLevel(topLevel) {}

WinuxCompositor::WinuxCompositor(QObject *parent)
    : QWaylandCompositor(parent), m_xdgShell(this) {
    connect(&m_xdgShell, &QWaylandXdgShell::toplevelCreated,
            this, &WinuxCompositor::onNewToplevel);
    m_window.setTitle(QStringLiteral("WINUX11"));
    m_window.setColor(QColor(QStringLiteral("#090b10")));
    m_window.resize(1920, 1080);
    m_window.installEventFilter(this);
}

void WinuxCompositor::create() {
    if (m_initialized) return;
    m_initialized = true;

    QWaylandCompositor::create();

    m_seat = new QWaylandSeat(this, QWaylandSeat::Pointer | QWaylandSeat::Keyboard);
    m_seat->setObjectName(QStringLiteral("WINUX11 Seat"));
    m_seat->initialize();

    m_output = new QWaylandOutput(this, &m_window);
    const QWaylandOutputMode mode(QSize(1920, 1080), 60000);
    m_output->addMode(mode, true);
    m_output->setCurrentMode(mode);
    m_output->setPhysicalSize(QSize(600, 340));
    m_output->setScaleFactor(1);
    m_output->setManufacturer(QStringLiteral("WINUX11"));
    m_output->setModel(QStringLiteral("WINUX11 Virtual Display"));

    QQmlComponent shellComponent(&m_qmlEngine);
    shellComponent.loadUrl(QUrl(QStringLiteral("qrc:/shell_qml/../shell/qml/Shell.qml")));
    if (!shellComponent.isReady()) {
        shellComponent.loadUrl(QUrl(QStringLiteral("qrc:/shell_qml/Shell.qml")));
    }
    if (shellComponent.isReady())
        shellComponent.create(m_window.contentItem());

    m_window.show();
}

bool WinuxCompositor::eventFilter(QObject *watched, QEvent *event) {
    if (watched == &m_window && m_seat && event->type() == QEvent::KeyPress) {
        auto *key = static_cast<QKeyEvent*>(event);
        if (key->key() == Qt::Key_F1 && key->modifiers().testFlag(Qt::ControlModifier)) {
            setWorkspace(0);
            return true;
        }
        if (key->key() == Qt::Key_F2 && key->modifiers().testFlag(Qt::ControlModifier)) {
            setWorkspace(1);
            return true;
        }
        if (key->key() == Qt::Key_F3 && key->modifiers().testFlag(Qt::ControlModifier)) {
            setWorkspace(2);
            return true;
        }
        if (key->key() == Qt::Key_F4 && key->modifiers().testFlag(Qt::ControlModifier)) {
            setWorkspace(3);
            return true;
        }
        m_seat->sendFullKeyEvent(key);
        return false;
    }
    return QWaylandCompositor::eventFilter(watched, event);
}

void WinuxCompositor::onNewToplevel(QWaylandXdgToplevel *toplevel, QWaylandXdgSurface *surface) {
    Q_UNUSED(surface);
    auto *window = new WindowSurface(toplevel, this);
    m_windows.push_back(window);

    auto *item = new QWaylandQuickShellSurfaceItem(m_window.contentItem());
    item->setShellSurface(toplevel->xdgSurface());
    item->setFocusOnClick(true);
    item->setAutoCreatePopupItems(true);
    window->setItem(item);

    connect(toplevel, &QObject::destroyed, this, &WinuxCompositor::onToplevelDestroyed);
    connect(toplevel, &QWaylandXdgToplevel::activatedChanged, this, [this, window] {
        if (window->topLevel() && window->topLevel()->activated()) activate(window);
    });
    emit windowAdded(window);
    activate(window);
}

void WinuxCompositor::onToplevelDestroyed() {
    for (int i = m_windows.size() - 1; i >= 0; --i) {
        if (m_windows[i]->topLevel().isNull()) {
            auto *removed = m_windows.takeAt(i);
            if (m_active == removed) m_active = nullptr;
            emit windowRemoved(removed);
            removed->deleteLater();
        }
    }
}

void WinuxCompositor::activate(WindowSurface *window) {
    if (!window || !window->topLevel() || window->workspace() != m_activeWorkspace) return;
    if (m_active == window) return;
    if (m_active && m_active->topLevel())
        m_active->topLevel()->sendConfigure(QSize(), {QWaylandXdgToplevel::ActivatedState});
    m_active = window;
    if (m_seat && window->topLevel()->surface())
        m_seat->setKeyboardFocus(window->topLevel()->surface());
    window->topLevel()->sendConfigure(QSize(), {QWaylandXdgToplevel::ActivatedState});
    emit activeWindowChanged(window);
}

void WinuxCompositor::moveWorkspace(WindowSurface *window, int workspace) {
    if (!window || !window->item() || workspace < 0) return;
    window->setWorkspace(workspace);
    window->item()->setVisible(workspace == m_activeWorkspace);
}

void WinuxCompositor::setWorkspace(int workspace) {
    if (workspace < 0 || workspace == m_activeWorkspace) return;
    m_activeWorkspace = workspace;
    m_active = nullptr;
    if (m_seat) m_seat->setKeyboardFocus(nullptr);
    for (auto *window : m_windows) {
        if (!window->item()) continue;
        window->item()->setVisible(window->workspace() == workspace && !window->minimized());
    }
    for (auto *window : m_windows) {
        if (window->workspace() == workspace && !window->minimized()) {
            activate(window);
            break;
        }
    }
    emit workspaceChanged(workspace);
}

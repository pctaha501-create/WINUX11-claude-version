#pragma once
#include <QObject>
#include <QProcess>
class Terminal final : public QObject {
    Q_OBJECT
public:
    explicit Terminal(QObject *parent = nullptr);
    Q_INVOKABLE void start();
    Q_INVOKABLE void write(const QString &text);
    Q_INVOKABLE void interrupt();
signals:
    void output(const QString &text);
    void exited(int code);
private:
    QProcess m_process;
};

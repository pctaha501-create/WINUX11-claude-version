#include <QCoreApplication>
#include <QVariantMap>
#include "../compatibility/wine_manager.h"

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    WineManager wine;
    const QVariantList detected = wine.detect();
    if (detected.size() != 3) return 1;
    for (const QVariant &entry : detected) {
        const QVariantMap item = entry.toMap();
        if (item.value("name").toString().isEmpty()) return 2;
        if (!item.contains("available")) return 3;
    }
    if (wine.launch("/definitely/not/a/real/windows-app.exe")) return 4;
    if (wine.launch("")) return 5;
    return 0;
}

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include "../services/filesystem_service.h"
int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    FilesystemService fs;
    const auto root = QDir::temp().filePath("winux11-fs-test");
    fs.removePath(root);
    if (!fs.createDirectory(root)) return 1;
    QFile f(root + "/a.txt");
    if (!f.open(QIODevice::WriteOnly)) return 2;
    f.write("x"); f.close();
    if (fs.list(root).size() != 1) return 3;
    if (!fs.renamePath(root + "/a.txt", root + "/b.txt")) return 4;
    if (!fs.removePath(root)) return 5;
    return 0;
}

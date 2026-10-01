#include "filesystem_service.h"
#include <QDateTime>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QStandardPaths>
static bool copyRecursive(const QString &from,const QString &to){
 QFileInfo source(from);if(source.isDir()){if(!QDir().mkpath(to))return false;for(const auto &child:QDir(from).entryInfoList(QDir::AllEntries|QDir::NoDotAndDotDot|QDir::Hidden))if(!copyRecursive(child.absoluteFilePath(),QDir(to).filePath(child.fileName())))return false;return true;}return QFile::copy(from,to);
}
QVariantList FilesystemService::list(const QString &path,bool includeHidden)const{
 QVariantList out;QDir d(path);if(!d.exists())return out;auto flags=QDir::AllEntries|QDir::NoDotAndDotDot|QDir::System;if(includeHidden)flags|=QDir::Hidden;
 for(const auto &i:d.entryInfoList(flags,QDir::DirsFirst|QDir::Name))out<<QVariantMap{{"name",i.fileName()},{"path",i.absoluteFilePath()},{"directory",i.isDir()},{"size",i.isDir()?0:i.size()},{"modified",i.lastModified()},{"permissions",int(i.permissions())},{"hidden",i.isHidden()}};
 return out;
}
bool FilesystemService::createDirectory(const QString &path)const{return QDir().mkpath(path);}
bool FilesystemService::createFile(const QString &path)const{QFile f(path);if(!f.open(QIODevice::WriteOnly))return false;f.close();return true;}
bool FilesystemService::removePath(const QString &path)const{QFileInfo i(path);if(!i.exists())return false;return i.isDir()?QDir(path).removeRecursively():QFile::remove(path);}
bool FilesystemService::renamePath(const QString &from,const QString &to)const{return QFile::rename(from,to);}
bool FilesystemService::copyPath(const QString &from,const QString &to)const{return copyRecursive(from,to);}
bool FilesystemService::movePath(const QString &from,const QString &to)const{return QFile::rename(from,to)||(copyRecursive(from,to)&&removePath(from));}
bool FilesystemService::trashPath(const QString &path)const{
 QFileInfo info(path);if(!info.exists())return false;const QString home=QStandardPaths::writableLocation(QStandardPaths::HomeLocation);const QString filesDir=home+"/.local/share/Trash/files",infoDir=home+"/.local/share/Trash/info";
 if(!QDir().mkpath(filesDir)||!QDir().mkpath(infoDir))return false;const QString base=info.fileName();QString target=filesDir+"/"+base;int n=1;while(QFileInfo::exists(target))target=filesDir+"/"+base+"."+QString::number(n++);
 if(!movePath(path,target))return false;QFile meta(infoDir+"/"+QFileInfo(target).fileName()+".trashinfo");if(!meta.open(QIODevice::WriteOnly|QIODevice::Text))return false;QTextStream s(&meta);s<<"[Trash Info]\nPath="<<info.absoluteFilePath()<<"\nDeletionDate="<<QDateTime::currentDateTime().toString(Qt::ISODate)<<"\n";return true;
}

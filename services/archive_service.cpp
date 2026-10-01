#include "archive_service.h"
#include "command_runner.h"
#include <QDir>
bool ArchiveService::extractTar(const QString &archive,const QString &destination)const{
 if(archive.isEmpty()||destination.isEmpty())return false;
 if(!QDir().mkpath(destination))return false;
 const auto r=CommandRunner::run("tar",{"-xf",archive,"-C",destination},120000);
 return r.started&&r.exitCode==0;
}
bool ArchiveService::createTar(const QString &source,const QString &archive)const{
 if(source.isEmpty()||archive.isEmpty())return false;
 const QFileInfo info(source);
 const QString parent=info.absolutePath(),name=info.fileName();
 const auto r=CommandRunner::run("tar",{"-cf",archive,"-C",parent,name},120000);
 return r.started&&r.exitCode==0;
}

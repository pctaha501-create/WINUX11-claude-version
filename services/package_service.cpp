#include "package_service.h"
#include "command_runner.h"
#include <QRegularExpression>
QVariantList PackageService::upgradable()const{
 auto r=CommandRunner::run("apt","list",{"--upgradable"},8000);
 QVariantList out;if(!r.started)return {QVariantMap{{"available",false},{"error",r.stderrText}}};
 for(const auto &line:r.stdoutText.split('\n',Qt::SkipEmptyParts))
  if(!line.startsWith("Listing"))out<<line;
 return out;
}
static bool validPackage(const QString &p){return QRegularExpression("^[A-Za-z0-9][A-Za-z0-9+._:-]{0,127}$").match(p).hasMatch();}
bool PackageService::install(const QString &p)const{
 if(!validPackage(p))return false;
 auto r=CommandRunner::run("pkexec",{"apt-get","install","-y",p},120000);
 return r.started&&r.exitCode==0;
}
bool PackageService::remove(const QString &p)const{
 if(!validPackage(p))return false;
 auto r=CommandRunner::run("pkexec",{"apt-get","remove","-y",p},120000);
 return r.started&&r.exitCode==0;
}

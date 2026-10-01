#include "screenshot_service.h"
#include "command_runner.h"
#include <QFileInfo>
bool ScreenshotService::captureScreen(const QString &path)const{
 const QStringList candidates={"grim","gnome-screenshot","scrot"};
 for(const auto &tool:candidates){
  auto check=CommandRunner::run("sh",{"-c","command -v -- "+tool},1000);
  if(!check.started||check.exitCode!=0)continue;
  QStringList args;
  if(tool=="grim")args={path};
  else if(tool=="gnome-screenshot")args={"-f",path};
  else args={path};
  const auto r=CommandRunner::run(tool,args,10000);
  if(r.started&&r.exitCode==0&&QFileInfo::exists(path))return true;
 }
 return false;
}

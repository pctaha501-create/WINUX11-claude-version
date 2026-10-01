#include "media_service.h"
#include "command_runner.h"
#include <QFileInfo>
#include <QUrl>
MediaService::MediaService(QObject *p):QObject(p){connect(&m_recorder,&QProcess::stateChanged,this,[this]{emit recordingChanged();});}
bool MediaService::play(const QString &path)const{
 if(path.isEmpty())return false;
 for(const auto &tool:QStringList{"mpv","vlc","ffplay"}){
  const auto c=CommandRunner::run("sh",{"-c","command -v -- "+tool},1000);
  if(c.started&&c.exitCode==0)return QProcess::startDetached(tool,{path});
 }
 return QProcess::startDetached("xdg-open",{QUrl::fromUserInput(path).toString()});
}
bool MediaService::openImage(const QString &path)const{return QProcess::startDetached("xdg-open",{QUrl::fromLocalFile(QFileInfo(path).absoluteFilePath()).toString()});}
bool MediaService::captureCamera(const QString &device,const QString &path)const{
 const QString dev=device.isEmpty()?QStringLiteral("/dev/video0"):device;
 const auto c=CommandRunner::run("sh",{"-c","command -v -- ffmpeg"},1000);if(!c.started||c.exitCode!=0)return false;
 const auto r=CommandRunner::run("ffmpeg",{"-y","-f","v4l2","-i",dev,"-frames:v","1",path},15000);
 return r.started&&r.exitCode==0&&QFileInfo::exists(path);
}
bool MediaService::startRecording(const QString &path){
 if(recording()||path.isEmpty())return false;
 QString program="pw-record";QStringList args={path};
 const auto c=CommandRunner::run("sh",{"-c","command -v -- pw-record"},1000);
 if(!c.started||c.exitCode!=0){program="arecord";args={"-f","cd",path};}
 m_recorder.setProgram(program);m_recorder.setArguments(args);m_recorder.start();return m_recorder.waitForStarted(1500);
}
void MediaService::stopRecording(){if(recording())m_recorder.terminate();}

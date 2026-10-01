#include "download_service.h"
#include <QFile>
#include <QFileInfo>
#include <QNetworkReply>
#include <QNetworkRequest>
DownloadService::DownloadService(QObject *p):QObject(p){}
bool DownloadService::download(const QString &url,const QString &destination){
 QUrl u(url);if(!u.isValid()||(u.scheme()!="http"&&u.scheme()!="https")||destination.isEmpty())return false;
 auto *reply=m_manager.get(QNetworkRequest(u));
 auto *file=new QFile(destination,reply);
 if(!file->open(QIODevice::WriteOnly)){reply->abort();file->deleteLater();return false;}
 connect(reply,&QNetworkReply::readyRead,reply,[reply,file]{file->write(reply->readAll());});
 connect(reply,&QNetworkReply::finished,reply,[this,reply,file]{
  const bool ok=reply->error()==QNetworkReply::NoError;
  file->flush();file->close();if(!ok)file->remove();
  const QString msg=ok?file->fileName():reply->errorString();
  file->deleteLater();reply->deleteLater();emit finished(ok,msg);
 });
 return true;
}

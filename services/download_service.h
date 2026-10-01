#pragma once
#include <QObject>
#include <QNetworkAccessManager>
class DownloadService final:public QObject{
 Q_OBJECT
public:
 explicit DownloadService(QObject *parent=nullptr);
 Q_INVOKABLE bool download(const QString &url,const QString &destination);
signals:void finished(bool ok,const QString &message);
private:
 QNetworkAccessManager m_manager;
};

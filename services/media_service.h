#pragma once
#include <QObject>
#include <QProcess>
#include <QStringList>
class MediaService final:public QObject{
 Q_OBJECT
 Q_PROPERTY(bool recording READ recording NOTIFY recordingChanged)
public:
 explicit MediaService(QObject *parent=nullptr);
 Q_INVOKABLE bool play(const QString &path)const;
 Q_INVOKABLE bool openImage(const QString &path)const;
 Q_INVOKABLE bool captureCamera(const QString &device,const QString &path)const;
 Q_INVOKABLE bool startRecording(const QString &path);
 Q_INVOKABLE void stopRecording();
 bool recording()const{return m_recorder.state()!=QProcess::NotRunning;}
signals:void recordingChanged();
private:
 QProcess m_recorder;
};

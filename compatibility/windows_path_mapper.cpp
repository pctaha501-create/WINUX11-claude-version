#include "windows_path_mapper.h"
#include <QDir>
#include <QStandardPaths>
QString WindowsPathMapper::compatibilityRoot()const{return QStandardPaths::writableLocation(QStandardPaths::HomeLocation)+"/.local/share/winux11/compat";}
QString WindowsPathMapper::toLinuxPath(const QString &p)const{
 QString s=p.trimmed(); if(s.size()<2||s[1]!=':') return s;
 const QChar drive=s[0].toUpper(); QString rest=s.mid(2);rest.replace('\\','/');
 const QString root=compatibilityRoot();
 if(drive=='C') return root+"/C"+rest;
 if(drive=='D') return root+"/D"+rest;
 return root+"/"+drive+rest;
}
QString WindowsPathMapper::toWindowsPath(const QString &p)const{
 const QString root=QDir::cleanPath(compatibilityRoot());
 const QString clean=QDir::cleanPath(p);
 if(!clean.startsWith(root+"/")) return p;
 const QString rel=clean.mid(root.size()+1);
 if(rel.size()>1&&rel[1]=='/') return rel.left(1)+":"+rel.mid(1);
 return p;
}

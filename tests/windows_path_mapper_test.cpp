#include <QCoreApplication>
#include "../compatibility/windows_path_mapper.h"
int main(int argc,char **argv){
 QCoreApplication app(argc,argv);
 WindowsPathMapper mapper;
 const auto linuxPath=mapper.toLinuxPath("C:\\Users\\Test\\file.txt");
 if(!linuxPath.contains("/C/Users/Test/file.txt"))return 1;
 if(mapper.toWindowsPath(linuxPath)!="C:/Users/Test/file.txt")return 2;
 if(mapper.toLinuxPath("/tmp/x")!="/tmp/x")return 3;
 return 0;
}

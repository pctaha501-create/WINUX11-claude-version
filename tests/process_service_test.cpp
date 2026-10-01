#include <QCoreApplication>
#include "../services/process_service.h"
int main(int argc,char **argv){
 QCoreApplication app(argc,argv);
 ProcessService service;
 const auto list=service.processes();
 if(list.isEmpty()) return 1;
 return 0;
}

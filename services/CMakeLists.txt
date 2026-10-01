add_library(winux11-services STATIC
  command_runner.cpp command_runner.h
  system_info.cpp system_info.h
  filesystem_service.cpp filesystem_service.h
  linux_capabilities.cpp linux_capabilities.h
  security_service.cpp security_service.h)
target_link_libraries(winux11-services PUBLIC Qt6::Core)
target_include_directories(winux11-services PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

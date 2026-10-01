add_library(winux11-services STATIC
 command_runner.cpp command_runner.h system_info.cpp system_info.h filesystem_service.cpp filesystem_service.h
 linux_capabilities.cpp linux_capabilities.h security_service.cpp security_service.h process_service.cpp process_service.h
 system_control_service.cpp system_control_service.h screenshot_service.cpp screenshot_service.h package_service.cpp package_service.h
 download_service.cpp download_service.h archive_service.cpp archive_service.h calculator_service.cpp calculator_service.h
 text_editor_service.cpp text_editor_service.h media_service.cpp media_service.h)
target_link_libraries(winux11-services PUBLIC Qt6::Core Qt6::Network)
target_include_directories(winux11-services PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

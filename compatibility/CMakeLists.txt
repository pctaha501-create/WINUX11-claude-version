add_library(winux11-compatibility STATIC wine_manager.cpp wine_manager.h windows_path_mapper.cpp windows_path_mapper.h)
target_link_libraries(winux11-compatibility PUBLIC Qt6::Core winux11-services)
target_include_directories(winux11-compatibility PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ../services)

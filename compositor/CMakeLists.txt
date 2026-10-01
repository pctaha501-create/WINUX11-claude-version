qt_add_executable(winux11-compositor main.cpp compositor.cpp compositor.h shell_ipc.cpp shell_ipc.h)
target_link_libraries(winux11-compositor PRIVATE Qt6::Core Qt6::Gui Qt6::Network Qt6::WaylandCompositor)
install(TARGETS winux11-compositor RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

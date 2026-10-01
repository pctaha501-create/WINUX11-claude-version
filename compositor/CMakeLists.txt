qt_add_executable(winux11-compositor main.cpp compositor.cpp compositor.h)
target_link_libraries(winux11-compositor PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::WaylandCompositor)
qt_add_resources(winux11-compositor "shell" FILES ../shell/qml/Shell.qml)
install(TARGETS winux11-compositor RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

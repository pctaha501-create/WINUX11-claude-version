qt_add_executable(winux11-shell main.cpp shell_controller.cpp shell_controller.h)
target_link_libraries(winux11-shell PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 Qt6::Network)
qt_add_resources(winux11-shell "shell_qml" FILES Shell.qml)
install(TARGETS winux11-shell RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

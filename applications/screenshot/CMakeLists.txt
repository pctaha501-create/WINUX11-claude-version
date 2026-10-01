qt_add_executable(winux11-screenshot main.cpp)
target_link_libraries(winux11-screenshot PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 winux11-services)
install(TARGETS winux11-screenshot RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-screenshot "screenshot_qml" PREFIX "/" FILES Screenshot.qml)

qt_add_executable(winux11-softwarecenter main.cpp)
target_link_libraries(winux11-softwarecenter PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 winux11-services)
install(TARGETS winux11-softwarecenter RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-softwarecenter "softwarecenter_qml" PREFIX "/" FILES SoftwareCenter.qml)

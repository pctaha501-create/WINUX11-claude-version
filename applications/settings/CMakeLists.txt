qt_add_executable(winux11-settings main.cpp)
target_link_libraries(winux11-settings PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 winux11-services)
install(TARGETS winux11-settings RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-settings "settings_qml" PREFIX "/" FILES Settings.qml)

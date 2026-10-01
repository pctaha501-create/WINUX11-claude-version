qt_add_executable(winux11-network main.cpp)
target_link_libraries(winux11-network PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 winux11-services)
install(TARGETS winux11-network RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-network "network_qml" FILES Network.qml)

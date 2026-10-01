qt_add_executable(winux11-explorer main.cpp)
target_link_libraries(winux11-explorer PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 winux11-services)
install(TARGETS winux11-explorer RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-explorer "explorer_qml" PREFIX "/" FILES Explorer.qml)

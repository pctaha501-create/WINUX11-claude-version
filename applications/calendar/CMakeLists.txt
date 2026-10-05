qt_add_executable(winux11-calendar main.cpp)
target_link_libraries(winux11-calendar PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2)
qt_add_resources(winux11-calendar "calendar_qml" PREFIX "/" FILES Calendar.qml)
install(TARGETS winux11-calendar RUNTIME DESTINATION \${CMAKE_INSTALL_BINDIR})

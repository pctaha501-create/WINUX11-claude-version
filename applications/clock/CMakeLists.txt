qt_add_executable(winux11-clock main.cpp)
target_link_libraries(winux11-clock PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2)
install(TARGETS winux11-clock RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-clock "clock_qml" PREFIX "/" FILES Clock.qml)

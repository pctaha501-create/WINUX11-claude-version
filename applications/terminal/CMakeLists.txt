qt_add_executable(winux11-terminal main.cpp terminal.cpp terminal.h)
target_link_libraries(winux11-terminal PRIVATE Qt6::Core Qt6::Gui Qt6::Quick Qt6::QuickControls2)
install(TARGETS winux11-terminal RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-terminal "terminal_qml" FILES terminal.qrc)

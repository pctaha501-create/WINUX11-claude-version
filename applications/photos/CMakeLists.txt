qt_add_executable(winux11-photos main.cpp)
target_link_libraries(winux11-photos PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 winux11-services)
install(TARGETS winux11-photos RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-photos "photos_qml" PREFIX "/" FILES Photos.qml)

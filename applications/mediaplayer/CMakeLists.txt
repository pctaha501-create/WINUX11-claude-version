qt_add_executable(winux11-mediaplayer main.cpp)
target_link_libraries(winux11-mediaplayer PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 winux11-services)
install(TARGETS winux11-mediaplayer RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
qt_add_resources(winux11-mediaplayer "media_qml" PREFIX "/" FILES MediaPlayer.qml)

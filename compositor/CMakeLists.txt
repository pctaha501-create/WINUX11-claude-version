set(WINUX11_QT_WAYLAND_COMPOSITOR_INCLUDE_DIR "" CACHE PATH "Qt Wayland Compositor include directory")
set(WINUX11_QT_WAYLAND_COMPOSITOR_LIBRARY "" CACHE FILEPATH "Qt Wayland Compositor library")
if(NOT WINUX11_QT_WAYLAND_COMPOSITOR_INCLUDE_DIR)
 find_path(WINUX11_QT_WAYLAND_COMPOSITOR_INCLUDE_DIR qwaylandcompositor.h
  PATHS /usr/include/x86_64-linux-gnu/qt6/QtWaylandCompositor /usr/include/qt6/QtWaylandCompositor)
endif()
if(NOT WINUX11_QT_WAYLAND_COMPOSITOR_LIBRARY)
 find_file(WINUX11_QT_WAYLAND_COMPOSITOR_LIBRARY
  NAMES libQt6WaylandCompositor.so libQt6WaylandCompositor.so.6
  PATHS /usr/lib/x86_64-linux-gnu /usr/lib)
endif()
if(NOT WINUX11_QT_WAYLAND_COMPOSITOR_INCLUDE_DIR OR NOT WINUX11_QT_WAYLAND_COMPOSITOR_LIBRARY)
 message(FATAL_ERROR "WINUX11 requires Qt6 Wayland Compositor development headers and library")
endif()
qt_add_executable(winux11-compositor main.cpp compositor.cpp compositor.h shell_ipc.cpp shell_ipc.h)
target_include_directories(winux11-compositor PRIVATE ${WINUX11_QT_WAYLAND_COMPOSITOR_INCLUDE_DIR})
target_link_libraries(winux11-compositor PRIVATE Qt6::Core Qt6::Gui Qt6::Network Qt6::Quick ${WINUX11_QT_WAYLAND_COMPOSITOR_LIBRARY})
install(TARGETS winux11-compositor RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
add_executable(winux11-tests command_runner_test.cpp filesystem_test.cpp)
target_link_libraries(winux11-tests PRIVATE Qt6::Core winux11-services)
add_test(NAME winux11-tests COMMAND winux11-tests)

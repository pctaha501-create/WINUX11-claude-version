add_executable(winux11-command-test command_runner_test.cpp)
target_link_libraries(winux11-command-test PRIVATE Qt6::Core winux11-services)
add_test(NAME winux11-command-test COMMAND winux11-command-test)

add_executable(winux11-filesystem-test filesystem_test.cpp)
target_link_libraries(winux11-filesystem-test PRIVATE Qt6::Core winux11-services)
add_test(NAME winux11-filesystem-test COMMAND winux11-filesystem-test)

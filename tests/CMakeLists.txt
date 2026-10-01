add_executable(winux11-command-test command_runner_test.cpp)
target_link_libraries(winux11-command-test PRIVATE Qt6::Core winux11-services)
add_test(NAME winux11-command-test COMMAND winux11-command-test)

add_executable(winux11-filesystem-test filesystem_test.cpp)
target_link_libraries(winux11-filesystem-test PRIVATE Qt6::Core winux11-services)
add_test(NAME winux11-filesystem-test COMMAND winux11-filesystem-test)

add_executable(winux11-process-test process_service_test.cpp)
target_link_libraries(winux11-process-test PRIVATE Qt6::Core winux11-services)
add_test(NAME winux11-process-test COMMAND winux11-process-test)

add_executable(winux11-path-test windows_path_mapper_test.cpp)
target_link_libraries(winux11-path-test PRIVATE Qt6::Core winux11-compatibility)
add_test(NAME winux11-path-test COMMAND winux11-path-test)

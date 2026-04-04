cmake_minimum_required(VERSION 3.10)
project(mlkem_native_basic C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Options
set(MLK_PARAMETER_SET "1024" CACHE STRING "ML-KEM parameter set (512, 768, 1024)")

# Compiler flags matching the Makefile
if(MSVC)
    add_compile_options(/W4 /WX)
else()
    add_compile_options(
        -Wall -Wextra -Werror=unused-result -Wpedantic -Werror
        -Wmissing-prototypes -Wshadow -Wpointer-arith -Wredundant-decls
        -Wconversion -Wsign-conversion -Wno-long-long -Wno-unknown-pragmas
        -Wno-unused-command-line-argument -O3 -fomit-frame-pointer
    )
endif()

# Sources
file(GLOB_RECURSE MLK_SOURCES FOLLOW_SYMLINKS "mlkem/src/*.c")
file(GLOB RNG_SOURCES "test/notrandombytes/*.c")

# Create proxy directory for mlkem_native to allow the original include path
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mlkem_native)
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/mlkem/mlkem_native.h DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/mlkem_native)
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/mlkem/mlkem_native_config.h DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/mlkem_native)

# Shared Library
add_library(mlkem_native_lib SHARED ${MLK_SOURCES} ${RNG_SOURCES})
target_include_directories(mlkem_native_lib PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_include_directories(mlkem_native_lib PUBLIC mlkem)
target_include_directories(mlkem_native_lib PUBLIC test/notrandombytes)
target_compile_definitions(mlkem_native_lib PUBLIC
    MLK_CONFIG_NAMESPACE_PREFIX=mlkem
    MLK_CONFIG_PARAMETER_SET=${MLK_PARAMETER_SET}
)

if(WIN32 OR CYGWIN)
    target_compile_definitions(mlkem_native_lib PRIVATE "MLK_CONFIG_EXTERNAL_API_QUALIFIER=__declspec(dllexport)")
    target_compile_definitions(mlkem_native_lib INTERFACE "MLK_CONFIG_EXTERNAL_API_QUALIFIER=__declspec(dllimport)")
else()
    target_compile_definitions(mlkem_native_lib PRIVATE "MLK_CONFIG_EXTERNAL_API_QUALIFIER=__attribute__((visibility(\"default\")))")
    set_target_properties(mlkem_native_lib PROPERTIES C_VISIBILITY_PRESET hidden)
endif()

# Executable (basic example)
# Copy main.c to the binary directory to bypass local broken symlinks during compilation on Windows
configure_file(examples/basic/main.c ${CMAKE_CURRENT_BINARY_DIR}/examples/basic/main.c COPYONLY)
add_executable(basic_example ${CMAKE_CURRENT_BINARY_DIR}/examples/basic/main.c)
target_link_libraries(basic_example PRIVATE mlkem_native_lib)

# Executable (basic_deterministic example)
# Copy main.c to the binary directory to bypass local broken symlinks during compilation on Windows
configure_file(examples/basic_deterministic/main.c ${CMAKE_CURRENT_BINARY_DIR}/examples/basic_deterministic/main.c COPYONLY)
add_executable(basic_deterministic_example ${CMAKE_CURRENT_BINARY_DIR}/examples/basic_deterministic/main.c)
target_link_libraries(basic_deterministic_example PRIVATE mlkem_native_lib)

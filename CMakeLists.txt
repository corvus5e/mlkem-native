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

# Shared Library
add_library(mlkem_native_lib SHARED ${MLK_SOURCES} ${RNG_SOURCES})
target_include_directories(mlkem_native_lib PUBLIC mlkem)
target_compile_definitions(mlkem_native_lib PUBLIC
    MLK_CONFIG_NAMESPACE_PREFIX=mlkem
    MLK_CONFIG_PARAMETER_SET=${MLK_PARAMETER_SET}
)

# Executable (basic example)
add_executable(basic_example examples/basic/main.c)
target_link_libraries(basic_example PRIVATE mlkem_native_lib)

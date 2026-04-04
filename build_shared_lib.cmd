@echo off
setlocal

REM Uncomment one of the following lines to select the target architecture
set ARCH=x64
REM set ARCH=Win32

if "%ARCH%"=="x64" (
    set BUILD_DIR=build
    set CMAKE_ARGS=-A x64
) else (
    set BUILD_DIR=build32
    set CMAKE_ARGS=-A Win32
)

if not exist %BUILD_DIR% mkdir %BUILD_DIR%
cd %BUILD_DIR%
cmake -S .. -B . %CMAKE_ARGS%
cmake --build . --config Release
cd ..

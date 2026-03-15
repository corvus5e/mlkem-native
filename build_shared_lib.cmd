@echo off
setlocal
REM  cmake -G "Visual Studio 17 2022" -A Win32 -B build32
if not exist build mkdir build
cd build
cmake -S .. -B .
cmake --build . --config Release
cd ..

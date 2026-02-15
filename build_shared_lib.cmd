@echo off
setlocal

if not exist build mkdir build
cd build
cmake -S .. -B .
cmake --build .
cd ..

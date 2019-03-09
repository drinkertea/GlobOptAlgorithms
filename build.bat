@echo off
mkdir build
cd build

cmake -G "Visual Studio 15 Win64" -DCMAKE_PREFIX_PATH=C:\Qt\5.12.1\msvc2015_64  ../
cd ..

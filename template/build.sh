#!/bin.sh

mkdir -p build
cd build -j 24
cmake ..
make
cd ..

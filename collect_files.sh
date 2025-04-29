#!/bin/bash
g++ -std=c++17 -o code code.cpp -lstdc++fs #компиляция кода
if [[ "$1" == "--max_depth" ]]; then
    ./code "$1" "$2" "$3" "$4"
else
    ./code "$1" "$2"
fi
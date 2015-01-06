#!/usr/bin/env bash
PATH_TC="/TrinityCore"
PATH_BUILD="/build"
print_status () {
  printf "\n## $1\n\n"
}

print_status "Running cmake"

mkdir $PATH_BUILD
cd $PATH_TC
mkdir build
cd build

cmake ../ -DPREFIX=/build -DTOOLS=1 -DWITH_WARNINGS=1

print_status "Running make"

make -j $(nproc)

print_status "Installing"

make install

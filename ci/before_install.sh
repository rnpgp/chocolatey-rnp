#!/bin/sh
set -ex

msys_install() {
  packages="
    tar
    zlib-devel
    libbz2-devel
    git
    automake
    autoconf
    libtool
    automake-wrapper
    gnupg2
    make
    pkgconfig
    mingw64/$MINGW_64_PREFIX-cmake
    mingw64/$MINGW_64_PREFIX-gcc
    mingw64/$MINGW_64_PREFIX-json-c
    mingw64/$MINGW_64_PREFIX-libbotan
    mingw64/$MINGW_64_PREFIX-python2
  "
  pacman --noconfirm -S --needed ${packages}
}

msys_install

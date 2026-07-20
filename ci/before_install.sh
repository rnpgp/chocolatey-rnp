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
    pkgconf
    $MINGW_64_PREFIX-cmake
    $MINGW_64_PREFIX-gcc
    $MINGW_64_PREFIX-json-c
    $MINGW_64_PREFIX-libbotan
    $MINGW_64_PREFIX-python
  "
  pacman --noconfirm -S --needed ${packages}
}

msys_install

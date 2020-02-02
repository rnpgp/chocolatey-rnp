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
    mingw64/mingw-w64-x86_64-cmake
    mingw64/mingw-w64-x86_64-gcc
    mingw64/mingw-w64-x86_64-json-c
    mingw64/mingw-w64-x86_64-libbotan
    mingw64/mingw-w64-x86_64-python2
  "
  pacman --noconfirm -S --needed ${packages}

  # msys includes ruby 2.6.1 while we need lower version
  #wget http://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-ruby-2.5.3-1-any.pkg.tar.xz -O /tmp/ruby-2.5.3.pkg.tar.xz
  #pacman --noconfirm --needed -U /tmp/ruby-2.5.3.pkg.tar.xz
  #rm /tmp/ruby-2.5.3.pkg.tar.xz
}

msys_install

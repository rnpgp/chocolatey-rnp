#!/usr/bin/env bash

cp $MSYS2/$RNP_INSTALL/bin/*.exe rnp/tools/$BITNESS
pacman -Qe > rnp/tools/$BITNESS/packages.txt

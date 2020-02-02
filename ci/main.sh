#!/usr/bin/env bash
set -eux

CMAKE=cmake

cmakeopts=(
  "-DCMAKE_BUILD_TYPE=Release"
  "-DBUILD_SHARED_LIBS=yes"
  "-DCMAKE_INSTALL_PREFIX=${RNP_INSTALL}"
  "-G" "MSYS Makefiles"
)

mkdir -p "${LOCAL_BUILDS}/rnp-build"
rnpsrc="$PWD"
pushd "${LOCAL_BUILDS}/rnp-build"

# update dll search path for windows
export PATH="${LOCAL_BUILDS}/rnp-build/lib:${LOCAL_BUILDS}/rnp-build/bin:${LOCAL_BUILDS}/rnp-build/src/lib:$PATH"

${CMAKE} "${cmakeopts[@]}" "$rnpsrc"
make -j${MAKE_PARALLEL} VERBOSE=1 install

popd

exit 0


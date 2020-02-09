#!/usr/bin/env bash
set -eux

CMAKE=cmake

cmakeopts=(
  "-DCMAKE_BUILD_TYPE=Release"
  "-DBUILD_SHARED_LIBS=no"
  "-DCMAKE_INSTALL_PREFIX=${RNP_INSTALL}"
  "-G" "MSYS Makefiles"
)

mkdir -p "${RNP_BUILD}"
pushd "${RNP_BUILD}"

# update dll search path for windows
export PATH="${RNP_BUILD}/lib:${RNP_BUILD}/bin:${RNP_BUILD}/src/lib:$PATH"

${CMAKE} "${cmakeopts[@]}" "$RNPSRC"
make -j${MAKE_PARALLEL} VERBOSE=1 install

popd

exit 0


: "${LOCAL_BUILDS:=$HOME/local-builds}"
: "${LOCAL_INSTALLS:=$HOME/local-installs}"
: "${BOTAN_INSTALL:=$LOCAL_INSTALLS/botan-install}"
: "${JSONC_INSTALL:=$LOCAL_INSTALLS/jsonc-install}"
: "${GPG_INSTALL:=$LOCAL_INSTALLS/gpg-install}"
: "${RNP_INSTALL:=$LOCAL_INSTALLS/rnp-install-$BITNESS}"
: "${RNP_BUILD:=$LOCAL_BUILDS/rnp-build-$BITNESS}"
: "${RNPSRC:=$HOME/rnpsrc}"
for var in LOCAL_BUILDS LOCAL_INSTALLS BOTAN_INSTALL JSONC_INSTALL \
  GPG_INSTALL RNP_BUILD RNP_INSTALL \
  RNPSRC; do
  export "${var?}"
  echo "Exported ${var?}=${!var}"
done

if [ "$BUILD_MODE" = "sanitize" ]; then
  export CXX=clang++
  export CC=clang
fi

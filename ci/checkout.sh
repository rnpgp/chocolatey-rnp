#!/usr/bin/env bash

VERSION=$(powershell.exe -ExecutionPolicy Bypass -File ${GITHUB_WORKSPACE}/ci/version.ps1)
echo "Determined RNP version to build: $VERSION"
rm -rf "$RNPSRC"
git clone --branch v$VERSION --depth 1 --recurse-submodules https://github.com/rnpgp/rnp.git "$RNPSRC"

# rnp 0.18.1 is missing <cstring> in src/lib/crypto/mem.cpp, which newer
# compilers reject. The fix is already on rnp main; apply it here for the
# 0.18.1 package build.
PATCH="$GITHUB_WORKSPACE/ci/rnp-0.18.1-fix-mem-cstring.patch"
if git -C "$RNPSRC" apply --check "$PATCH" 2>/dev/null; then
    git -C "$RNPSRC" apply "$PATCH"
    echo "Applied $PATCH"
fi

#!/usr/bin/env bash

VERSION=$(powershell.exe -ExecutionPolicy Bypass -File ${GITHUB_WORKSPACE}/ci/version.ps1)
echo "Determined RNP version to build: $VERSION"
git clone --branch v$VERSION --depth 1 https://github.com/rnpgp/rnp.git "$RNPSRC"

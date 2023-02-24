#!/bin/sh

set -e

export VERSION="${CIRRUS_TAG:-SNAPSHOT}"

mkdir -p .ci/template/Tart.app/Contents/MacOS/Tart
cp .build/arm64-apple-macosx/debug/tart .ci/template/Tart.app/Contents/MacOS/Tart
pkgbuild --root .ci/template --version $VERSION --install-location '/Library/Application Support/Tart' --identifier com.github.cirruslabs.tart --sign 'Developer ID Installer: Cirrus Labs, Inc. (9M2P8L4D89)' "./dist/Tart-$VERSION.pkg"
xcrun notarytool submit "./dist/Tart-$VERSION.pkg" --keychain-profile "notarytool" --wait
xcrun stapler staple "./dist/Tart-$VERSION.pkg"

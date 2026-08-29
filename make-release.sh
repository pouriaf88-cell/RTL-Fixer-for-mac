#!/bin/bash
# Creates a distributable release zip for GitHub Releases.
# Usage:  ./make-release.sh
set -e
cd "$(dirname "$0")"

VERSION="1.1.0"

./build.sh

echo "▸ Packaging release..."
rm -rf release
mkdir -p release
ditto -c -k --keepParent "build/RTL Fixer.app" "release/RTL-Fixer-$VERSION.zip"
shasum -a 256 "release/RTL-Fixer-$VERSION.zip" > "release/RTL-Fixer-$VERSION.zip.sha256"

echo ""
echo "✅ Release artifacts ready:"
ls -la release/
echo ""
echo "Upload these to a GitHub Release (tag v$VERSION)."
echo "Note: unsigned/self-signed apps get quarantined — tell users to run:"
echo "    xattr -cr 'RTL Fixer.app'"
echo "or right-click → Open the first time."
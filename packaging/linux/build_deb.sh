#!/usr/bin/env bash
# Usage: packaging/linux/build_deb.sh <version>   (après `flutter build linux --release`)
set -euo pipefail
VERSION="${1:-1.0.0}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUNDLE="$ROOT/build/linux/x64/release/bundle"
PKG="$ROOT/build/deb/guenstravel7tours"
rm -rf "$PKG"
mkdir -p "$PKG/DEBIAN" "$PKG/opt/guenstravel7tours" "$PKG/usr/bin" \
         "$PKG/usr/share/applications" "$PKG/usr/share/icons/hicolor/256x256/apps"
cp -r "$BUNDLE"/. "$PKG/opt/guenstravel7tours/"
ln -s /opt/guenstravel7tours/guenstravel7tours "$PKG/usr/bin/guenstravel7tours"
cp "$ROOT/packaging/linux/guenstravel7tours.desktop" "$PKG/usr/share/applications/"
cp "$ROOT/assets/icon.png" "$PKG/usr/share/icons/hicolor/256x256/apps/guenstravel7tours.png"
cat > "$PKG/DEBIAN/control" <<CTL
Package: guenstravel7tours
Version: $VERSION
Section: web
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libnss3, libx11-xcb1, libxss1, libasound2 | libasound2t64, xclip
Maintainer: Guen's Travel <fixedevelloper@gmail.com>
Description: Guen's Travel 7 Tours
 Application de bureau pour https://test.guenstravel.com/
CTL
dpkg-deb --build --root-owner-group "$PKG" "$ROOT/build/guenstravel7tours_${VERSION}_amd64.deb"

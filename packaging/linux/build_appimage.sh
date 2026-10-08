#!/usr/bin/env bash
# Usage: packaging/linux/build_appimage.sh   (après `flutter build linux --release`)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
APPDIR="$ROOT/build/AppDir"
rm -rf "$APPDIR"; mkdir -p "$APPDIR/usr/bin"
cp -r "$ROOT/build/linux/x64/release/bundle"/. "$APPDIR/usr/bin/"
cp "$ROOT/packaging/linux/guenstravel7tours.desktop" "$APPDIR/"
cp "$ROOT/assets/icon.png" "$APPDIR/guenstravel7tours.png"
cat > "$APPDIR/AppRun" <<'RUN'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
cd "$HERE/usr/bin"
exec ./guenstravel7tours "$@"
RUN
chmod +x "$APPDIR/AppRun"
TOOL="$ROOT/build/appimagetool"
[ -x "$TOOL" ] || { curl -L -o "$TOOL" https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage; chmod +x "$TOOL"; }
ARCH=x86_64 "$TOOL" --appimage-extract-and-run "$APPDIR" "$ROOT/build/Guens-Travel-7-Tours-x86_64.AppImage"

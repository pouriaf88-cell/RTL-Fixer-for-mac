#!/bin/bash
# Builds "RTL Fixer.app" — a proper macOS app bundle with Liquid Glass UI.
set -e
cd "$(dirname "$0")"

echo "▸ Building (release)..."
swift build -c release

APP="build/RTL Fixer.app"
echo "▸ Creating app bundle: $APP"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cp ".build/release/RTLFixer" "$APP/Contents/MacOS/RTLFixer"
cp "assets/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"

# Bundle the Vazirmatn font
mkdir -p "$APP/Contents/Resources/fonts"
cp assets/fonts/*.ttf "$APP/Contents/Resources/fonts/"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>                <string>RTL Fixer</string>
    <key>CFBundleDisplayName</key>         <string>RTL Fixer</string>
    <key>CFBundleIdentifier</key>          <string>com.rtlfixer.app</string>
    <key>CFBundleVersion</key>             <string>1.1</string>
    <key>CFBundleShortVersionString</key>  <string>1.1.0</string>
    <key>CFBundleExecutable</key>          <string>RTLFixer</string>
    <key>CFBundleIconFile</key>            <string>AppIcon</string>
    <key>CFBundlePackageType</key>         <string>APPL</string>
    <key>CFBundleInfoDictionaryVersion</key> <string>6.0</string>
    <key>LSMinimumSystemVersion</key>      <string>26.0</string>
    <key>LSUIElement</key>                 <false/>
    <key>NSHighResolutionCapable</key>     <true/>
    <key>NSHumanReadableCopyright</key>    <string>MIT License — Vazirmatn font under SIL OFL 1.1</string>
</dict>
</plist>
PLIST

echo -n "APPL????" > "$APP/Contents/PkgInfo"

echo "▸ Code signing..."
# Sign with the stable self-signed identity so the macOS Accessibility (TCC)
# grant survives rebuilds. Falls back to ad-hoc if the identity is missing.
IDENTITY="RTL Fixer Developer"
if security find-identity -v -p codesigning | grep -q "$IDENTITY"; then
    codesign --force --sign "$IDENTITY" "$APP"
else
    echo "  (stable identity not found — falling back to ad-hoc)"
    codesign --force --sign - "$APP"
fi

echo ""
echo "✅ Done: $APP"
echo "   Run it with:  open \"build/RTL Fixer.app\""

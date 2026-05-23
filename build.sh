#!/bin/bash

set -e

APP_NAME="MacItDown"
BUILD_DIR=".build/release"
APP_DIR="dist/${APP_NAME}.app"

echo "Building Swift package..."
swift build -c release

echo "Creating app bundle..."

mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

cp "$BUILD_DIR/$APP_NAME" \
   "$APP_DIR/Contents/MacOS/$APP_NAME"

echo "Copying bundled Python environment..."

cp -R python-env \
   "$APP_DIR/Contents/Resources/python-env"

echo "Checking for app icons..."
# Choose an icon source from Resources/AppIcon.appiconset (prefer the 1024px icns)
ICON_SRC=""
# If the appiconset contains PNGs (Xcode-style), assemble into a single .icns
if [ -d "Resources/AppIcon.appiconset" ]; then
   if ls Resources/AppIcon.appiconset/*.png >/dev/null 2>&1; then
      echo "Found PNGs in AppIcon.appiconset; assembling .icns with iconutil"
      TMP_ICNS="$(mktemp -u)/AppIcon.icns"
      # iconutil will create the .icns from the .iconset folder
      iconutil -c icns Resources/AppIcon.appiconset -o "$TMP_ICNS" 2>/dev/null || true
      if [ -f "$TMP_ICNS" ]; then
         ICON_SRC="$TMP_ICNS"
      fi
   fi
fi
if [ -d "Resources/AppIcon.appiconset" ]; then
   ICON_SRC=$(ls Resources/AppIcon.appiconset/*.icns 2>/dev/null | grep -i 1024 | head -n1 || true)
   if [ -z "$ICON_SRC" ]; then
      ICON_SRC=$(ls Resources/AppIcon.appiconset/*.icns 2>/dev/null | head -n1 || true)
   fi
fi
if [ -n "$ICON_SRC" ]; then
   echo "Using icon: $ICON_SRC"
   ICON_NAME="AppIcon"
   ICON_FILENAME="$ICON_NAME.icns"
   cp "$ICON_SRC" "$APP_DIR/Contents/Resources/$ICON_FILENAME"
else
   echo "No .icns found in Resources/AppIcon.appiconset; skipping icon copy."
   ICON_FILENAME=""
   ICON_NAME=""
fi
cat > "$APP_DIR/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>CFBundleExecutable</key>
   <string>${APP_NAME}</string>

   <key>CFBundleIdentifier</key>
   <string>com.example.MacItDown</string>

   <key>CFBundleName</key>
   <string>${APP_NAME}</string>

   <key>CFBundlePackageType</key>
   <string>APPL</string>

   <key>CFBundleShortVersionString</key>
   <string>1.0</string>

   <key>CFBundleVersion</key>
   <string>1</string>

   <key>LSMinimumSystemVersion</key>
   <string>13.0</string>

   <key>NSHighResolutionCapable</key>
   <true/>
</dict>
</plist>
EOF

# If we have an icon name, insert CFBundleIconFile before the closing </dict>
if [ -n "$ICON_NAME" ]; then
   awk -v icon="$ICON_NAME" '{
      if ($0 == "</dict>") {
         print "    <key>CFBundleIconFile</key>";
         print "    <string>" icon "</string>";
      }
      print $0;
   }' "$APP_DIR/Contents/Info.plist" > "$APP_DIR/Contents/Info.plist.tmp" && mv "$APP_DIR/Contents/Info.plist.tmp" "$APP_DIR/Contents/Info.plist"
fi

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

echo "Done"
echo "App created at: $APP_DIR"

# Try to register the app with LaunchServices and refresh icon caches so Finder shows the new icon
echo "Refreshing LaunchServices and QuickLook caches (best-effort)"
LSR="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
if [ -x "$LSR" ]; then
   "$LSR" -f "$APP_DIR" >/dev/null 2>&1 || true
fi
touch "$APP_DIR" || true
if command -v qlmanage >/dev/null 2>&1; then
   qlmanage -r >/dev/null 2>&1 || true
   qlmanage -r cache >/dev/null 2>&1 || true
fi

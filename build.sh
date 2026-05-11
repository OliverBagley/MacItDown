#!/bin/bash

set -e

APP_NAME="MarkItDownApp"
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

cat > "$APP_DIR/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>

    <key>CFBundleIdentifier</key>
    <string>com.example.markitdownapp</string>

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

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

echo "Done"
echo "App created at: $APP_DIR"

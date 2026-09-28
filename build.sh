#!/bin/bash
# Build Agent Loft and install it to ~/Applications/Agent Loft.app
set -euo pipefail
cd "$(dirname "$0")"
APP="$HOME/Applications/Agent Loft.app"

mkdir -p build
swiftc -O -o build/AgentLoft AgentLoft.swift -framework SwiftUI -framework Cocoa -framework AppKit -parse-as-library
rm -rf build/assets && cp -R assets build/assets

if [ -d "$APP" ]; then
  # Remove before copying: overwriting a signed binary in place makes macOS kill it on launch
  rm -f "$APP/Contents/MacOS/AgentLoft"
  cp build/AgentLoft "$APP/Contents/MacOS/AgentLoft"
  rm -rf "$APP/Contents/Resources/assets"
  mkdir -p "$APP/Contents/Resources"
  cp -R assets "$APP/Contents/Resources/assets"
  codesign --force --deep -s - "$APP"
  echo "Installed to $APP"
else
  echo "Built build/AgentLoft (no app bundle at $APP; run ./build/AgentLoft)"
fi

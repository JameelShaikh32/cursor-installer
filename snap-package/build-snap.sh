#!/bin/bash

# Build script for Cursor Installer GUI Snap
# This script builds the snap package and provides testing options

set -e

echo "🚀 Building Cursor Installer GUI Snap Package"
echo "=============================================="

# Check if snapcraft is installed
if ! command -v snapcraft &> /dev/null; then
    echo "❌ snapcraft is not installed. Installing..."
    sudo snap install snapcraft --classic
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
snapcraft clean

# Build the snap
echo "🔨 Building snap package..."
snapcraft build

# Find the built snap file
SNAP_FILE=$(ls cursor-installer-gui_*.snap 2>/dev/null | head -n 1)

if [ -z "$SNAP_FILE" ]; then
    echo "❌ No snap file found after build"
    exit 1
fi

echo "✅ Snap package built successfully: $SNAP_FILE"

# Ask if user wants to test the snap
read -p "🤔 Do you want to test the snap locally? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧪 Installing snap for testing..."

    # Remove existing installation if present
    sudo snap remove cursor-installer-gui --purge 2>/dev/null || true

    # Install the snap
    sudo snap install "$SNAP_FILE" --dangerous --classic

    echo "✅ Snap installed successfully!"
    echo "🎯 You can now test it by running: cursor-installer-gui"
    echo "🗑️  To uninstall: sudo snap remove cursor-installer-gui --purge"
fi

# Ask if user wants to upload to store
read -p "📤 Do you want to upload to Snap Store? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Uploading to Snap Store..."

    # Check if logged in
    if ! snapcraft whoami &> /dev/null; then
        echo "🔐 Please login to Snap Store first:"
        snapcraft login
    fi

    # Upload the snap
    snapcraft upload "$SNAP_FILE"

    echo "✅ Snap uploaded successfully!"
    echo "🎯 You can now release it with: snapcraft release cursor-installer-gui <version> stable"
fi

echo "🎉 Build process completed!"
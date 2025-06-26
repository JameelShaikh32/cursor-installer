#!/bin/bash

# Check if cursor is already installed and remove it
if dpkg -l | grep -q "cursor-[0-9]*-[0-9]*-[0-9]*-x86-64"; then
    echo "Removing any existing cursor packages..."
    sudo apt remove cursor-*-*-*-x86-64 -y > /dev/null 2>&1
fi

# Check if appimage2deb is installed
if ! command -v appimage2deb &> /dev/null; then
    echo "Installing appimage2deb..."
    sudo snap install appimage2deb
fi

# Check if libfuse2 is installed
if ! dpkg -l | grep -q "libfuse2"; then
    echo "Installing libfuse2..."
    sudo apt update
    sudo apt install libfuse2 -y
fi

# Ask for AppImage file path
read -p "Enter the path to your Cursor AppImage file (leave blank if it's in the Downloads folder): " APPIMAGE_PATH
APPIMAGE_PATH=${APPIMAGE_PATH:-~/Downloads}

# If path is provided, change to that directory
if [ ! -z "$APPIMAGE_PATH" ]; then
    if [ -d "$APPIMAGE_PATH" ]; then
        echo "Changing to directory: $APPIMAGE_PATH"
        cd "$APPIMAGE_PATH"
    else
        echo "Error: Directory not found at $APPIMAGE_PATH"
        exit 1
    fi
fi

# Check if the old deb file exists
if [ -f "cursor-*.deb" ]; then
    # Store old deb file location
    OLD_DEB=$(ls cursor-*.deb)
    echo "Removing old deb file: $OLD_DEB"
    sudo apt remove "$OLD_DEB" -y > /dev/null 2>&1
fi

# Get the AppImage filename
APPIMAGE_FILE=$(ls Cursor-*-x86_64.AppImage | head -n 1)

# Convert AppImage to deb
echo "Converting AppImage to deb package..."
appimage2deb $APPIMAGE_FILE > /dev/null
DEB_FILE=$(ls cursor-*.deb | head -n 1)

# Install the new deb package
echo "Installing Cursor..."
if [ -f "$DEB_FILE" ]; then
    sudo dpkg -i "$DEB_FILE"
else
    echo "Error: DEB file not found at $DEB_FILE"
    exit 1
fi

echo "Cursor installation completed!"

# Delete the AppImage and deb files
echo "Cleaning up..."
rm -f "$APPIMAGE_FILE" "$DEB_FILE"
echo "Cleanup completed!"

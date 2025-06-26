#!/bin/bash

# Cursor Installer Release Script
# This script helps prepare and create a GitHub release

VERSION="1.0.0"
RELEASE_NAME="Cursor Installer v$VERSION"
RELEASE_TAG="v$VERSION"

echo "🚀 Preparing Cursor Installer Release v$VERSION"
echo "================================================"

# Check if we're in the right directory
if [ ! -f "cursor_installer_gui.py" ] || [ ! -f "cursor_installer.sh" ]; then
    echo "❌ Error: Please run this script from the cursor-installer root directory"
    exit 1
fi

# Create release directory
RELEASE_DIR="release-v$VERSION"
mkdir -p "$RELEASE_DIR"

echo "📦 Copying release files..."

# Copy main files
cp cursor_installer_gui.py "$RELEASE_DIR/"
cp cursor_installer.sh "$RELEASE_DIR/"
cp cursor-installer_1.0.0_all.deb "$RELEASE_DIR/"

# Copy desktop files
cp cursor-installer-gui.desktop "$RELEASE_DIR/"
cp cursor-installer.desktop "$RELEASE_DIR/"

# Copy icon
cp cursor-installer.svg "$RELEASE_DIR/"

# Copy documentation
cp README.md "$RELEASE_DIR/"
cp LICENSE "$RELEASE_DIR/"

# Create installation scripts
echo "📝 Creating installation scripts..."

# GUI installation script
cat > "$RELEASE_DIR/install-gui.sh" << 'EOF'
#!/bin/bash

echo "🚀 Installing Cursor Installer GUI..."

# Make GUI executable
chmod +x cursor_installer_gui.py

# Install desktop file
sudo cp cursor-installer-gui.desktop /usr/share/applications/

# Install icon
sudo cp cursor-installer.svg /usr/share/icons/hicolor/scalable/apps/

# Create symlink
sudo ln -sf $(pwd)/cursor_installer_gui.py /usr/local/bin/cursor-installer-gui

echo "✅ Cursor Installer GUI installed successfully!"
echo "   You can now run: cursor-installer-gui"
EOF

# CLI installation script
cat > "$RELEASE_DIR/install-cli.sh" << 'EOF'
#!/bin/bash

echo "🚀 Installing Cursor Installer CLI..."

# Make CLI executable
chmod +x cursor_installer.sh

# Install desktop file
sudo cp cursor-installer.desktop /usr/share/applications/

# Create symlink
sudo ln -sf $(pwd)/cursor_installer.sh /usr/local/bin/cursor-installer

echo "✅ Cursor Installer CLI installed successfully!"
echo "   You can now run: cursor-installer"
EOF

# DEB installation script
cat > "$RELEASE_DIR/install-deb.sh" << 'EOF'
#!/bin/bash

echo "🚀 Installing Cursor Installer DEB package..."

# Install the DEB package
sudo dpkg -i cursor-installer_1.0.0_all.deb

# Fix any dependency issues
sudo apt-get install -f

echo "✅ Cursor Installer DEB package installed successfully!"
echo "   You can now run: cursor-installer-gui or cursor-installer"
EOF

# Make scripts executable
chmod +x "$RELEASE_DIR"/*.sh

# Create release notes
cat > "$RELEASE_DIR/RELEASE_NOTES.md" << EOF
# Cursor Installer v$VERSION

## 🎉 What's New

- **Dual Interface**: Both GUI and CLI versions available
- **Modern Dark Theme**: Beautiful dark UI inspired by cursor.com
- **Improved Website**: Enhanced user experience with better navigation
- **DEB Package**: Easy installation via .deb package
- **Better Error Handling**: More robust installation process

## 📦 What's Included

### GUI Version
- \`cursor_installer_gui.py\` - Python GUI installer
- \`cursor-installer-gui.desktop\` - Desktop menu entry
- \`install-gui.sh\` - Quick installation script

### CLI Version
- \`cursor_installer.sh\` - Shell script installer
- \`cursor-installer.desktop\` - Desktop menu entry
- \`install-cli.sh\` - Quick installation script

### DEB Package
- \`cursor-installer_1.0.0_all.deb\` - Ubuntu package
- \`install-deb.sh\` - DEB installation script

## 🚀 Quick Start

### Option 1: GUI Installation (Recommended)
\`\`\`bash
chmod +x install-gui.sh
./install-gui.sh
\`\`\`

### Option 2: CLI Installation
\`\`\`bash
chmod +x install-cli.sh
./install-cli.sh
\`\`\`

### Option 3: DEB Package
\`\`\`bash
chmod +x install-deb.sh
./install-deb.sh
\`\`\`

## 📋 System Requirements

- Ubuntu 18.04+ (versions lower than 24)
- Python 3.8+ (for GUI version)
- Internet connection for dependencies
- sudo privileges for installation

## 🔧 Features

- ✅ Automatic AppImage to DEB conversion
- ✅ Dependency management (libfuse2, appimage2deb)
- ✅ Clean installation process
- ✅ Progress tracking and status updates
- ✅ Error handling with user-friendly messages
- ✅ Automatic cleanup of temporary files
- ✅ Desktop menu integration

## 🌐 Website

Visit our beautiful dark-themed website: [Cursor Installer](https://jameelshaikh32.github.io/cursor-installer/)

## 📖 Documentation

- [Installation Guide](https://github.com/JameelShaikh32/cursor-installer#installation)
- [GitHub Repository](https://github.com/JameelShaikh32/cursor-installer)
- [Report Issues](https://github.com/JameelShaikh32/cursor-installer/issues)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/JameelShaikh32/cursor-installer/blob/main/CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Created by [Jameel Shaikh](https://github.com/JameelShaikh32)**

Made with ❤️ for the Ubuntu community
EOF

# Create a zip file for easy download
echo "📦 Creating release archive..."
cd "$RELEASE_DIR"
zip -r "../cursor-installer-v$VERSION.zip" .
cd ..

echo ""
echo "✅ Release prepared successfully!"
echo "================================================"
echo "📁 Release files are in: $RELEASE_DIR/"
echo "📦 Archive created: cursor-installer-v$VERSION.zip"
echo ""
echo "📋 Next steps:"
echo "1. Review the files in $RELEASE_DIR/"
echo "2. Test the installation scripts"
echo "3. Create a GitHub release with tag: $RELEASE_TAG"
echo "4. Upload the files to the GitHub release"
echo "5. Update the website with download links"
echo ""
echo "🎉 Happy releasing!"
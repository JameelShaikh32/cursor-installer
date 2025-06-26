#!/bin/bash

# Create DEB package for Cursor Installer (GUI only)
# This script creates a proper .deb package that can be installed via apt

PACKAGE_NAME="cursor-installer-gui"
VERSION="1.0.0"
ARCH="all"
MAINTAINER="Jameel Shaikh <shaikhjameel17@gmail.com>"
DESCRIPTION="Cursor AI Editor GUI installer for Ubuntu (versions < 24)"

# Create package structure
PACKAGE_DIR="${PACKAGE_NAME}_${VERSION}_${ARCH}"
mkdir -p "${PACKAGE_DIR}/DEBIAN"
mkdir -p "${PACKAGE_DIR}/usr/local/bin"
mkdir -p "${PACKAGE_DIR}/usr/share/applications"
mkdir -p "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}"
mkdir -p "${PACKAGE_DIR}/usr/share/icons/hicolor/128x128/apps"

# Copy the GUI application
cp cursor_installer_gui.py "${PACKAGE_DIR}/usr/local/bin/cursor-installer-gui"
chmod +x "${PACKAGE_DIR}/usr/local/bin/cursor-installer-gui"

# Copy GUI desktop entry
cp cursor-installer-gui.desktop "${PACKAGE_DIR}/usr/share/applications/cursor-installer-gui.desktop"

# Copy icon if available
if [ -f "cursor-installer.svg" ]; then
    # Try to convert SVG to PNG if rsvg-convert is available
    if command -v rsvg-convert &> /dev/null; then
        rsvg-convert -w 128 -h 128 cursor-installer.svg -o "${PACKAGE_DIR}/usr/share/icons/hicolor/128x128/apps/cursor-installer.png"
    else
        # Copy SVG as fallback
        cp cursor-installer.svg "${PACKAGE_DIR}/usr/share/icons/hicolor/128x128/apps/cursor-installer.svg"
    fi
fi

# Create control file
cat > "${PACKAGE_DIR}/DEBIAN/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: ${MAINTAINER}
Depends: python3 (>= 3.8), python3-tk, bash, snapd, libfuse2
Priority: optional
Section: devel
Description: ${DESCRIPTION}
 This package provides a GUI installer for Cursor AI Editor
 on Ubuntu systems (versions lower than 24). It converts the Cursor
 AppImage to a proper .deb package and installs it system-wide.
 .
 Features:
  * Automatic AppImage to DEB conversion using appimage2deb
  * Dependency management (installs libfuse2 and appimage2deb)
  * Clean installation process (removes existing dpkg packages)
  * Automatic cleanup of temporary files
  * User-friendly GUI interface with progress tracking
EOF

# Create postinst script
cat > "${PACKAGE_DIR}/DEBIAN/postinst" << EOF
#!/bin/bash
set -e

# Update desktop database
update-desktop-database /usr/share/applications

# Make script executable
chmod +x /usr/local/bin/cursor-installer-gui

# Create symlink for easier access
ln -sf /usr/local/bin/cursor-installer-gui /usr/bin/cursor-installer-gui

exit 0
EOF
chmod +x "${PACKAGE_DIR}/DEBIAN/postinst"

# Create postrm script
cat > "${PACKAGE_DIR}/DEBIAN/postrm" << EOF
#!/bin/bash
set -e

# Update desktop database
update-desktop-database /usr/share/applications

# Remove symlink
rm -f /usr/bin/cursor-installer-gui

exit 0
EOF
chmod +x "${PACKAGE_DIR}/DEBIAN/postrm"

# Copy README as documentation
cp README.md "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/README.md"
gzip -9 "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/README.md"

# Create copyright file
cat > "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: cursor-installer-gui
Source: https://github.com/yourusername/cursor-installer

Files: *
Copyright: $(date +%Y) Jameel Shaikh
License: MIT
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 .
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
EOF

# Create changelog
cat > "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/changelog.Debian" << EOF
${PACKAGE_NAME} (${VERSION}) stable; urgency=medium

  * Initial release (GUI only)
  * Added GUI installer application
  * Added desktop integration
  * Added dependency management
  * Added custom icon

 -- ${MAINTAINER}  $(date -R)
EOF
gzip -9 "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/changelog.Debian"

# Build the .deb package
dpkg-deb --build "${PACKAGE_DIR}"

echo "Package created: ${PACKAGE_DIR}.deb"
echo "To install: sudo dpkg -i ${PACKAGE_DIR}.deb"
echo "To fix dependencies: sudo apt-get install -f"
echo ""
echo "After installation, you can run:"
echo "  cursor-installer-gui  # Graphical version"
echo "  # Or launch from Applications menu"
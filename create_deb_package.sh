#!/bin/bash

# Create DEB package for Cursor Installer
# This script creates a proper .deb package that can be installed via apt

PACKAGE_NAME="cursor-installer"
VERSION="1.1.0"
ARCH="all"
MAINTAINER="Jameel Shaikh <shaikhjameel17@gmail.com>"
DESCRIPTION="Cursor AI Editor installer for Ubuntu"
WEBSITE="https://jameelshaikh32.github.io/cursor-installer/"

# Create package structure
PACKAGE_DIR="${PACKAGE_NAME}_${VERSION}_${ARCH}"
mkdir -p "${PACKAGE_DIR}/DEBIAN"
mkdir -p "${PACKAGE_DIR}/usr/local/bin"
mkdir -p "${PACKAGE_DIR}/usr/share/applications"
mkdir -p "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}"
mkdir -p "${PACKAGE_DIR}/usr/share/icons/hicolor/128x128/apps"

# Copy the installer script
cp cursor_installer.sh "${PACKAGE_DIR}/usr/local/bin/cursor-installer"
chmod +x "${PACKAGE_DIR}/usr/local/bin/cursor-installer"

# Copy CLI icon if available
if [ -f "cursor-installer-cli.svg" ]; then
    # Try to convert SVG to PNG if rsvg-convert is available
    if command -v rsvg-convert &> /dev/null; then
        rsvg-convert -w 128 -h 128 cursor-installer-cli.svg -o "${PACKAGE_DIR}/usr/share/icons/hicolor/128x128/apps/cursor-installer.png"
    else
        # Copy SVG as fallback
        cp cursor-installer-cli.svg "${PACKAGE_DIR}/usr/share/icons/hicolor/128x128/apps/cursor-installer.svg"
    fi
fi

# Create desktop entry
cat > "${PACKAGE_DIR}/usr/share/applications/cursor-installer.desktop" << EOF
[Desktop Entry]
Version=1.1.0
Type=Application
Name=Cursor Installer
Comment=Install Cursor AI Editor on Ubuntu
Exec=cursor-installer
Icon=cursor-installer
Terminal=true
Categories=Development;IDE;
Keywords=cursor;editor;installer;ai;
EOF

# Create control file
cat > "${PACKAGE_DIR}/DEBIAN/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: ${MAINTAINER}
Depends: bash, snapd, libfuse2
Priority: optional
Section: devel
Homepage: ${WEBSITE}
Description: ${DESCRIPTION}
 This package provides an automated installer for Cursor AI Editor
 on Ubuntu systems. It converts the
 Cursor AppImage to a proper .deb package and installs it
 system-wide for Ubuntu 22.04 and below. For Ubuntu 24.04 and above, it uses the AppImage desktop entry method.
 .
 Features:
  * Automatic AppImage to DEB conversion for Ubuntu 22.04 and below
  * Automatic AppImage desktop entry method for Ubuntu 24.04 and above
  * Dependency management (libfuse2, appimage2deb)
  * Clean installation process
  * Automatic cleanup of temporary files
  * Progress tracking with spinner
  * Smart Ubuntu version detection
  * Desktop menu integration
 .
 Visit ${WEBSITE} for more information and documentation.
EOF

# Create postinst script
cat > "${PACKAGE_DIR}/DEBIAN/postinst" << EOF
#!/bin/bash
set -e

# Update desktop database
update-desktop-database /usr/share/applications

# Make script executable
chmod +x /usr/local/bin/cursor-installer

# Create symlink for easier access
ln -sf /usr/local/bin/cursor-installer /usr/bin/cursor-installer

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
rm -f /usr/bin/cursor-installer

exit 0
EOF
chmod +x "${PACKAGE_DIR}/DEBIAN/postrm"

# Copy README as documentation
cp README.md "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/README.md"
gzip -9 "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/README.md"

# Create copyright file
cat > "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: cursor-installer
Source: https://github.com/JameelShaikh32/cursor-installer
Homepage: ${WEBSITE}

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

  * New Features:
    - Added Ubuntu 24+ support with AppImage desktop entry method
    - Added progress spinner during AppImage conversion
    - Enhanced error handling and user feedback
    - Improved dependency management
  * Technical Improvements:
    - Smart Ubuntu version detection
    - Better desktop integration
    - Enhanced cleanup process
    - Updated project website integration
  * Documentation:
    - Added comprehensive README with installation guides
    - Updated website with dark theme and screenshots
    - Added release notes and changelog

 -- ${MAINTAINER}  $(date -R)

${PACKAGE_NAME} (1.0.0) stable; urgency=medium

  * Initial release (CLI only)
  * Added CLI installer application
  * Added desktop integration
  * Added dependency management
  * Added custom CLI icon

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
echo "  cursor-installer  # Command line version"
echo "  # Or launch from Applications menu"
echo ""
echo "Project website: ${WEBSITE}"
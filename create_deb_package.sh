#!/bin/bash

# Create DEB package for Cursor Installer
# This script creates a proper .deb package that can be installed via apt

PACKAGE_NAME="cursor-installer"
VERSION="1.0.0"
ARCH="all"
MAINTAINER="Your Name <your.email@example.com>"
DESCRIPTION="Cursor AI Editor installer for Ubuntu (versions < 24)"

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

# Create desktop entry
cat > "${PACKAGE_DIR}/usr/share/applications/cursor-installer.desktop" << EOF
[Desktop Entry]
Version=1.0
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
Description: ${DESCRIPTION}
 This package provides an automated installer for Cursor AI Editor
 on Ubuntu systems (versions lower than 24). It converts the
 Cursor AppImage to a proper .deb package and installs it
 system-wide.
 .
 Features:
  * Automatic AppImage to DEB conversion
  * Dependency management
  * Clean installation process
  * Automatic cleanup
EOF

# Create postinst script
cat > "${PACKAGE_DIR}/DEBIAN/postinst" << EOF
#!/bin/bash
set -e

# Update desktop database
update-desktop-database /usr/share/applications

# Make script executable
chmod +x /usr/local/bin/cursor-installer

exit 0
EOF
chmod +x "${PACKAGE_DIR}/DEBIAN/postinst"

# Create postrm script
cat > "${PACKAGE_DIR}/DEBIAN/postrm" << EOF
#!/bin/bash
set -e

# Update desktop database
update-desktop-database /usr/share/applications

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
Source: https://github.com/yourusername/cursor-installer

Files: *
Copyright: $(date +%Y) Your Name
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

# Build the .deb package
dpkg-deb --build "${PACKAGE_DIR}"

echo "Package created: ${PACKAGE_DIR}.deb"
echo "To install: sudo dpkg -i ${PACKAGE_DIR}.deb"
echo "To fix dependencies: sudo apt-get install -f"
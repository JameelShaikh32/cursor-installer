# Cursor AI Editor Installer for Ubuntu

A simple and automated installer script for Cursor AI Editor on Ubuntu systems (versions lower than v24). This script converts the Cursor AppImage file to a proper `.deb` package and installs it system-wide.

## 🚀 Features

- **Automatic AppImage to DEB conversion** using `appimage2deb`
- **Dependency management** - automatically installs required packages
- **Clean installation** - removes any existing Cursor packages installed via `dpkg` before installation
- **Automatic cleanup** - removes temporary files after installation
- **User-friendly** - prompts for AppImage file location with smart defaults
- **Graphical Interface** - modern GUI application with progress tracking
- **Command-line Interface** - script-based installation for automation

## 📦 Installing the Installer

You can install this installer script as a proper application in Ubuntu using several methods:

### Method 1: Install as .deb Package (Recommended)

1. **Build the .deb package:**

   ```bash
   chmod +x create_gui_deb_package.sh
   ./create_gui_deb_package.sh
   ```

2. **Install the package:**

   ```bash
   sudo dpkg -i cursor-installer_1.0.0_all.deb
   sudo apt-get install -f  # Fix any dependency issues
   ```

3. **Launch from Applications menu** or terminal:
   - GUI: `cursor-installer-gui` or launch from Applications menu
   - CLI: `cursor-installer`

### Method 2: Install as Snap Package

1. **Build the snap package:**

   ```bash
   snapcraft build
   ```

2. **Install the snap:**

   ```bash
   sudo snap install cursor-installer_1.0.0_amd64.snap --dangerous
   ```

3. **Launch:** `cursor-installer`

### Method 3: Manual Installation

1. **Make the scripts executable:**

   ```bash
   chmod +x cursor_installer.sh cursor_installer_gui.py
   ```

2. **Copy to system path:**

   ```bash
   sudo cp cursor_installer.sh /usr/local/bin/cursor-installer
   sudo cp cursor_installer_gui.py /usr/local/bin/cursor-installer-gui
   ```

3. **Create desktop shortcuts:**

   ```bash
   sudo cp cursor-installer.desktop /usr/share/applications/
   sudo cp cursor-installer-gui.desktop /usr/share/applications/
   sudo update-desktop-database
   ```

4. **Launch from Applications menu** or terminal:
   - GUI: `cursor-installer-gui`
   - CLI: `cursor-installer`

## 🖥️ GUI Application

The installer now includes a modern graphical user interface with the following features:

### GUI Features

- **File Browser** - Easy AppImage file selection
- **Progress Tracking** - Real-time installation progress
- **Log Output** - Detailed installation log
- **Dependency Checker** - Verify system requirements
- **Modern Design** - GNOME-inspired interface
- **Error Handling** - User-friendly error messages

### Running the GUI

```bash
# After installation
cursor-installer-gui

# Or launch from Applications menu
# Search for "Cursor Installer" in your applications
```

### GUI Screenshots

- **Main Interface**: Clean, modern design with file selection
- **Progress View**: Real-time installation progress with log output
- **Success Screen**: Confirmation when installation completes

## 📋 Prerequisites

- Ubuntu Linux (versions lower than v24)
- Internet connection
- Sudo privileges
- Cursor AppImage file downloaded from [cursor.com](https://www.cursor.com)
- Python 3.8+ (for GUI version)
- python3-tk (for GUI version)

## 🛠️ Installation

### Step 1: Download the Installer

Clone or download the repository to your local machine:

```bash
git clone <repository-url>
cd cursor-installer
```

### Step 2: Download Cursor AppImage

1. Visit [cursor.com](https://www.cursor.com/)
2. Download the Linux AppImage file for Cursor
3. The file will typically be named `Cursor-*-x86_64.AppImage`

### Step 3: Run the Installer

#### Option A: GUI Installation (Recommended for beginners)

```bash
cursor-installer-gui
```

Then follow the on-screen instructions to select your AppImage file.

#### Option B: Command-line Installation

```bash
chmod +x cursor_installer.sh
./cursor_installer.sh
```

3. When prompted, enter the path to your Cursor AppImage file:
   - If the file is in your Downloads folder, just press Enter
   - Otherwise, provide the full path to the directory containing the AppImage file

### Step 4: Launch Cursor

After installation, you can launch Cursor from:

- Applications menu
- Terminal: `cursor`
- Desktop shortcut (if created)

## 🔧 What the Script Does

The installer script performs the following operations:

1. **Checks for existing installations** and removes them (only if installed via `dpkg`)
2. **Installs dependencies**:
   - `appimage2deb` (via snap) - for AppImage to DEB conversion
   - `libfuse2` - required for AppImage execution
3. **Converts AppImage to DEB** package
4. **Installs the DEB package** system-wide
5. **Cleans up** temporary files

## 📁 File Locations

- **AppImage file**: Typically in `~/Downloads/` or user-specified location
- **Generated DEB file**: Same directory as the AppImage (temporary)
- **Installed application**: System-wide installation via `dpkg`
- **GUI application**: `/usr/local/bin/cursor-installer-gui`
- **CLI script**: `/usr/local/bin/cursor-installer`

## 🐛 Troubleshooting

### Common Issues

1. **Permission Denied**

   ```bash
   chmod +x cursor_installer.sh cursor_installer_gui.py
   ```

2. **AppImage not found**

   - Ensure the AppImage file is in the specified directory
   - Check the filename matches the pattern `Cursor-*-x86_64.AppImage`

3. **Snap not available**

   - Install snapd: `sudo apt install snapd`
   - Or manually install appimage2deb from alternative sources

4. **Installation fails**

   - Check for sufficient disk space
   - Ensure you have sudo privileges
   - Verify internet connection for dependency downloads

5. **GUI not working**

   - Install python3-tk: `sudo apt install python3-tk`
   - Ensure Python 3.8+ is installed: `python3 --version`

6. **Existing Cursor installation conflicts**
   - The script only removes packages installed via `dpkg`
   - If you have Cursor installed via other methods (snap, flatpak, manual installation), you may need to remove it manually first

### Manual Installation

If the script fails, you can perform the installation manually:

```bash
# Remove any existing Cursor packages (if installed via dpkg)
sudo apt remove cursor-*-*-*-x86-64 -y

# Install dependencies
sudo apt update
sudo apt install libfuse2 python3-tk
sudo snap install appimage2deb

# Convert AppImage to DEB
appimage2deb Cursor-*-x86_64.AppImage

# Install the generated DEB file
sudo dpkg -i cursor-*.deb
```

## 🗑️ Uninstallation

To remove Cursor from your system (if installed via this script):

```bash
sudo apt remove cursor-*-*-*-x86-64
```

**Note**: This only works for packages installed via `dpkg`. If Cursor was installed through other methods, you'll need to use the appropriate uninstallation method for that package manager.

## 📝 Notes

- This installer is specifically designed for Ubuntu versions lower than v24
- The script automatically handles dependency installation
- Temporary files are cleaned up after installation
- The installer supports custom AppImage file locations
- Both CLI and GUI versions are included in the package
- The GUI provides a more user-friendly experience for beginners

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests to improve this installer.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Cursor AI](https://cursor.com) for the excellent code editor
- [appimage2deb](https://github.com/AppImage/appimage2deb) for the conversion tool
- Ubuntu community for the excellent Linux distribution

---

**Happy coding with Cursor AI Editor! 🚀**

# Cursor Installer v1.1.0

## 🎉 What's New

### ✨ Major Features

- **Dual Interface Support**: Both GUI and CLI versions available
- **Ubuntu 24+ Compatibility**: AppImage desktop entry method for newer Ubuntu versions
- **Modern GUI**: Beautiful dark-themed interface with progress tracking
- **DEB Package**: Easy installation via .deb package
- **Progress Spinner**: Visual feedback during AppImage conversion

### 🔧 Technical Improvements

- **Smart Version Detection**: Automatically chooses installation method based on Ubuntu version
- **Enhanced Error Handling**: Better error messages and recovery
- **Dependency Management**: Automatic installation of required packages
- **Clean Installation**: Removes existing packages before fresh install
- **Desktop Integration**: Proper menu entries and icons

### 📦 Installation Methods

- **GUI Version**: `cursor-installer-gui` - User-friendly graphical interface
- **CLI Version**: `cursor-installer` - Command-line automation
- **DEB Package**: `cursor-installer_1.0.0_all.deb` - System package

### 🌐 Website

- **Dark Theme**: Modern, cursor.com-inspired design
- **Responsive Layout**: Works on all devices
- **Screenshots**: Visual installation guides

## 🚀 Quick Start

```bash
# Download and install
wget https://github.com/JameelShaikh32/cursor-installer/releases/download/v1.0.0/cursor-installer_1.0.0_all.deb
sudo dpkg -i cursor-installer_1.0.0_all.deb
sudo apt-get install -f

# Launch GUI
cursor-installer-gui

# Or use CLI
cursor-installer
```

## 📋 System Requirements

- Ubuntu 18.04+ (versions < 24: DEB install, versions ≥ 24: AppImage desktop entry)
- Python 3.8+ (for GUI version)
- Internet connection for dependencies
- sudo privileges

## 🔗 Links

- **Website**: https://jameelshaikh32.github.io/cursor-installer/
- **Repository**: https://github.com/JameelShaikh32/cursor-installer
- **Issues**: https://github.com/JameelShaikh32/cursor-installer/issues

---

**Created by [Jameel Shaikh](https://github.com/JameelShaikh32)**  
Made with ❤️ for the Ubuntu community

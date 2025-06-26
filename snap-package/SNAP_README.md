# Cursor Installer GUI - Snap Package

This directory contains all the files needed to build and publish the Cursor Installer GUI as a snap package to the Ubuntu Snap Store.

## 📁 File Structure

```
snap-package/
├── cursor_installer_gui.py      # Main GUI application
├── cursor-installer.svg         # Application icon
├── cursor-installer-gui.desktop # Desktop entry
├── snapcraft.yaml              # Snap package configuration
├── build-snap.sh               # Build script
├── SNAP_PUBLISHING_GUIDE.md    # Detailed publishing guide
├── SNAP_README.md              # This file
└── .github/
    └── workflows/
        └── snap.yml            # GitHub Actions workflow
```

## 🚀 Quick Start

### Prerequisites

1. **Ubuntu One Account**: Create an account at [snapcraft.io](https://snapcraft.io)
2. **Snapcraft CLI**: Install the snapcraft tool
3. **GitHub Repository**: Host your code on GitHub (recommended)

### Build and Test

1. **Install snapcraft**:

   ```bash
   sudo snap install snapcraft --classic
   ```

2. **Build the snap**:

   ```bash
   ./build-snap.sh
   ```

3. **Test locally** (optional):
   ```bash
   sudo snap install cursor-installer-gui_1.0.0_amd64.snap --dangerous --classic
   cursor-installer-gui
   ```

### Publish to Store

1. **Login to Snap Store**:

   ```bash
   snapcraft login
   ```

2. **Register snap name**:

   ```bash
   snapcraft register cursor-installer-gui
   ```

3. **Upload and release**:
   ```bash
   snapcraft upload cursor-installer-gui_1.0.0_amd64.snap
   snapcraft release cursor-installer-gui 1.0.0 stable
   ```

## 🔧 Manual Build

If you prefer to build manually:

```bash
# Clean previous builds
snapcraft clean

# Build the snap
snapcraft build

# Install for testing
sudo snap install cursor-installer-gui_1.0.0_amd64.snap --dangerous --classic

# Test the application
cursor-installer-gui

# Uninstall
sudo snap remove cursor-installer-gui --purge
```

## 📤 Automated Publishing

### GitHub Actions

The repository includes a GitHub Actions workflow that automatically builds and publishes the snap when you:

1. Push a tag starting with `v` (e.g., `v1.0.0`)
2. Manually trigger the workflow

### Setup Automated Publishing

1. **Add Snap Store Token**:

   - Go to [snapcraft.io/account](https://snapcraft.io/account)
   - Generate a store token
   - Add it to GitHub repository secrets as `SNAP_STORE_TOKEN`

2. **Create a Release**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

## 🎨 Store Assets

### Required Assets

- ✅ **Icon**: `cursor-installer.svg` (included)
- 📸 **Screenshots**: Create screenshots of the GUI in action
- 📝 **Description**: Already configured in `snapcraft.yaml`

### Creating Screenshots

Take screenshots of:

1. Main interface (file selection)
2. Dependency checking
3. Installation progress
4. Success message

Save as PNG files and update `snapcraft.yaml`:

```yaml
screenshots:
  - url: https://raw.githubusercontent.com/YOUR_USERNAME/cursor-installer/main/screenshots/main.png
    alt: Main installer interface
  # Add more screenshots...
```

## 🔍 Testing Checklist

Before publishing, test:

- [ ] Snap builds successfully
- [ ] GUI launches correctly
- [ ] File selection works
- [ ] Dependency checking works
- [ ] Installation process works
- [ ] Error handling works
- [ ] Desktop entry appears in applications menu
- [ ] Icon displays correctly

## 🐛 Troubleshooting

### Common Issues

1. **Build Failures**:

   ```bash
   snapcraft clean
   snapcraft build
   ```

2. **Permission Issues**:

   - Ensure `system-files` plug is included
   - Test with `--classic` confinement

3. **Name Already Taken**:

   ```bash
   snapcraft register cursor-installer-gui-v2
   ```

4. **Login Issues**:
   ```bash
   snapcraft logout
   snapcraft login
   ```

### Getting Help

- [Snapcraft Forum](https://forum.snapcraft.io/)
- [Snapcraft Documentation](https://snapcraft.io/docs)
- [Store Policies](https://snapcraft.io/docs/store-policies)

## 📊 Monitoring

After publication, monitor:

```bash
# View snap statistics
snapcraft metrics cursor-installer-gui

# View channel information
snapcraft status cursor-installer-gui
```

## 🔄 Updates

To update the snap:

1. Update version in `snapcraft.yaml`
2. Update code as needed
3. Build and test
4. Upload new version
5. Release to stable channel

## 📚 Additional Resources

- [SNAP_PUBLISHING_GUIDE.md](SNAP_PUBLISHING_GUIDE.md) - Detailed publishing guide
- [Main README.md](../README.md) - Project overview
- [Snapcraft Documentation](https://snapcraft.io/docs)

---

**Happy publishing! 🚀**

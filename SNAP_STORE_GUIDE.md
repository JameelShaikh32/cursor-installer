# Publishing to Ubuntu Snap Store Guide

This guide will walk you through the process of publishing your Cursor Installer to the Ubuntu Snap Store.

## 📋 Prerequisites

1. **Ubuntu One Account**: Create an account at [snapcraft.io](https://snapcraft.io)
2. **Snapcraft CLI**: Install the snapcraft tool
3. **GitHub Repository**: Host your code on GitHub (recommended)
4. **Snap Name Registration**: Register your snap name

## 🛠️ Setup Steps

### Step 1: Install Snapcraft

```bash
sudo snap install snapcraft --classic
```

### Step 2: Login to Snapcraft

```bash
snapcraft login
```

### Step 3: Register Snap Name

```bash
snapcraft register cursor-installer
```

**Note**: If `cursor-installer` is taken, try alternatives like:

- `cursor-ai-installer`
- `cursor-editor-installer`
- `cursor-ubuntu-installer`

### Step 4: Update snapcraft.yaml

Edit the `snapcraft.yaml` file with your actual information:

```yaml
# Replace these with your actual details
website: https://github.com/YOUR_USERNAME/cursor-installer
source-code: https://github.com/YOUR_USERNAME/cursor-installer
issues: https://github.com/YOUR_USERNAME/cursor-installer/issues
```

## 🎨 Store Assets

### Create Store Icon

Create a 512x512 PNG icon:

```bash
mkdir -p snap/gui
# Create or copy your icon to snap/gui/icon.png
```

### Create Screenshots

Take screenshots of your installer in action:

1. **Main interface screenshot**
2. **Installation progress screenshot**
3. **Success message screenshot**

Save them as PNG files and update `snapcraft.yaml`:

```yaml
screenshots:
  - url: https://raw.githubusercontent.com/YOUR_USERNAME/cursor-installer/main/screenshots/main.png
    alt: Cursor Installer main interface
  - url: https://raw.githubusercontent.com/YOUR_USERNAME/cursor-installer/main/screenshots/progress.png
    alt: Installation progress
  - url: https://raw.githubusercontent.com/YOUR_USERNAME/cursor-installer/main/screenshots/success.png
    alt: Installation completed successfully
```

## 🏗️ Building and Testing

### Build the Snap

```bash
snapcraft build
```

### Test Locally

```bash
# Install the built snap
sudo snap install cursor-installer_1.0.0_amd64.snap --dangerous

# Test the installer
cursor-installer

# Uninstall for testing
sudo snap remove cursor-installer
```

### Test in Confined Mode

```bash
# Test with confinement
snapcraft build --target-arch amd64
sudo snap install cursor-installer_1.0.0_amd64.snap --dangerous --classic
```

## 📤 Publishing to Store

### Step 1: Upload to Store

```bash
snapcraft upload cursor-installer_1.0.0_amd64.snap
```

### Step 2: Release to Stable Channel

```bash
snapcraft release cursor-installer 1.0.0 stable
```

### Step 3: Set Store Metadata

```bash
snapcraft push-metadata cursor-installer
```

## 🔄 Continuous Publishing

### GitHub Actions Workflow

Create `.github/workflows/snap.yml`:

```yaml
name: Build and Release Snap

on:
  push:
    tags:
      - "v*"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build Snap
        run: |
          sudo snap install snapcraft --classic
          snapcraft build

      - name: Upload to Snap Store
        run: |
          echo "${{ secrets.SNAP_STORE_TOKEN }}" | snapcraft login --with -
          snapcraft upload cursor-installer_*.snap
          snapcraft release cursor-installer ${{ github.ref_name#v }} stable
```

### Setup Store Token

1. Go to [snapcraft.io/account](https://snapcraft.io/account)
2. Generate a store token
3. Add it to GitHub repository secrets as `SNAP_STORE_TOKEN`

## 📊 Store Analytics

Monitor your snap's performance:

```bash
# View snap statistics
snapcraft metrics cursor-installer

# View channel information
snapcraft status cursor-installer
```

## 🚀 Best Practices

### 1. Version Management

- Use semantic versioning (e.g., 1.0.0, 1.0.1, 1.1.0)
- Update version in `snapcraft.yaml` before each release

### 2. Testing

- Test on multiple Ubuntu versions
- Test with different AppImage locations
- Test error scenarios

### 3. Documentation

- Keep README.md updated
- Add troubleshooting section
- Include usage examples

### 4. Store Listing

- Write compelling description
- Use relevant keywords
- Add clear screenshots
- Respond to user reviews

## 🔧 Troubleshooting

### Common Issues

1. **Name Already Taken**

   ```bash
   snapcraft register cursor-installer-v2
   ```

2. **Build Failures**

   ```bash
   snapcraft clean
   snapcraft build
   ```

3. **Permission Issues**

   - Ensure `system-files` plug is included
   - Test with `--classic` confinement

4. **Store Rejection**
   - Check store policies
   - Ensure proper metadata
   - Verify snap works correctly

### Support Channels

- [Snapcraft Forum](https://forum.snapcraft.io/)
- [Snapcraft Documentation](https://snapcraft.io/docs)
- [Store Policies](https://snapcraft.io/docs/store-policies)

## 📈 Post-Publication

### Monitor Performance

- Track downloads and installations
- Monitor user reviews and ratings
- Respond to user feedback

### Regular Updates

- Fix bugs and issues
- Add new features
- Update dependencies
- Maintain compatibility

### Community Engagement

- Respond to GitHub issues
- Help users on forums
- Share on social media
- Write blog posts about your snap

## 🎯 Success Metrics

Track these metrics for success:

- **Downloads**: Number of snap installations
- **Reviews**: User ratings and feedback
- **Issues**: GitHub issues and bug reports
- **Community**: Forum mentions and discussions

---

**Good luck with your Snap Store publication! 🚀**

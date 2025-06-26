# Publishing Cursor Installer GUI to Snap Store

This guide will walk you through the process of publishing your Cursor Installer GUI to the Ubuntu Snap Store.

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
snapcraft register cursor-installer-gui
```

**Note**: If `cursor-installer-gui` is taken, try alternatives like:

- `cursor-ai-installer`
- `cursor-editor-installer`
- `cursor-ubuntu-installer-gui`

### Step 4: Update snapcraft.yaml

Edit the `snapcraft.yaml` file with your actual information:

```yaml
# Replace these with your actual details
website: https://github.com/YOUR_USERNAME/cursor-installer
source-code: https://github.com/YOUR_USERNAME/cursor-installer
issues: https://github.com/YOUR_USERNAME/cursor-installer/issues
```

## 🎨 Store Assets

### Store Icon

The icon is already included: `cursor-installer.svg`

### Create Screenshots

Take screenshots of your installer in action:

1. **Main interface screenshot** - Show the file selection and features
2. **Dependency check screenshot** - Show the dependency checking process
3. **Installation progress screenshot** - Show the installation in progress
4. **Success message screenshot** - Show the completion dialog

Save them as PNG files and update `snapcraft.yaml`:

```yaml
screenshots:
  - url: https://raw.githubusercontent.com/YOUR_USERNAME/cursor-installer/main/screenshots/main.png
    alt: Cursor Installer main interface
  - url: https://raw.githubusercontent.com/YOUR_USERNAME/cursor-installer/main/screenshots/deps.png
    alt: Dependency checking
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
sudo snap install cursor-installer-gui_1.0.0_amd64.snap --dangerous

# Test the installer
cursor-installer-gui

# Uninstall for testing
sudo snap remove cursor-installer-gui
```

### Test in Confined Mode

```bash
# Test with confinement
snapcraft build --target-arch amd64
sudo snap install cursor-installer-gui_1.0.0_amd64.snap --dangerous --classic
```

## 📤 Publishing to Store

### Step 1: Upload to Store

```bash
snapcraft upload cursor-installer-gui_1.0.0_amd64.snap
```

### Step 2: Release to Stable Channel

```bash
snapcraft release cursor-installer-gui 1.0.0 stable
```

### Step 3: Set Store Metadata

```bash
snapcraft push-metadata cursor-installer-gui
```

## 🔄 Continuous Publishing

### GitHub Actions Workflow

Create `.github/workflows/snap.yml` in your main repository:

```yaml
name: Build and Release Snap

on:
  push:
    tags:
      - "v*"
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Snapcraft
        uses: samuelmeuli/action-snapcraft@v1
        with:
          snapcraft-token: ${{ secrets.SNAP_STORE_TOKEN }}

      - name: Build and publish snap
        run: |
          # Build the snap
          snapcraft build

          # Upload to store
          snapcraft upload cursor-installer-gui_*.snap

          # Release to stable channel
          snapcraft release cursor-installer-gui ${{ github.ref_name#v }} stable
```

### Setup Store Token

1. Go to [snapcraft.io/account](https://snapcraft.io/account)
2. Generate a store token
3. Add it to GitHub repository secrets as `SNAP_STORE_TOKEN`

## 📊 Store Analytics

Monitor your snap's performance:

```bash
# View snap statistics
snapcraft metrics cursor-installer-gui

# View channel information
snapcraft status cursor-installer-gui
```

## 🚀 Best Practices

### 1. Version Management

- Use semantic versioning (e.g., 1.0.0, 1.0.1, 1.1.0)
- Update version in `snapcraft.yaml` before each release

### 2. Testing

- Test on multiple Ubuntu versions
- Test with different AppImage locations
- Test error scenarios
- Test dependency installation

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
   snapcraft register cursor-installer-gui-v2
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

## 📝 Store Listing Tips

### Description

- Start with a clear value proposition
- List key features with bullet points
- Mention target audience (Ubuntu users < v24)
- Include installation instructions

### Keywords

- cursor, editor, installer, ai, ubuntu, appimage, development, gui
- Use relevant terms users might search for

### Screenshots

- Show the main interface clearly
- Demonstrate the installation process
- Highlight key features
- Use consistent styling

---

**Good luck with your Snap Store publication! 🚀**

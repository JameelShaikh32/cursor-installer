#!/bin/bash

# Author: Jameel Shaikh
# Portfolio: https://jameelshaikh32.github.io/profile

echo -e "\033[1;36mAuthor: Jameel Shaikh\033[0m"
echo -e "\033[1;36mPortfolio: https://jameelshaikh32.github.io/profile\033[0m"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect Ubuntu version
get_ubuntu_version() {
    if command -v lsb_release &> /dev/null; then
        lsb_release -rs | cut -d. -f1
    elif [ -f /etc/os-release ]; then
        grep '^VERSION_ID=' /etc/os-release | cut -d'"' -f2 | cut -d. -f1
    else
        echo "0"
    fi
}

UBUNTU_VERSION=$(get_ubuntu_version)
echo -e "${BLUE}Detected Ubuntu version: $UBUNTU_VERSION${NC}"

if [ "$UBUNTU_VERSION" -le 22 ]; then
    # Progress tracking variables
    TOTAL_STEPS=8
    CURRENT_STEP=0

    # Function to show progress
    show_progress() {
        CURRENT_STEP=$((CURRENT_STEP + 1))
        local step_name="$1"
        local percentage=$((CURRENT_STEP * 100 / TOTAL_STEPS))
        echo -e "${BLUE}[${CURRENT_STEP}/${TOTAL_STEPS}] ${GREEN}${step_name}${NC} (${percentage}% complete)"
    }

    # Function to show dependency status
    check_dependency() {
        local dep_name="$1"
        local install_cmd="$2"
        local check_cmd="$3"
        
        echo -e "${YELLOW}Checking for ${dep_name}...${NC}"
        
        if eval "$check_cmd" &> /dev/null; then
            echo -e "${GREEN}✓ ${dep_name} is already installed${NC}"
            return 0
        else
            echo -e "${RED}✗ ${dep_name} is missing${NC}"
            echo -e "${YELLOW}Installing ${dep_name}...${NC}"
            if eval "$install_cmd"; then
                echo -e "${GREEN}✓ ${dep_name} installed successfully${NC}"
                return 0
            else
                echo -e "${RED}✗ Failed to install ${dep_name}${NC}"
                return 1
            fi
        fi
    }

    echo -e "${BLUE}=== Cursor Installer ===${NC}"
    echo -e "${BLUE}Starting installation process...${NC}"
    echo

    # Step 1: Check and remove existing cursor packages
    show_progress "Checking for existing Cursor installations"
    if dpkg -l | grep -q "cursor-[0-9]*-[0-9]*-[0-9]*-x86-64"; then
        echo -e "${YELLOW}Found existing Cursor packages, removing...${NC}"
        sudo apt remove cursor-*-*-*-x86-64 -y > /dev/null 2>&1
        echo -e "${GREEN}✓ Existing packages removed${NC}"
    else
        echo -e "${GREEN}✓ No existing Cursor packages found${NC}"
    fi
    echo

    # Step 2: Check and install appimage2deb
    show_progress "Checking and installing appimage2deb"
    if ! check_dependency "appimage2deb" "sudo snap install appimage2deb" "command -v appimage2deb"; then
        echo -e "${RED}Failed to install appimage2deb. Exiting...${NC}"
        exit 1
    fi
    echo

    # Step 3: Check and install libfuse2
    show_progress "Checking and installing libfuse2"
    if ! check_dependency "libfuse2" "sudo apt update && sudo apt install libfuse2 -y" "dpkg -l | grep -q 'libfuse2'"; then
        echo -e "${RED}Failed to install libfuse2. Exiting...${NC}"
        exit 1
    fi
    echo

    # Step 4: Get AppImage file path
    show_progress "Getting AppImage file location"
    read -p "Enter the path to your Cursor AppImage file (leave blank if it's in the Downloads folder): " APPIMAGE_PATH
    APPIMAGE_PATH=${APPIMAGE_PATH:-~/Downloads}
    echo -e "${GREEN}✓ Using path: $APPIMAGE_PATH${NC}"
    echo

    # Step 5: Navigate to directory
    show_progress "Navigating to AppImage directory"
    if [ ! -z "$APPIMAGE_PATH" ]; then
        if [ -d "$APPIMAGE_PATH" ]; then
            echo -e "${YELLOW}Changing to directory: $APPIMAGE_PATH${NC}"
            cd "$APPIMAGE_PATH"
            echo -e "${GREEN}✓ Successfully changed to directory${NC}"
        else
            echo -e "${RED}Error: Directory not found at $APPIMAGE_PATH${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✓ Using current directory${NC}"
    fi
    echo

    # Step 6: Clean up old deb files
    show_progress "Cleaning up old deb files"
    if [ -f "cursor-*.deb" ]; then
        OLD_DEB=$(ls cursor-*.deb)
        echo -e "${YELLOW}Found old deb file: $OLD_DEB${NC}"
        sudo apt remove "$OLD_DEB" -y > /dev/null 2>&1
        echo -e "${GREEN}✓ Old deb file removed${NC}"
    else
        echo -e "${GREEN}✓ No old deb files found${NC}"
    fi
    echo

    # Step 7: Convert AppImage to deb
    show_progress "Converting AppImage to deb package"
    APPIMAGE_FILE=$(ls Cursor-*-x86_64.AppImage 2>/dev/null | head -n 1)

    if [ -z "$APPIMAGE_FILE" ]; then
        echo -e "${RED}Error: No Cursor AppImage file found in current directory${NC}"
        echo -e "${YELLOW}Please make sure the Cursor AppImage file is in: $(pwd)${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Found AppImage: $APPIMAGE_FILE${NC}"
    echo -e "${YELLOW}Converting to deb package...${NC}"

    # Spinner function
    spinner() {
        local pid=$1
        local delay=0.1
        local spinstr='|/-\'
        while [ -d /proc/$pid ]; do
            local temp=${spinstr#?}
            printf " [%c]  " "$spinstr"
            spinstr=$temp${spinstr%$temp}
            sleep $delay
            printf "\b\b\b\b\b\b"
        done
        printf "    \b\b\b\b"
    }

    # Run appimage2deb with spinner
    (appimage2deb "$APPIMAGE_FILE" > /dev/null 2>&1) &
    SPIN_PID=$!
    spinner $SPIN_PID
    wait $SPIN_PID

    DEB_FILE=$(ls cursor-*.deb | head -n 1)
    if [ -f "$DEB_FILE" ]; then
        echo -e "${GREEN}✓ AppImage converted successfully to: $DEB_FILE${NC}"
    else
        echo -e "${RED}✗ Failed to convert AppImage to deb${NC}"
        exit 1
    fi
    echo

    # Step 8: Install the deb package
    show_progress "Installing Cursor from deb package"
    if [ -f "$DEB_FILE" ]; then
        echo -e "${YELLOW}Installing: $DEB_FILE${NC}"
        if sudo dpkg -i "$DEB_FILE"; then
            echo -e "${GREEN}✓ Cursor installed successfully!${NC}"
        else
            echo -e "${RED}✗ Failed to install Cursor${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: DEB file not found at $DEB_FILE${NC}"
        exit 1
    fi
    echo

    # Final cleanup
    echo -e "${BLUE}=== Final Cleanup ===${NC}"
    echo -e "${YELLOW}Removing temporary files...${NC}"
    rm -f "$APPIMAGE_FILE" "$DEB_FILE"
    echo -e "${GREEN}✓ Cleanup completed!${NC}"
    echo

    echo -e "${GREEN}🎉 Cursor installation completed successfully! 🎉${NC}"
    echo -e "${BLUE}You can now launch Cursor from your applications menu.${NC}"

    # Add 'cursor' function to ~/.bashrc and ~/.zshrc
    CURSOR_FUNC="\n# Cursor AppImage launcher function\nfunction cursor {\n    '$APPIMAGE_PATH/$APPIMAGE_FILE' \"\$@\"\n}\n"
    for rcfile in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if ! grep -q "function cursor {" "$rcfile" 2>/dev/null; then
            echo -e "$CURSOR_FUNC" >> "$rcfile"
            echo -e "${GREEN}✓ 'cursor' command added to $rcfile${NC}"
        fi
    done
    echo -e "${YELLOW}You can now run 'cursor' from your terminal to launch Cursor AppImage!${NC}"
else
    # Ubuntu 24 or greater: AppImage desktop entry method
    echo -e "${BLUE}Ubuntu 24 or greater detected. Using AppImage desktop entry method.${NC}"
    echo
    read -p "Enter the path to your Cursor AppImage file (leave blank if it's in the Downloads folder): " APPIMAGE_PATH
    APPIMAGE_PATH=${APPIMAGE_PATH:-~/Downloads}
    if [ ! -d "$APPIMAGE_PATH" ]; then
        echo -e "${RED}Directory not found: $APPIMAGE_PATH${NC}"
        exit 1
    fi
    cd "$APPIMAGE_PATH"
    APPIMAGE_FILE=$(ls Cursor-*.*.*-x86_64.AppImage 2>/dev/null | head -n 1)
    if [ -z "$APPIMAGE_FILE" ]; then
        echo -e "${RED}No Cursor AppImage file found in $APPIMAGE_PATH${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Making AppImage executable...${NC}"
    chmod +x "$APPIMAGE_FILE"
    echo -e "${GREEN}✓ AppImage is now executable${NC}"
    # Copy icon to ~/.local/share/icons if not already there
    ICON_TARGET="$HOME/.local/share/icons/cursor-installer.png"
    mkdir -p "$HOME/.local/share/icons"
    SCRIPT_DIR="$(dirname "$(realpath "$0")")"
    if [ -f "$SCRIPT_DIR/cursor-installer.png" ]; then
        cp "$SCRIPT_DIR/cursor-installer.png" "$ICON_TARGET"
    fi
    # Create desktop entry
    DESKTOP_ENTRY="$HOME/.local/share/applications/cursor-appimage.desktop"
    cat > "$DESKTOP_ENTRY" <<EOL
[Desktop Entry]
Type=Application
Name=Cursor
Exec=$APPIMAGE_PATH/$APPIMAGE_FILE --no-sandbox
Icon=$ICON_TARGET
Terminal=false
Categories=Utility;
Comment=Cursor Editor AppImage
EOL
    chmod +x "$DESKTOP_ENTRY"
    echo -e "${GREEN}✓ Desktop entry created at $DESKTOP_ENTRY${NC}"
    update-desktop-database ~/.local/share/applications/
    echo -e "${GREEN}✓ Applications menu refreshed!${NC}"
    echo -e "${GREEN}You can now launch Cursor from your applications menu!${NC}"

    # Add 'cursor' function to ~/.bashrc and ~/.zshrc
    CURSOR_FUNC="\n# Cursor AppImage launcher function\nfunction cursor {\n    '$APPIMAGE_PATH/$APPIMAGE_FILE' \"\$@\"\n}\n"
    for rcfile in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if ! grep -q "function cursor {" "$rcfile" 2>/dev/null; then
            echo -e "$CURSOR_FUNC" >> "$rcfile"
            echo -e "${GREEN}✓ 'cursor' command added to $rcfile${NC}"
        fi
    done
    echo -e "${YELLOW}You can now run 'cursor' from your terminal to launch Cursor AppImage!${NC}"
fi

#!/usr/bin/env python3
"""
Cursor AI Editor Installer GUI
A graphical interface for installing Cursor AI Editor on Ubuntu
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import subprocess
import threading
import os
import sys
from pathlib import Path

class CursorInstallerGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Cursor AI Editor Installer")
        self.root.geometry("800x600")
        self.root.minsize(700, 500)

        # Set icon if available
        try:
            self.root.iconname("cursor-installer")
        except:
            pass

        # Variables
        self.appimage_path = tk.StringVar()
        self.install_status = tk.StringVar(value="Ready to install")
        self.is_installing = False
        self.missing_deps = []

        # Configure style
        self.setup_styles()

        # Create GUI
        self.create_widgets()

        # Center window
        self.center_window()

    def setup_styles(self):
        """Configure ttk styles for a modern look"""
        style = ttk.Style()

        # Configure colors
        style.configure("Title.TLabel",
                       font=("Ubuntu", 24, "bold"),
                       foreground="#3584e4")

        style.configure("Subtitle.TLabel",
                       font=("Ubuntu", 12),
                       foreground="#5e5c64")

        style.configure("Status.TLabel",
                       font=("Ubuntu", 10),
                       foreground="#26a269")

        style.configure("Error.TLabel",
                       font=("Ubuntu", 10),
                       foreground="#e01b5c")

        style.configure("Primary.TButton",
                       font=("Ubuntu", 11, "bold"),
                       padding=(20, 10))

        style.configure("Secondary.TButton",
                       font=("Ubuntu", 11),
                       padding=(15, 8))

    def create_widgets(self):
        """Create the main GUI widgets"""
        # Main container
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)

        # Header
        header_frame = ttk.Frame(main_frame)
        header_frame.grid(row=0, column=0, columnspan=2, pady=(0, 20))

        title_label = ttk.Label(header_frame,
                               text="Cursor AI Editor Installer",
                               style="Title.TLabel")
        title_label.pack()

        subtitle_label = ttk.Label(header_frame,
                                  text="Automated installer for Ubuntu systems (versions < 24)",
                                  style="Subtitle.TLabel")
        subtitle_label.pack(pady=(5, 0))

        # AppImage Selection
        selection_frame = ttk.LabelFrame(main_frame, text="AppImage File", padding="15")
        selection_frame.grid(row=1, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 20))
        selection_frame.columnconfigure(1, weight=1)

        ttk.Label(selection_frame, text="Select Cursor AppImage:").grid(row=0, column=0, sticky=tk.W, pady=(0, 10))

        path_frame = ttk.Frame(selection_frame)
        path_frame.grid(row=1, column=0, columnspan=2, sticky=(tk.W, tk.E))
        path_frame.columnconfigure(0, weight=1)

        self.path_entry = ttk.Entry(path_frame, textvariable=self.appimage_path, state="readonly")
        self.path_entry.grid(row=0, column=0, sticky=(tk.W, tk.E), padx=(0, 10))

        browse_btn = ttk.Button(path_frame, text="Browse", command=self.browse_appimage, style="Secondary.TButton")
        browse_btn.grid(row=0, column=1)

        # Features
        features_frame = ttk.LabelFrame(main_frame, text="Features", padding="15")
        features_frame.grid(row=2, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 20))

        features_text = """• Automatic AppImage to DEB conversion
• Dependency management (libfuse2, appimage2deb)
• Clean installation (removes existing dpkg packages)
• Automatic cleanup of temporary files
• User-friendly interface with progress tracking"""

        features_label = ttk.Label(features_frame, text=features_text, justify=tk.LEFT)
        features_label.pack(anchor=tk.W)

        # Installation Controls
        controls_frame = ttk.Frame(main_frame)
        controls_frame.grid(row=3, column=0, columnspan=2, pady=(0, 20))

        self.install_btn = ttk.Button(controls_frame,
                                     text="Install Cursor",
                                     command=self.start_installation,
                                     style="Primary.TButton")
        self.install_btn.pack(side=tk.LEFT, padx=(0, 10))

        self.check_deps_btn = ttk.Button(controls_frame,
                                        text="Check Dependencies",
                                        command=self.check_dependencies,
                                        style="Secondary.TButton")
        self.check_deps_btn.pack(side=tk.LEFT)

        # Status
        status_frame = ttk.LabelFrame(main_frame, text="Status", padding="15")
        status_frame.grid(row=4, column=0, columnspan=2, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(0, 20))
        status_frame.columnconfigure(0, weight=1)
        status_frame.rowconfigure(1, weight=1)

        self.status_label = ttk.Label(status_frame, textvariable=self.install_status, style="Status.TLabel")
        self.status_label.grid(row=0, column=0, sticky=tk.W)

        # Progress bar
        self.progress = ttk.Progressbar(status_frame, mode='indeterminate')
        self.progress.grid(row=1, column=0, sticky=(tk.W, tk.E), pady=(10, 0))

        # Log output
        log_frame = ttk.LabelFrame(main_frame, text="Installation Log", padding="15")
        log_frame.grid(row=5, column=0, columnspan=2, sticky=(tk.W, tk.E, tk.N, tk.S))
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)

        self.log_text = scrolledtext.ScrolledText(log_frame, height=8, font=("Ubuntu Mono", 9))
        self.log_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))

        # Configure main frame weights
        main_frame.rowconfigure(5, weight=1)

    def center_window(self):
        """Center the window on screen"""
        self.root.update_idletasks()
        width = self.root.winfo_width()
        height = self.root.winfo_height()
        x = (self.root.winfo_screenwidth() // 2) - (width // 2)
        y = (self.root.winfo_screenheight() // 2) - (height // 2)
        self.root.geometry(f"{width}x{height}+{x}+{y}")

    def browse_appimage(self):
        """Open file dialog to select AppImage file"""
        file_path = filedialog.askopenfilename(
            title="Select Cursor AppImage",
            filetypes=[("AppImage files", "*.AppImage"), ("All files", "*.*")],
            initialdir=os.path.expanduser("~/Downloads")
        )

        if file_path:
            self.appimage_path.set(file_path)
            self.log_message(f"Selected AppImage: {file_path}")

    def log_message(self, message):
        """Add message to log output"""
        self.log_text.insert(tk.END, f"{message}\n")
        self.log_text.see(tk.END)
        self.root.update_idletasks()

    def check_dependencies(self):
        """Check if required dependencies are installed"""
        self.log_message("Checking dependencies...")
        self.missing_deps = []

        # Check libfuse2
        try:
            result = subprocess.run(["dpkg", "-l", "libfuse2"],
                                  capture_output=True, text=True, check=False)
            if result.returncode == 0 and "ii" in result.stdout and "libfuse2" in result.stdout:
                self.log_message("✓ libfuse2 is installed")
            else:
                self.log_message("✗ libfuse2 is not installed")
                self.missing_deps.append("libfuse2")
        except Exception as e:
            self.log_message(f"Error checking libfuse2: {e}")
            self.missing_deps.append("libfuse2")

        # Check snap
        try:
            result = subprocess.run(["which", "snap"],
                                  capture_output=True, text=True, check=False)
            if result.returncode == 0:
                self.log_message("✓ snap is available")
            else:
                self.log_message("✗ snap is not available")
                self.missing_deps.append("snapd")
        except Exception as e:
            self.log_message(f"Error checking snap: {e}")
            self.missing_deps.append("snapd")

        # Check appimage2deb
        try:
            result = subprocess.run(["which", "appimage2deb"],
                                  capture_output=True, text=True, check=False)
            if result.returncode == 0:
                self.log_message("✓ appimage2deb is installed")
            else:
                self.log_message("✗ appimage2deb is not installed")
                self.missing_deps.append("appimage2deb")
        except Exception as e:
            self.log_message(f"Error checking appimage2deb: {e}")
            self.missing_deps.append("appimage2deb")

        self.log_message("Dependency check completed.")

        # If missing dependencies, offer to install them
        if self.missing_deps:
            self.log_message(f"Missing dependencies: {', '.join(self.missing_deps)}")
            self.offer_install_dependencies()
        else:
            self.log_message("All dependencies are satisfied!")
            messagebox.showinfo("Dependencies", "All dependencies are present and ready!")

    def offer_install_dependencies(self):
        """Offer to install missing dependencies"""
        deps_text = ", ".join(self.missing_deps)
        response = messagebox.askyesno(
            "Install Dependencies",
            f"The following dependencies are missing:\n\n{deps_text}\n\nWould you like to install them now?\n\nThis will require sudo privileges."
        )

        if response:
            self.install_dependencies()

    def install_dependencies(self):
        """Install missing dependencies"""
        self.log_message("Installing missing dependencies...")
        self.check_deps_btn.config(state="disabled")
        self.progress.start()

        # Start installation in separate thread
        thread = threading.Thread(target=self.run_dependency_installation)
        thread.daemon = True
        thread.start()

    def run_dependency_installation(self):
        """Run the dependency installation process"""
        try:
            # Test sudo access first
            self.log_message("Testing sudo access...")
            result = subprocess.run(["sudo", "-n", "true"],
                                  capture_output=True, text=True, check=False)

            if result.returncode != 0:
                # Sudo password required
                self.log_message("Sudo password required. Please enter your password in the terminal.")
                self.root.after(0, lambda: messagebox.showwarning("Sudo Required",
                    "Sudo password is required to install dependencies.\n\n"
                    "Please enter your password in the terminal when prompted."))

                # Use sudo with password prompt
                sudo_cmd = ["sudo", "-S"]
            else:
                # Sudo access available
                sudo_cmd = ["sudo"]

            # Update package list
            self.log_message("Updating package list...")
            update_cmd = sudo_cmd + ["apt", "update"]
            result = subprocess.run(update_cmd,
                                  capture_output=True, text=True, input="\n" if sudo_cmd == ["sudo", "-S"] else None)
            if result.returncode != 0:
                raise Exception(f"Failed to update package list: {result.stderr}")

            # Install libfuse2 if missing
            if "libfuse2" in self.missing_deps:
                self.log_message("Installing libfuse2...")
                install_cmd = sudo_cmd + ["apt", "install", "libfuse2", "-y"]
                result = subprocess.run(install_cmd,
                                      capture_output=True, text=True, input="\n" if sudo_cmd == ["sudo", "-S"] else None)
                if result.returncode != 0:
                    raise Exception(f"Failed to install libfuse2: {result.stderr}")

            # Install snapd if missing
            if "snapd" in self.missing_deps:
                self.log_message("Installing snapd...")
                install_cmd = sudo_cmd + ["apt", "install", "snapd", "-y"]
                result = subprocess.run(install_cmd,
                                      capture_output=True, text=True, input="\n" if sudo_cmd == ["sudo", "-S"] else None)
                if result.returncode != 0:
                    raise Exception(f"Failed to install snapd: {result.stderr}")

            # Install appimage2deb if missing
            if "appimage2deb" in self.missing_deps:
                self.log_message("Installing appimage2deb...")
                install_cmd = sudo_cmd + ["snap", "install", "appimage2deb"]
                result = subprocess.run(install_cmd,
                                      capture_output=True, text=True, input="\n" if sudo_cmd == ["sudo", "-S"] else None)
                if result.returncode != 0:
                    raise Exception(f"Failed to install appimage2deb: {result.stderr}")

            self.log_message("✓ All dependencies installed successfully!")
            self.root.after(0, lambda: messagebox.showinfo("Success",
                "All dependencies have been installed successfully!"))

        except Exception as e:
            error_msg = f"Dependency installation failed: {str(e)}"
            self.log_message(f"✗ {error_msg}")
            self.root.after(0, lambda: messagebox.showerror("Error", error_msg))

        finally:
            # Reset UI
            self.root.after(0, self.reset_dependency_ui)

    def reset_dependency_ui(self):
        """Reset UI elements after dependency installation"""
        self.check_deps_btn.config(state="normal")
        self.progress.stop()
        self.missing_deps = []

    def start_installation(self):
        """Start the installation process in a separate thread"""
        if self.is_installing:
            return

        if not self.appimage_path.get():
            messagebox.showerror("Error", "Please select a Cursor AppImage file first.")
            return

        if not os.path.exists(self.appimage_path.get()):
            messagebox.showerror("Error", "Selected AppImage file does not exist.")
            return

        self.is_installing = True
        self.install_btn.config(state="disabled")
        self.check_deps_btn.config(state="disabled")
        self.progress.start()
        self.install_status.set("Installing...")

        # Start installation in separate thread
        thread = threading.Thread(target=self.run_installation)
        thread.daemon = True
        thread.start()

    def run_installation(self):
        """Run the actual installation process"""
        try:
            appimage_path = self.appimage_path.get()
            appimage_dir = os.path.dirname(appimage_path)
            appimage_file = os.path.basename(appimage_path)

            self.log_message("Starting Cursor installation...")

            # Change to AppImage directory
            os.chdir(appimage_dir)
            self.log_message(f"Changed to directory: {appimage_dir}")

            # Check and remove existing cursor packages
            self.log_message("Checking for existing Cursor packages...")
            result = subprocess.run(["dpkg", "-l"], capture_output=True, text=True)
            if "cursor-" in result.stdout:
                self.log_message("Removing existing Cursor packages...")
                subprocess.run(["sudo", "apt", "remove", "cursor-*-*-*-x86-64", "-y"],
                             capture_output=True)

            # Install appimage2deb if not available
            self.log_message("Checking appimage2deb...")
            result = subprocess.run(["which", "appimage2deb"], capture_output=True, text=True)
            if result.returncode != 0:
                self.log_message("Installing appimage2deb...")
                subprocess.run(["sudo", "snap", "install", "appimage2deb"],
                             capture_output=True)

            # Install libfuse2 if not available
            self.log_message("Checking libfuse2...")
            result = subprocess.run(["dpkg", "-l", "libfuse2"], capture_output=True, text=True)
            if "libfuse2" not in result.stdout:
                self.log_message("Installing libfuse2...")
                subprocess.run(["sudo", "apt", "update"], capture_output=True)
                subprocess.run(["sudo", "apt", "install", "libfuse2", "-y"],
                             capture_output=True)

            # Convert AppImage to DEB
            self.log_message("Converting AppImage to DEB package...")
            result = subprocess.run(["appimage2deb", appimage_file],
                                  capture_output=True, text=True)

            if result.returncode != 0:
                self.log_message(f"appimage2deb stderr: {result.stderr}")
                self.log_message(f"appimage2deb stdout: {result.stdout}")
                raise Exception(f"Failed to convert AppImage: {result.stderr}")

            # List all files in directory to debug
            self.log_message("Files in directory after conversion:")
            for file in os.listdir("."):
                self.log_message(f"  - {file}")

            # Find and install the DEB file with improved pattern matching
            deb_files = []
            for file in os.listdir("."):
                if file.endswith(".deb"):
                    # Check if it's a cursor-related package
                    if any(keyword in file.lower() for keyword in ["cursor", "cursor-ai", "cursor-editor"]):
                        deb_files.append(file)
                        self.log_message(f"Found DEB file: {file}")

            # If no cursor-specific DEB found, look for any DEB file
            if not deb_files:
                deb_files = [f for f in os.listdir(".") if f.endswith(".deb")]
                self.log_message(f"Found {len(deb_files)} DEB file(s): {deb_files}")

            if not deb_files:
                # List all files again for debugging
                self.log_message("No DEB files found. All files in directory:")
                for file in sorted(os.listdir(".")):
                    self.log_message(f"  - {file}")
                raise Exception("No DEB file found after conversion. Check the log for details.")

            deb_file = deb_files[0]
            self.log_message(f"Installing {deb_file}...")
            result = subprocess.run(["sudo", "dpkg", "-i", deb_file],
                                  capture_output=True, text=True)

            if result.returncode != 0:
                self.log_message(f"dpkg stderr: {result.stderr}")
                self.log_message(f"dpkg stdout: {result.stdout}")
                raise Exception(f"Failed to install DEB: {result.stderr}")

            # Cleanup
            self.log_message("Cleaning up temporary files...")
            try:
                os.remove(appimage_file)
                self.log_message(f"Removed AppImage: {appimage_file}")
            except Exception as e:
                self.log_message(f"Warning: Could not remove AppImage: {e}")

            try:
                os.remove(deb_file)
                self.log_message(f"Removed DEB: {deb_file}")
            except Exception as e:
                self.log_message(f"Warning: Could not remove DEB: {e}")

            self.log_message("✓ Cursor installation completed successfully!")
            self.install_status.set("Installation completed successfully!")

            # Show success message
            self.root.after(0, lambda: messagebox.showinfo("Success",
                "Cursor AI Editor has been installed successfully!\n\n"
                "You can now launch Cursor from the Applications menu or by running 'cursor' in the terminal."))

        except Exception as e:
            error_msg = f"Installation failed: {str(e)}"
            self.log_message(f"✗ {error_msg}")
            self.install_status.set("Installation failed")
            self.root.after(0, lambda: messagebox.showerror("Error", error_msg))

        finally:
            # Reset UI
            self.root.after(0, self.reset_ui)

    def reset_ui(self):
        """Reset UI elements after installation"""
        self.is_installing = False
        self.install_btn.config(state="normal")
        self.check_deps_btn.config(state="normal")
        self.progress.stop()

    def on_closing(self):
        """Handle window closing"""
        if self.is_installing:
            if messagebox.askokcancel("Quit", "Installation is in progress. Are you sure you want to quit?"):
                self.root.destroy()
        else:
            self.root.destroy()

def main():
    """Main function"""
    root = tk.Tk()
    app = CursorInstallerGUI(root)

    # Handle window closing
    root.protocol("WM_DELETE_WINDOW", app.on_closing)

    # Start the GUI
    root.mainloop()

if __name__ == "__main__":
    main()
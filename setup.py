#!/usr/bin/env python3
"""
Setup script for Cursor Installer GUI
"""

from setuptools import setup, find_packages
import os

# Read the README file
def read_readme():
    with open("README.md", "r", encoding="utf-8") as fh:
        return fh.read()

setup(
    name="cursor-installer-gui",
    version="1.0.0",
    author="Your Name",
    author_email="your.email@example.com",
    description="Graphical installer for Cursor AI Editor on Ubuntu",
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/cursor-installer",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: POSIX :: Linux",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Software Development :: Tools",
        "Topic :: System :: Installation/Setup",
    ],
    python_requires=">=3.8",
    install_requires=[
        "tkinter",  # Usually comes with Python
    ],
    entry_points={
        "console_scripts": [
            "cursor-installer-gui=cursor_installer_gui:main",
        ],
    },
    include_package_data=True,
    zip_safe=False,
)
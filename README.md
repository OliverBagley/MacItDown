# MacItDown

A beautiful, modern macOS app for converting documents to Markdown using Microsoft's MarkItDown. Built with SwiftUI following Apple's Liquid Glass design principles.

![MacItDown](https://img.shields.io/badge/macOS-15+-blue)
![Swift](https://img.shields.io/badge/Swift-6.0+-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- **Drag & Drop Interface** - Simply drag files onto the app window
- **File Picker** - Click "Open" to browse and select files
- **Live Preview** - Toggle between rendered Markdown and source code
- **Theme Support** - System, Light, and Dark mode with smooth transitions
- **Copy & Save** - Copy converted Markdown to clipboard or save to file
- **Modern UI** - Following macOS 15 design guidelines with Liquid Glass aesthetics
- **Bundled Python** - No external Python installation required

## 📋 Supported Formats

- **PDF** documents
- **Microsoft Office** (Word, Excel, PowerPoint)
- **OpenOffice/LibreOffice** documents
- **HTML** pages
- **JSON** files
- **CSV** spreadsheets
- **RTF** documents
- **Plain text** files
- And more...

## 🚀 Requirements

- **macOS 15.0+**
- **Swift 6.0+**
- **Xcode 16+**

## 🛠️ Building

### Prerequisites

1. **Install MarkItDown Python package:**
   ```bash
   pip3 install markitdown
   ```

2. **Create Python virtual environment:**
   ```bash
   python3 -m venv python-env
   source python-env/bin/activate
   pip install markitdown
   ```

### Build the App

```bash
# Clone or navigate to the project directory
cd MacItDown

# Build the Swift package
./build.sh

# Or build manually
swift build -c release
```

The built app will be available at `dist/MacItDownApp.app`.

## 📖 Usage

1. **Launch** the MacItDown app
2. **Drop a file** onto the drop zone, or click **"Open"** to select a file
3. **Wait** for conversion to complete
4. **Preview** the rendered Markdown or switch to **"Source"** view
5. **Copy** the Markdown to clipboard or **Save** it to a file
6. **Start over** with the **"New"** button

### Keyboard Shortcuts

- `⌘O` - Open file picker
- `⌘C` - Copy Markdown
- `⌘S` - Save Markdown
- `⌘N` - New document

## 🎨 Design

MacItDown follows Apple's Liquid Glass design language with:

- **Continuous corner radius** (28pt) for modern aesthetics
- **Ultra-thin materials** for depth and hierarchy
- **Spring animations** (0.35s duration, 0.1 bounce) for smooth interactions
- **Symbol effects** and micro-interactions
- **Adaptive layouts** that scale beautifully
- **Accessibility-first** color schemes and contrast

## 🏗️ Architecture

- **SwiftUI** for declarative UI
- **AppKit integration** for native macOS features
- **Bundled Python environment** for MarkItDown
- **Async/await** for smooth file processing
- **@AppStorage** for theme persistence
- **Uniform Type Identifiers** for file type detection

## 📄 License

This project is licensed under the MIT License. Based on [Microsoft's MarkItDown](https://github.com/microsoft/markitdown) © Microsoft Corporation.

## 🤝 Contributing

Contributions welcome! Please ensure code follows Swift 6.0 best practices and maintains the Liquid Glass design aesthetic.

## 📧 Contact

[oliverbagley.com](https://www.oliverbagley.com) · 2026

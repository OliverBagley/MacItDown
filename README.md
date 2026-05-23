<div align="center">
  <img src=".github/images/MacItDown_icon.avif" alt="MacItDown" width="128">
  
  # MacItDown
  
  **A beautiful, modern macOS app for converting documents to Markdown**
  
  Built with SwiftUI following Apple's Liquid Glass design principles. Powered by [Microsoft's MarkItDown](https://github.com/microsoft/markitdown).
  
  ![macOS](https://img.shields.io/badge/macOS-15+-blue?style=flat-square)
  ![Swift](https://img.shields.io/badge/Swift-6.0+-orange?style=flat-square)
  ![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
  ![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=flat-square)
</div>

## 📸 Screenshot

<div align="center">
  <img src=".github/images/screenshot-main.avif" alt="MacItDown App Screenshot" width="600">
</div>

## ✨ Features

- **🎯 Drag & Drop Interface** - Simply drag files onto the app window
- **📁 File Picker** - Click "Open" to browse and select files  
- **👁️ Live Preview** - Toggle between rendered Markdown and source code
- **🎨 Theme Support** - System, Light, and Dark mode with smooth transitions
- **📋 Copy & Save** - Copy converted Markdown to clipboard or save to file
- **✨ Modern UI** - Following macOS 15 design guidelines with Liquid Glass aesthetics
- **🐍 Bundled Python** - No external Python installation required

## � Supported Formats

| Format | Support |
|--------|---------|
| **PDF** | ✅ |
| **Microsoft Office** (Word, Excel, PowerPoint) | ✅ |
| **OpenOffice/LibreOffice** | ✅ |
| **HTML** | ✅ |
| **JSON** | ✅ |
| **CSV** | ✅ |
| **RTF** | ✅ |
| **Plain Text** | ✅ |
| And more... | ✅ |


## 🚀 Quick Start

### Prerequisites

- **macOS 15.0+**
- **Swift 6.0+**
- **Xcode 16+**

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/MacItDown.git
   cd MacItDown
   ```

2. **Install dependencies:**
   ```bash
   python3 -m venv python-env
   source python-env/bin/activate
   pip install markitdown
   ```

3. **Build the app:**
   ```bash
   ./build.sh
   ```
   
   Or manually:
   ```bash
   swift build -c release
   ```

The built app will be available at `dist/MacItDownApp.app`.

## 📖 Usage Guide

### Basic Workflow

1. **Launch** the MacItDown app
2. **Drop a file** onto the drop zone, or click **"Open"** to select a file
3. **Wait** for conversion to complete
4. **Preview** the rendered Markdown or switch to **"Source"** view
5. **Copy** to clipboard or **Save** to file
6. **Start over** with the **"New"** button

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `⌘O` | Open file picker |
| `⌘C` | Copy Markdown |
| `⌘S` | Save Markdown |
| `⌘N` | New document |


## 🎨 Design Philosophy

MacItDown embodies Apple's Liquid Glass design language with meticulous attention to detail:

- **Continuous corner radius** (28pt) for modern, approachable aesthetics
- **Ultra-thin materials** with depth and visual hierarchy
- **Spring animations** (0.35s duration, 0.1 bounce) for delightful interactions
- **Symbol effects** and micro-interactions for visual feedback
- **Adaptive layouts** that scale beautifully across display sizes
- **Accessibility-first** color schemes with excellent contrast ratios
- **Haptic feedback** for tactile confirmation


## 🏗️ Architecture

```
MacItDown/
├── Sources/
│   ├── MacItDown/          # Main app target
│   │   ├── App.swift       # App entry point & config
│   │   ├── ContentView.swift # Main UI container
│   │   ├── DropView.swift  # Drag & drop handler
│   │   ├── FileConverter.swift # Document conversion logic
│   │   ├── MarkdownView.swift # Markdown preview & editor
│   │   └── ThemeManager.swift # Theme system
│   └── MarkItDownApp/      # Legacy app target
├── Resources/
│   └── AppIcon.appiconset/ # App icons (all sizes)
└── .github/images/         # GitHub docs & screenshots
```

### Key Technologies

- **SwiftUI** for declarative, reactive UI
- **AppKit integration** for native macOS features
- **Bundled Python environment** for MarkItDown conversion
- **Async/await** for non-blocking file processing
- **@AppStorage** for persistent theme preferences
- **Uniform Type Identifiers** for robust file type detection


## � Troubleshooting

### Common Issues

**"Python not found" error**
- Ensure `python3` is installed: `which python3`
- Run: `source python-env/bin/activate`

**Build fails with Swift version error**
- Update Xcode: `xcode-select --install`
- Check version: `swift --version` (should be 6.0+)

**App won't launch after build**
- Clear build cache: `rm -rf .build`
- Rebuild: `./build.sh`

**Conversion is slow**
- Large files (100MB+) may take time depending on format
- PDF files with many images take longer to process

## ✅ Requirements Met

- [x] SwiftUI modern UI framework
- [x] Liquid Glass design aesthetic
- [x] Bundled Python environment
- [x] Multi-format document support
- [x] macOS 15+ support
- [x] Accessibility standards

## 📚 Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [Swift Best Practices](https://www.swift.org/documentation/)
- [MarkItDown Documentation](https://github.com/microsoft/markitdown)

## 📄 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) file for details.

Built on [Microsoft's MarkItDown](https://github.com/microsoft/markitdown) © Microsoft Corporation.

---

<div align="center">
  Made with ❤️ in Swift
  <br>
  © 2026 Oliver Bagley.
</div>


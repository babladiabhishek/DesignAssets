# DesignAssets

A Swift Package for managing design assets from Figma using the `figma-export` tool.

## Features

- 🎨 Export icons directly from Figma
- 📱 iOS-optimized asset generation
- 🔧 SPM Command Plugin for easy integration
- 🚀 No external dependencies required for developers

## Setup

1. **Install figma-export** (if not already installed):
   ```bash
   brew tap redmadrobot/formulae
   brew install figma-export
   ```

2. **Set your Figma token**:
   ```bash
   export FIGMA_PERSONAL_TOKEN=your_figma_token_here
   ```

3. **Export icons**:
   ```bash
   swift package fetch-icons
   ```

## Usage

### In SwiftUI
```swift
import DesignAssets

// Using predefined icon names
Image(DesignAssets.IconName.placeholder.rawValue)

// Or directly
DesignAssets.icon(named: "ic_24_home")
```

### In UIKit
```swift
import DesignAssets

let imageView = UIImageView(image: DesignAssets.uiImage(named: "ic_24_home"))
```

## Configuration

Edit `Tools/figma-export.yaml` to configure:
- Figma file ID
- Icon naming patterns
- Export settings
- Frame names

## Requirements

- iOS 14.0+
- Xcode 14.0+
- Swift 5.9+

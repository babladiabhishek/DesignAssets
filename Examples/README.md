# 🎨 Organized Icons Demo

This demo showcases the organized icon categories in the DesignAssets package.

## 🚀 Quick Start

### Option 1: Run with Script (Recommended)
```bash
cd Examples
./run-demo.sh
```

### Option 2: Run with Swift Package Manager
```bash
cd Examples
swift run OrganizedIconsDemo
```

### Option 3: Open in Xcode
```bash
cd Examples
open OrganizedIconsDemo.xcodeproj
```

## 📱 Demo Features

### 1. **All Icons View**
- Shows all icons organized by category
- Status Icons (25 icons)
- Map Icons (20 icons) 
- Feel Good Icons (15 icons)
- General Icons (sample of 20 icons)

### 2. **Category Picker**
- Interactive category selection
- Grid view of icons in each category
- Tap to select icons
- Shows selected icon information

### 3. **Usage Examples**
- Real-world usage examples
- Color-coded by category
- Shows icon names and descriptions
- Demonstrates proper usage patterns

## 🎯 What You'll See

The demo app has three main tabs:

1. **All Icons** - Browse all available icons by category
2. **Categories** - Interactive picker to explore specific categories
3. **Examples** - See how to use icons in your app

## 🔧 Technical Details

- **Platform**: iOS 15+, macOS 12+
- **Framework**: SwiftUI
- **Dependencies**: DesignAssets package
- **Architecture**: Tab-based navigation with category organization

## 📦 Icon Categories

### Status Icons (25 icons)
- `ic_status_success_16`, `ic_status_alert_20`, etc.
- Sizes: 12x12, 16x16, 20x20
- Colors: Blue theme

### Map Icons (20 icons)
- `map_pin_single_default`, `ic_order_delivery_32`, etc.
- Order location and delivery icons
- Colors: Green theme

### Feel Good Icons (15 icons)
- `ic_light_bulb_default_32`, `ic_search_filled_32`, etc.
- Filled and outline variants
- Colors: Orange theme

### General Icons (378 icons)
- `ic_hamburger_default_32`, `ic_trash_filled_32`, etc.
- General purpose icons
- Colors: Purple theme

## 🎨 Usage in Your App

```swift
import DesignAssets
import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            // Status icons
            GeneratedIcons.Status.ic_status_success_16.image
                .foregroundColor(.green)
            
            // Map icons
            GeneratedIcons.Map.map_pin_single_default.image
                .foregroundColor(.red)
            
            // Feel Good icons
            GeneratedIcons.FeelGood.ic_light_bulb_default_32.image
                .foregroundColor(.yellow)
            
            // General icons
            GeneratedIcons.General.ic_hamburger_default_32.image
                .foregroundColor(.gray)
        }
    }
}
```

## 🐛 Troubleshooting

### Build Errors
- Make sure you're in the Examples directory
- Ensure DesignAssets package is built: `cd .. && swift build`
- Check Swift version: `swift --version` (requires 5.9+)

### Runtime Issues
- Icons not showing? Check that the DesignAssets package is properly linked
- App crashes? Check console for error messages
- Performance issues? The demo limits General icons to 20 for performance

## 📝 Notes

- This demo uses placeholder circles instead of actual icons for performance
- In a real app, you'd use `GeneratedIcons.Status.ic_status_success_16.image`
- The demo shows the structure and organization of the icon system
- All icons are type-safe and autocompleted in Xcode

# DesignAssets

A **supercharged Swift Package** with comprehensive Figma integration that can dynamically fetch and organize ALL icons from any Figma file. Perfect for iOS and macOS applications requiring professional iconography and seamless design system integration.

## ✨ Features

- 🚀 **Supercharged Figma Integration** - Automatically fetch ALL icons from any Figma file
- 📱 **Smart Organization** - Automatic categorization and variant detection
- ⚡ **Generated Swift Code** - Type-safe icon access with organized enums
- 📦 **Xcode Asset Catalogs** - Proper iOS/macOS integration
- 🎨 **Variant Support** - Handles filled, outline, light, and dark variants
- 📊 **Detailed Reporting** - Comprehensive summaries of fetched icons
- 🛠️ **Zero Dependencies** - Pure Swift Package Manager integration
- 🔄 **Dynamic Updates** - Always stay in sync with your design system

## 🚀 Quick Start

### Option 1: Fetch Icons from Your Figma File

1. **Get your Figma token** from [Figma Settings](https://www.figma.com/settings)
2. **Extract file ID** from your Figma URL
3. **Run the plugin**:

```bash
# Using command line
swift package plugin fetch-icons --token YOUR_TOKEN --file-id YOUR_FILE_ID

# Using environment variables
export FIGMA_PERSONAL_TOKEN="your_token"
export FIGMA_FILE_ID="your_file_id"
swift package plugin fetch-icons
```

### Option 2: Add to Your Project

**Via Xcode:**
1. File → Add Package Dependencies
2. Enter repository URL: `https://github.com/babladiabhishek/DesignAssets`
3. Select version and add to target

**Via Package.swift:**
```swift
dependencies: [
    .package(url: "https://github.com/babladiabhishek/DesignAssets", from: "1.0.0")
]
```

### Import and Use

```swift
import DesignAssets
```

## 💻 Usage Examples

### SwiftUI

```swift
import SwiftUI
import DesignAssets

struct MyView: View {
    var body: some View {
        VStack {
            // Using generated icons from Figma
            GeneratedIcons.General.home_icon.image
            GeneratedIcons.Map.location_pin.image
            GeneratedIcons.Status.success_icon.image
            
            // Using the master enum
            GeneratedIcons.All.home_icon.image
            
            // Dynamic loading
            ForEach(GeneratedIcons.General.allCases, id: \.self) { icon in
                icon.image
            }
        }
    }
}
```

### UIKit

```swift
import UIKit
import DesignAssets

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Using generated icons
        if let image = GeneratedIcons.General.home_icon.uiImage as? UIImage {
            let imageView = UIImageView(image: image)
            view.addSubview(imageView)
        }
    }
}
```

## 🎨 Figma Integration

### Supercharged Icon Fetching

The DesignAssets package includes a powerful plugin that can automatically fetch **ALL** icons from any Figma file:

```bash
# Fetch all icons from your Figma file
swift package plugin fetch-icons --token YOUR_TOKEN --file-id YOUR_FILE_ID
```

### What It Does

- 🔍 **Discovers all icon components** and instances in your Figma file
- 📂 **Organizes icons by categories** (General, Map, Status, Navigation, Social)
- 🎨 **Detects variants** (filled, outline, light, dark)
- 📦 **Generates Xcode asset catalogs** with proper Contents.json files
- ⚡ **Creates Swift code** with organized enums for type-safe access
- 📊 **Provides detailed reports** of all fetched icons

### Generated Code Structure

```swift
// Automatically generated from your Figma file
public struct GeneratedIcons {
    enum General: String, CaseIterable {
        case home_icon = "home_icon"
        case search_icon = "search_icon"
        // ... more icons
    }
    
    enum Map: String, CaseIterable {
        case location_pin = "location_pin"
        // ... more icons
    }
    
    enum All: String, CaseIterable {
        // All icons in one enum
        case home_icon = "home_icon"
        case location_pin = "location_pin"
        // ... all icons
        
        public var category: String {
            // Returns the category for each icon
        }
    }
}
```

For detailed documentation, see [FIGMA_INTEGRATION.md](FIGMA_INTEGRATION.md).

## 📋 Command Line Options

```bash
swift package plugin fetch-icons [options]

Options:
  --token <token>        Figma personal access token
  --file-id <file-id>    Figma file ID to fetch icons from
  --no-variants          Skip variant processing (filled/outline)
  --no-asset-catalog     Skip Xcode asset catalog generation
  --no-swift-code        Skip Swift code generation
  --help, -h             Show help message

Environment Variables:
  FIGMA_PERSONAL_TOKEN   Figma personal access token
  FIGMA_FILE_ID          Figma file ID
```

## 📦 Package Structure

```
DesignAssets/
├── Sources/
│   └── DesignAssets/
│       ├── DesignAssets.swift          # Main API
│       ├── FigmaClient.swift           # Enhanced Figma integration
│       └── Resources/
│           ├── Icons.xcassets/         # Generated asset catalog
│           ├── GeneratedIcons.swift    # Auto-generated from Figma
│           └── icon-summary.md         # Generated summary report
├── Plugins/
│   └── FetchIconsPlugin/
│       └── Plugin.swift                # Supercharged Figma plugin
├── Examples/
│   └── FigmaIntegrationExample.swift   # Figma integration examples
├── Package.swift                       # SPM configuration
├── test-figma-integration.sh           # Test script
├── test-real-figma.sh                  # Real integration test
├── FIGMA_INTEGRATION.md                # Detailed Figma docs
└── README.md                          # This file
```

## 🔧 Technical Details

- **Format**: PNG (high-resolution, 2x scale)
- **File Sizes**: Optimized for mobile
- **Scalability**: Perfect at any resolution
- **iOS Support**: iOS 15.0+
- **macOS Support**: macOS 12.0+
- **Swift Version**: 5.9+

## 🎯 Benefits

- **Dynamic Icon Management**: Always stay in sync with your design system
- **Type-Safe Access**: Generated Swift enums for all icons
- **Smart Organization**: Automatic categorization and variant detection
- **Easy Integration**: Simple API with comprehensive documentation
- **Future-Proof**: Easy to update and maintain
- **Design System Ready**: Perfect for large-scale applications

## 🚨 Troubleshooting

### Common Issues

1. **"FIGMA_PERSONAL_TOKEN not set"**
   - Make sure you've set the token in environment variables or passed it via `--token`

2. **"Failed to fetch Figma file"**
   - Check that your token has access to the file
   - Verify the file ID is correct
   - Ensure the file is not private or requires special permissions

3. **"No icons found"**
   - Check that your Figma file contains components or instances with icon-like names
   - Try using more generic naming patterns like `icon_*` or `ic_*`

## 📄 License

This package is available under the MIT license. See the LICENSE file for more info.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions, please open an issue on GitHub.

---

**Made with ❤️ for the iOS community**
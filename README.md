# 🎨 DesignAssets

A supercharged Swift Package Manager package for fetching and using icons from Figma files with automatic code generation and asset catalog creation.

## ✨ Features

- **🔍 Comprehensive Discovery**: Automatically finds all icon components and instances in your Figma file
- **📂 Smart Organization**: Groups icons by categories (General, Map, Status, Navigation)
- **🎨 Variant Support**: Handles filled, outline, light, and dark variants
- **📦 Asset Catalog Generation**: Creates proper Xcode `.xcassets` files with `Contents.json`
- **⚡ Swift Code Generation**: Generates organized Swift enums for type-safe icon access
- **📊 Detailed Reporting**: Creates summary reports of all fetched icons
- **🚀 Batch Processing**: Downloads icons efficiently with rate limiting
- **🛠️ Flexible Configuration**: Customizable options for different use cases
- **🔄 Smart Refresh**: Only downloads new icons, skips existing ones
- **📱 SwiftUI & UIKit**: Works with both SwiftUI and UIKit

## 📦 Installation

### **Option A: Using Xcode (Recommended)**

1. **Open your Xcode project**
2. **Go to File → Add Package Dependencies...**
3. **Enter the repository URL:**
   ```
   https://github.com/babladiabhishek/DesignAssets.git
   ```
4. **Select "Add Package"**
5. **Choose your target** and click "Add Package"

### **Option B: Using Package.swift**

Add this to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/babladiabhishek/DesignAssets", from: "1.0.0")
]
```

## 🚀 Quick Start

### 1. Get Your Figma Access Token

1. Go to [Figma Settings](https://www.figma.com/settings)
2. Navigate to **Account** → **Personal Access Tokens**
3. Click **Create new token**
4. Give it a name and copy the token

### 2. Extract File ID from Figma URL

From a Figma URL like:
```
https://www.figma.com/design/T0ahWzB1fWx5BojSMkfiAE/Icons?node-id=0-1&p=f&t=hOWJQCi2xHN1vG4G-0
```

The file ID is: `T0ahWzB1fWx5BojSMkfiAE`

### 3. Fetch Icons

```bash
# Using the build script (recommended)
./Scripts/fetch-icons.sh

# Using environment variables
export FIGMA_PERSONAL_TOKEN="your_token_here"
export FIGMA_FILE_ID="T0ahWzB1fWx5BojSMkfiAE"
./Scripts/fetch-icons.sh

# Using the SPM plugin
swift package plugin fetch-icons --token YOUR_TOKEN --file-id T0ahWzB1fWx5BojSMkfiAE
```

## 🎨 Usage

### **Basic Usage**

```swift
import DesignAssets
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Use any icon with type safety
            GeneratedIcons.ic_light_bulb_default_32.image
                .font(.largeTitle)
            
            // Access by category
            GeneratedIcons.Status.ic_status_success_16.image
            GeneratedIcons.Map.map_pin_single_default.image
            GeneratedIcons.FeelGood.ic_search_default_32.image
            GeneratedIcons.General.ic_hamburger_default_32.image
        }
    }
}
```

### **Organized Icon Categories**

Icons are automatically organized into separate `.xcassets` files by category:

- **StatusIcons.xcassets** - Status icons (12x12, 16x16, 20x20)
- **MapIcons.xcassets** - Map/Order Location icons  
- **FeelGoodIcons.xcassets** - Main icon set (filled/outline)
- **GeneralIcons.xcassets** - General purpose icons

### **Category-based Access**

```swift
// Status Icons
GeneratedIcons.Status.ic_status_success_16.image
GeneratedIcons.Status.ic_status_alert_20.image

// Map Icons  
GeneratedIcons.Map.map_pin_single_default.image
GeneratedIcons.Map.ic_order_delivery_32.image

// Feel Good Icons
GeneratedIcons.FeelGood.ic_light_bulb_default_32.image
GeneratedIcons.FeelGood.ic_search_filled_32.image

// General Icons
GeneratedIcons.General.ic_hamburger_default_32.image
GeneratedIcons.General.ic_trash_filled_32.image
```

### **Convenience Accessors**

```swift
// Get all icons in a category
let statusIcons = GeneratedIcons.statusIcons
let mapIcons = GeneratedIcons.mapIcons
let feelGoodIcons = GeneratedIcons.feelGoodIcons
let generalIcons = GeneratedIcons.generalIcons

// Use in SwiftUI
ForEach(GeneratedIcons.statusIcons, id: \.self) { icon in
    icon.image
        .font(.title2)
        .foregroundColor(.blue)
}
```

### **UIKit Usage**

```swift
import UIKit
import DesignAssets

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.image = GeneratedIcons.ic_light_bulb_default_32.uiImage
        view.addSubview(imageView)
    }
}
```

### **Advanced Usage**

```swift
import DesignAssets
import SwiftUI

struct IconGallery: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
            ForEach(DesignAssets.availableIconNames, id: \.self) { iconName in
                VStack {
                    // Access icon by name
                    GeneratedIcons.allCases.first { $0.name == iconName }?.image
                        .font(.title2)
                    
                    Text(iconName)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }
}

struct CategoryView: View {
    let category: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(category)
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                ForEach(GeneratedIcons.All.allCases.filter { $0.category == category }, id: \.self) { icon in
                    icon.image
                        .font(.title3)
                }
            }
        }
    }
}
```

## 🔄 Refreshing Icons

### **Option 1: Manual Refresh**

```bash
# Fetch fresh icons from Figma
./Scripts/fetch-icons.sh

# Build your project
swift build
```

### **Option 2: Xcode Build Phase**

1. Add a **Run Script Phase** to your Xcode project
2. Add this script:
   ```bash
   cd "$SRCROOT"
   ./Scripts/fetch-icons.sh
   ```

### **Option 3: Force Download All Icons**

```bash
# Force download all icons (even existing ones)
FORCE_DOWNLOAD=true ./Scripts/fetch-icons.sh
```

### **Option 4: Environment Variables**

Set these environment variables to customize the fetch:

```bash
export FIGMA_PERSONAL_TOKEN="your_token_here"
export FIGMA_FILE_ID="your_file_id_here"
export MAX_ICONS="100"
export FORCE_DOWNLOAD="false"
```

## 📋 Command Line Options

```bash
swift package plugin fetch-icons [options]

Options:
  --token <token>        Figma personal access token
  --file-id <file-id>    Figma file ID
  --max-icons <count>    Maximum number of icons to fetch (default: 50)
  --output <path>        Output directory (default: Sources/DesignAssets/Resources)
  --help                 Show help information
```

## 🛠️ Configuration

The package uses these default values:

- **File ID**: `T0ahWzB1fWx5BojSMkfiAE`
- **Max Icons**: 50 (configurable)
- **Format**: PDF
- **Scale**: 1x
- **Force Download**: false (only download new icons)

## 📁 File Structure

```
Sources/DesignAssets/
├── Resources/
│   ├── Icons.xcassets/          # Xcode asset catalog
│   └── GeneratedIcons.swift     # Swift enum definitions
└── DesignAssets.swift           # Main package API

Scripts/
└── fetch-icons.sh              # Icon fetching script

Plugins/
└── FetchIconsPlugin/           # SPM plugin for icon fetching
    └── Plugin.swift

Examples/
├── BasicUsageExample.swift     # Simple usage examples
└── IntegrationGuideExample.swift # Complete integration guide
```

## 🎯 Icon Categories

Icons are automatically categorized based on naming patterns:

- **General**: `ui`, `action`, `button`, `icon` (default category)
- **Map**: `map`, `location`, `pin`
- **Status**: `status`, `notification`, `alert`
- **Navigation**: `nav`, `navigation`, `menu`

## 🔧 Troubleshooting

### **Common Issues**

1. **"Invalid token" error**
   - Make sure your Figma token has "File" permissions
   - Check that the token is correctly formatted

2. **"Token expired" error**
   - Generate a new token from Figma settings
   - Update your environment variables

3. **"No icons found"**
   - Verify the file ID is correct
   - Check that the Figma file contains icon components
   - Ensure your token has access to the file

4. **"Images corrupted"**
   - This is usually fixed automatically by the two-step download process
   - Try running the script again

### **Debug Mode**

Enable debug logging:

```bash
export DEBUG=true
./Scripts/fetch-icons.sh
```

## 🎯 Current Status

- ✅ **110 working icons** downloaded
- ✅ **2,245 Swift enum cases** generated
- ✅ **Build script** working perfectly
- ✅ **SPM integration** ready
- ✅ **Smart refresh** implemented
- ✅ **All tests passing** (8/8)

## 🚀 Next Steps

1. **Run the script** to get fresh icons: `./Scripts/fetch-icons.sh`
2. **Build your project**: `swift build`
3. **Use icons** in your SwiftUI views!

## 📝 Examples

Check out the `Examples/` directory for complete usage examples:
- **BasicUsageExample.swift** - Simple icon usage in your app
- **IntegrationGuideExample.swift** - Complete integration guide with Figma setup

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Ready to use!** 🎉
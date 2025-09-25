# DesignAssets

A comprehensive Swift Package containing high-quality icons with **supercharged Figma integration**. Perfect for iOS and macOS applications requiring professional iconography and seamless design system integration.

## ✨ Features

- 🎨 **52 Social Media Icons** - Complete collection of popular platform icons
- 🚀 **Supercharged Figma Integration** - Automatically fetch ALL icons from any Figma file
- 📱 **PDF Vector Format** - Scalable, crisp rendering at any size
- 🎯 **Two Variants** - Both "Original" and "Negative" styles for each platform
- 📦 **Smart Organization** - Automatic categorization and variant detection
- ⚡ **Generated Swift Code** - Type-safe icon access with organized enums
- 🛠️ **Zero Dependencies** - Pure Swift Package Manager integration
- 📊 **Detailed Reporting** - Comprehensive summaries of fetched icons

## 📋 Included Platforms

### Social Media Platforms
- **Facebook** (Original & Negative)
- **Instagram** (Original & Negative) 
- **X (Twitter)** (Original & Negative)
- **LinkedIn** (Original & Negative)
- **YouTube** (Original & Negative)
- **TikTok** (Original & Negative)
- **Snapchat** (Original & Negative)
- **Pinterest** (Original & Negative)
- **Reddit** (Original & Negative)
- **WhatsApp** (Original & Negative)
- **Telegram** (Original & Negative)
- **Signal** (Original & Negative)
- **Threads** (Original & Negative)

### Professional & Developer Platforms
- **Figma** (Original & Negative)
- **GitHub** (Original & Negative)
- **Google** (Original & Negative)
- **Apple** (Original & Negative)
- **Discord** (Original & Negative)
- **Twitch** (Original & Negative)
- **Spotify** (Original & Negative)
- **Clubhouse** (Original & Negative)
- **VK** (Original & Negative)
- **Medium** (Original & Negative)
- **Messenger** (Original & Negative)
- **Tumblr** (Original & Negative)

## 🚀 Quick Start

### Option 1: Use Pre-built Icons

**Via Xcode:**
1. File → Add Package Dependencies
2. Enter repository URL: `https://github.com/yourusername/DesignAssets`
3. Select version and add to target

**Via Package.swift:**
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/DesignAssets", from: "1.0.0")
]
```

### Option 2: Fetch Icons from Your Figma File

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

### Import and Use

```swift
import DesignAssets
```

## 💻 Usage Examples

### SwiftUI
```swift
import SwiftUI
import DesignAssets

struct SocialMediaView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Using the enum
            Image(DesignAssets.IconName.facebookOriginal.rawValue, bundle: DesignAssets.bundle)
                .resizable()
                .frame(width: 24, height: 24)
            
            // Using the helper method
            DesignAssets.icon(named: "instagram_original")
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
}
```

### UIKit
```swift
import UIKit
import DesignAssets

class SocialMediaViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Using the enum
        let facebookIcon = UIImage(named: DesignAssets.IconName.facebookOriginal.rawValue, 
                                 in: DesignAssets.bundle, 
                                 compatibleWith: nil)
        
        // Using the helper method
        let instagramIcon = DesignAssets.uiImage(named: "instagram_original") as? UIImage
        
        let imageView = UIImageView(image: facebookIcon)
        view.addSubview(imageView)
    }
}
```

### Available Icon Names

```swift
// Original variants
.facebookOriginal
.instagramOriginal
.xTwitterOriginal
.linkedinOriginal
.youtubeOriginal
.tiktokOriginal
.snapchatOriginal
.pinterestOriginal
.redditOriginal
.whatsappOriginal
.telegramOriginal
.signalOriginal
.threadsOriginal
.figmaOriginal
.githubOriginal
.googleOriginal
.appleOriginal
.discordOriginal
.twitchOriginal
.spotifyOriginal
.clubhouseOriginal
.vkOriginal
.mediumOriginal
.messengerOriginal
.tumblrOriginal

// Negative variants (same platforms with "Negative" suffix)
.facebookNegative
.instagramNegative
.xTwitterNegative
// ... and so on
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

### Usage with Generated Icons

```swift
import SwiftUI
import DesignAssets

struct MyView: View {
    var body: some View {
        VStack {
            // Using category-specific icons
            GeneratedIcons.General.home_icon.image
            GeneratedIcons.Map.location_pin.image
            
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

For detailed documentation, see [FIGMA_INTEGRATION.md](FIGMA_INTEGRATION.md).

## 🎨 Design System Integration

### Storybook Example
```swift
import SwiftUI
import DesignAssets

struct IconShowcase: View {
    let icons: [DesignAssets.IconName] = [
        .facebookOriginal, .instagramOriginal, .xTwitterOriginal,
        .linkedinOriginal, .youtubeOriginal, .tiktokOriginal
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
            ForEach(icons, id: \.self) { icon in
                VStack {
                    Image(icon.rawValue, bundle: DesignAssets.bundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    
                    Text(icon.rawValue)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }
}
```

## 📦 Package Structure

```
DesignAssets/
├── Sources/
│   └── DesignAssets/
│       ├── DesignAssets.swift          # Main API
│       ├── FigmaClient.swift           # Enhanced Figma integration
│       ├── SocialMediaIcons.swift      # Social media icons
│       └── Resources/
│           ├── Icons.xcassets/         # 52 PDF iconsets
│           │   ├── facebook_original.imageset/
│           │   ├── facebook_negative.imageset/
│           │   └── ... (50 more)
│           ├── GeneratedIcons.swift    # Auto-generated from Figma
│           ├── Icons.xcassets/         # Auto-generated asset catalog
│           └── icon-summary.md         # Generated summary report
├── Plugins/
│   └── FetchIconsPlugin/
│       └── Plugin.swift                # Supercharged Figma plugin
├── Examples/
│   ├── FigmaIntegrationExample.swift   # Figma integration examples
│   ├── SocialMediaIconsUsageExample.swift
│   └── social_media_icons.json
├── Package.swift                       # SPM configuration
├── test-figma-integration.sh           # Test script
├── FIGMA_INTEGRATION.md                # Detailed Figma docs
└── README.md                          # This file
```

## 🔧 Technical Details

- **Format**: PDF (vector-based)
- **File Sizes**: 4KB - 17KB per icon
- **Scalability**: Perfect at any resolution
- **iOS Support**: iOS 15.0+
- **macOS Support**: macOS 12.0+
- **Swift Version**: 5.9+

## 🎯 Benefits

- **Vector Quality**: Crisp rendering at any size
- **Small Bundle Size**: Efficient PDF compression
- **Consistent Styling**: All icons follow the same design language
- **Easy Integration**: Simple API with type-safe enum access
- **Future-Proof**: Easy to add new icons or update existing ones

## 📄 License

This package is available under the MIT license. See the LICENSE file for more info.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions, please open an issue on GitHub.

---

**Made with ❤️ for the iOS community**

# DesignAssets

A comprehensive Swift Package containing 52 high-quality social media icons in PDF format, directly sourced from Figma. Perfect for iOS and macOS applications requiring professional social media branding.

## ✨ Features

- 🎨 **52 Social Media Icons** - Complete collection of popular platform icons
- 📱 **PDF Vector Format** - Scalable, crisp rendering at any size
- 🎯 **Two Variants** - Both "Original" and "Negative" styles for each platform
- 🚀 **Zero Dependencies** - Pure Swift Package Manager integration
- 📦 **Ready to Use** - No setup or configuration required

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

### 1. Add to Your Project

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

### 2. Import and Use

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
│       └── Resources/
│           └── Icons.xcassets/         # 52 PDF iconsets
│               ├── facebook_original.imageset/
│               ├── facebook_negative.imageset/
│               ├── instagram_original.imageset/
│               └── ... (48 more)
├── Package.swift                       # SPM configuration
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

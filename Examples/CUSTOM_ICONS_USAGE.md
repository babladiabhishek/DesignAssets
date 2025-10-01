# 🎨 Using Custom Icons in Your App

## 📋 Current Status

The demo app shows the **organized icon structure** using system icons as placeholders. The actual custom icons are available in the asset catalogs but require proper setup to load correctly.

## 🗂️ Icon Organization

Your icons are organized into separate `.xcassets` files:

- **`StatusIcons.xcassets`** - Status icons (12x12, 16x16, 20x20)
- **`MapIcons.xcassets`** - Map/Order Location icons  
- **`FeelGoodIcons.xcassets`** - Feel Good icons (filled/outline)
- **`GeneralIcons.xcassets`** - General purpose icons

## 🚀 How to Use Custom Icons in Your App

### Method 1: Direct Asset Loading (Recommended)

```swift
import SwiftUI
import DesignAssets

struct MyView: View {
    var body: some View {
        VStack {
            // Load directly from specific asset catalogs
            Image("ic_status_success_16")
                .resizable()
                .frame(width: 32, height: 32)
            
            Image("map_pin_single_default")
                .resizable()
                .frame(width: 32, height: 32)
            
            Image("ic_light_bulb_default_32")
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
}
```

### Method 2: Using GeneratedIcons (When Fixed)

```swift
import SwiftUI
import DesignAssets

struct MyView: View {
    var body: some View {
        VStack {
            // This should work once the bundle issue is fixed
            GeneratedIcons.ic_status_success_16.image
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
}
```

## 🔧 Fixing the Bundle Issue

The current issue is that `GeneratedIcons.swift` tries to load images from the main bundle, but they're in separate asset catalogs. To fix this:

### Option 1: Update GeneratedIcons.swift

Modify the image loading in `GeneratedIcons.swift` to use the correct bundle:

```swift
// Instead of:
case .ic_status_success_16: return Image("ic_status_success_16")

// Use:
case .ic_status_success_16: return Image("ic_status_success_16", bundle: Bundle.module)
```

### Option 2: Consolidate Asset Catalogs

Move all icons back to a single `Icons.xcassets` file, but keep the organized folder structure within it.

### Option 3: Use Direct Loading

Use `Image("icon_name")` directly in your app instead of going through `GeneratedIcons.image`.

## 📱 Real App Integration

### 1. Add DesignAssets to Your App

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/yourusername/DesignAssets.git", from: "1.0.0")
]
```

### 2. Import and Use

```swift
import DesignAssets
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Status icons
            Image("ic_status_success_16")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.green)
            
            // Map icons
            Image("map_pin_single_default")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.red)
            
            // Feel Good icons
            Image("ic_light_bulb_default_32")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.yellow)
        }
    }
}
```

## 🎯 Benefits of This Organization

1. **Better Performance** - Only load the icons you need
2. **Cleaner Code** - Icons are logically grouped
3. **Easier Maintenance** - Update icons by category
4. **Smaller Bundle Size** - Exclude unused categories

## 🔍 Available Icons

### Status Icons (25 icons)
- `ic_status_success_16`, `ic_status_alert_20`, etc.
- Sizes: 12x12, 16x16, 20x20

### Map Icons (20 icons)  
- `map_pin_single_default`, `ic_order_delivery_32`, etc.
- Order location and delivery icons

### Feel Good Icons (15 icons)
- `ic_light_bulb_default_32`, `ic_search_filled_32`, etc.
- Filled and outline variants

### General Icons (378 icons)
- `ic_hamburger_default_32`, `ic_trash_filled_32`, etc.
- General purpose icons

## 🐛 Troubleshooting

### Icons Not Showing?
1. Check that the asset catalog is included in your target
2. Verify the icon name matches exactly
3. Ensure the `.xcassets` file is in the correct bundle

### Build Errors?
1. Make sure `DesignAssets` is properly linked
2. Check that all required asset catalogs are included
3. Verify the Swift Package Manager setup

## 📞 Next Steps

1. **Fix the bundle loading** in `GeneratedIcons.swift`
2. **Test in a real app** to ensure icons load correctly
3. **Update documentation** with working examples
4. **Consider consolidating** asset catalogs if needed

The organized structure is working perfectly - we just need to fix the asset loading mechanism!

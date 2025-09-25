# 🚀 App Integration Guide

## How to Use DesignAssets SPM in Your App

This guide shows you how to integrate the DesignAssets Swift Package Manager package into your iOS/macOS app.

---

## 📦 **Step 1: Add Package to Your Project**

### **Option A: Using Xcode (Recommended)**

1. **Open your Xcode project**
2. **Go to File → Add Package Dependencies...**
3. **Enter the repository URL:**
   ```
   https://github.com/babladiabhishek/DesignAssets
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

---

## 🎯 **Step 2: Import the Package**

In any Swift file where you want to use the icons:

```swift
import DesignAssets
```

---

## 🎨 **Step 3: Use Icons in Your App**

### **Basic Usage**

```swift
import SwiftUI
import DesignAssets

struct MyView: View {
    var body: some View {
        VStack {
            // Use any icon directly
            GeneratedIcons.search_filled_32.image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
            
            Text("Search")
        }
    }
}
```

### **Navigation Bar Icons**

```swift
NavigationView {
    List {
        NavigationLink(destination: SearchView()) {
            HStack {
                GeneratedIcons.search_filled_32.image?
                    .foregroundColor(.blue)
                Text("Search")
            }
        }
        
        NavigationLink(destination: MapView()) {
            HStack {
                GeneratedIcons.map_filled_32.image?
                    .foregroundColor(.green)
                Text("Map")
            }
        }
    }
    .navigationTitle("Menu")
}
```

### **Tab Bar Icons**

```swift
TabView {
    HomeView()
        .tabItem {
            GeneratedIcons.home_filled_32.image
            Text("Home")
        }
    
    SearchView()
        .tabItem {
            GeneratedIcons.search_filled_32.image
            Text("Search")
        }
    
    ProfileView()
        .tabItem {
            GeneratedIcons.person_filled_32.image
            Text("Profile")
        }
}
```

### **Button Icons**

```swift
Button(action: {
    // Action
}) {
    HStack {
        GeneratedIcons.play_filled.image?
            .foregroundColor(.white)
        Text("Play")
            .foregroundColor(.white)
    }
    .padding()
    .background(Color.blue)
    .cornerRadius(8)
}
```

### **Status Indicators**

```swift
HStack {
    GeneratedIcons.status_success_20.image?
        .foregroundColor(.green)
    Text("Success!")
        .foregroundColor(.green)
}
```

---

## 🔍 **Step 4: Browse Available Icons**

### **Get All Icons**

```swift
let allIcons = GeneratedIcons.allIcons
print("Total icons: \(allIcons.count)") // 169 icons
```

### **Browse by Category**

```swift
// Get categories
let categories = GeneratedIcons.categories
print("Categories: \(categories.keys)") // ["General", "Map", "Navigation", "Status"]

// Get icons in a specific category
let generalIcons = GeneratedIcons.categories["General"]
let mapIcons = GeneratedIcons.categories["Map"]
```

### **Get Icon Properties**

```swift
let icon = GeneratedIcons.search_filled_32
print(icon.imageName)    // "search_filled_32"
print(icon.category)     // "General"
print(icon.variant)      // "filled"
```

---

## 🎨 **Step 5: Icon Variants**

The package includes multiple variants for many icons:

- **`default`**: Outline style icons
- **`filled`**: Solid style icons
- **`original`**: Original design from Figma

### **Example: Search Icon Variants**

```swift
VStack {
    GeneratedIcons.search_default_32.image?  // Outline
    GeneratedIcons.search_filled_32.image?   // Filled
}
```

---

## 📱 **Step 6: Real App Examples**

### **Complete App Structure**

```swift
import SwiftUI
import DesignAssets

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    GeneratedIcons.home_filled_32.image
                    Text("Home")
                }
            
            SearchView()
                .tabItem {
                    GeneratedIcons.search_filled_32.image
                    Text("Search")
                }
            
            ProfileView()
                .tabItem {
                    GeneratedIcons.person_filled_32.image
                    Text("Profile")
                }
        }
    }
}
```

### **Dynamic Icon Selection**

```swift
struct IconPicker: View {
    @State private var selectedIcon: GeneratedIcons = .search_default_32
    @State private var selectedCategory: String = "General"
    
    var body: some View {
        VStack {
            // Display selected icon
            selectedIcon.image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            
            // Category picker
            Picker("Category", selection: $selectedCategory) {
                ForEach(Array(GeneratedIcons.categories.keys.sorted()), id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Icons grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    ForEach(GeneratedIcons.categories[selectedCategory] ?? [], id: \.self) { icon in
                        Button(action: { selectedIcon = icon }) {
                            icon.image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
    }
}
```

---

## 🛠 **Step 7: Customization**

### **Custom Icon Sizes**

```swift
GeneratedIcons.search_filled_32.image?
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 24, height: 24)  // Small
    .frame(width: 48, height: 48)  // Medium
    .frame(width: 64, height: 64)  // Large
```

### **Custom Colors**

```swift
GeneratedIcons.search_filled_32.image?
    .foregroundColor(.blue)        // Blue
    .foregroundColor(.red)         // Red
    .foregroundColor(.green)       // Green
```

### **Custom Styling**

```swift
GeneratedIcons.search_filled_32.image?
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 40, height: 40)
    .padding(8)
    .background(Color.blue.opacity(0.1))
    .cornerRadius(8)
```

---

## 📊 **Available Icons Summary**

- **Total Icons**: 169
- **Categories**: 4 (General, Map, Navigation, Status)
- **Variants**: 3 (default, filled, original)
- **Source**: Figma API Integration

### **Popular Icons**

```swift
// Navigation
GeneratedIcons.chevron_left_default_32
GeneratedIcons.chevron_right_filled_32
GeneratedIcons.arrow_left_default_32
GeneratedIcons.arrow_right_filled_32

// Actions
GeneratedIcons.play_default
GeneratedIcons.pause_filled
GeneratedIcons.search_default_32
GeneratedIcons.search_filled_32

// Status
GeneratedIcons.status_success_20
GeneratedIcons.status_alert_20
GeneratedIcons.status_blocker_20

// UI Elements
GeneratedIcons.close_default_32
GeneratedIcons.add_default_32
GeneratedIcons.remove_default_32
```

---

## 🚀 **Step 8: Advanced Usage**

### **Icon Filtering**

```swift
// Get only filled variants
let filledIcons = GeneratedIcons.allIcons.filter { $0.variant == "filled" }

// Get only map icons
let mapIcons = GeneratedIcons.allIcons.filter { $0.category == "Map" }

// Get icons by name pattern
let searchIcons = GeneratedIcons.allIcons.filter { $0.imageName.contains("search") }
```

### **Dynamic Icon Loading**

```swift
struct DynamicIconView: View {
    let iconName: String
    
    var body: some View {
        if let icon = GeneratedIcons.allIcons.first(where: { $0.imageName == iconName }) {
            icon.image?
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "questionmark")
        }
    }
}
```

---

## 🎉 **You're Ready!**

Your app now has access to 169 professionally designed icons from Figma! The package provides:

- ✅ **Type-safe access** through Swift enums
- ✅ **Category organization** for easy browsing
- ✅ **Multiple variants** for different use cases
- ✅ **SwiftUI integration** out of the box
- ✅ **Automatic updates** when you refresh from Figma

Happy coding! 🚀

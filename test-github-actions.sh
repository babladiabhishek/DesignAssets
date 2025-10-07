#!/bin/bash

# Test script to simulate GitHub Actions workflow locally
# This script tests asset scanning and Swift code generation

set -e

echo "🤖 Testing asset scanning and Swift code generation..."

# Step 1: Generate Swift Code from Existing Assets
echo "🔧 Generating Swift code from existing assets..."
cat > generate_icons.swift << 'EOF'
import Foundation

let resourcesDir = "Sources/DesignAssets/Resources"
let outputFile = "Sources/DesignAssets/GeneratedIcons.swift"

print("🔍 Scanning for existing icon assets...")

let fm = FileManager.default
let resourcesURL = URL(fileURLWithPath: resourcesDir)

guard fm.fileExists(atPath: resourcesURL.path) else {
    print("⚠️ No Resources directory found")
    exit(1)
}

var allIcons: [(String, String)] = []
var categories: Set<String> = []

// Helper functions
func camelCase(_ string: String) -> String {
    let components = string.components(separatedBy: "_")
    guard let first = components.first else { return string }
    return first + components.dropFirst().map { $0.capitalized }.joined()
}

func determineCategory(from iconName: String) -> String {
    if iconName.hasPrefix("general_") { return "General" }
    if iconName.hasPrefix("map_") { return "Map" }
    if iconName.hasPrefix("status_") { return "Status" }
    if iconName.hasPrefix("navigation_") { return "Navigation" }
    return "General"
}

// Find all .xcassets directories
let enumerator = fm.enumerator(at: resourcesURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])

while let fileURL = enumerator?.nextObject() as? URL {
    if fileURL.pathExtension == "xcassets" {
        let imagesetEnumerator = fm.enumerator(at: fileURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
        
        while let imagesetURL = imagesetEnumerator?.nextObject() as? URL {
            if imagesetURL.pathExtension == "imageset" {
                let iconName = imagesetURL.deletingPathExtension().lastPathComponent
                let category = determineCategory(from: iconName)
                categories.insert(category)
                allIcons.append((iconName, category))
            }
        }
    }
}

if allIcons.isEmpty {
    print("⚠️ No icon assets found")
    exit(1)
}

print("📦 Found \(allIcons.count) icons in \(categories.count) categories")

// Generate Swift code
let swiftFile = URL(fileURLWithPath: outputFile)
var swiftCode = """
import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(UIKit)
import UIKit
#endif

public enum GeneratedIcons {
    public static let bundle = Bundle.module
"""

// Group icons by category
let groupedIcons = Dictionary(grouping: allIcons) { $0.1 }

for category in categories.sorted() {
    let enumName = category.replacingOccurrences(of: " ", with: "")
    swiftCode += "\n\n    public enum \(enumName): String, CaseIterable {"
    
    if let categoryIcons = groupedIcons[category] {
        for (iconName, _) in categoryIcons.sorted(by: { $0.0 < $1.0 }) {
            let camelCaseName = camelCase(iconName)
            swiftCode += "\n        case \(camelCaseName) = \"\(iconName)\""
        }
    }
    
    swiftCode += """
    
    public var image: Image {
        Image(rawValue, bundle: bundle)
    }
    #if canImport(UIKit)
    public var uiImage: UIImage? {
        UIImage(named: rawValue, in: bundle, with: nil)
    }
    #endif
}
"""
}

swiftCode += """


// MARK: - Helper Extensions

extension GeneratedIcons {
    public static var allIcons: [String] {
        return [
"""

for (iconName, _) in allIcons.sorted(by: { $0.0 < $1.0 }) {
    swiftCode += "\n            \"\(iconName)\","
}

swiftCode += """

        ]
    }
    
    public static var categories: [String] {
        return [
"""

for category in categories.sorted() {
    swiftCode += "\n            \"\(category)\","
}

swiftCode += """

        ]
    }
}
"""

do {
    try swiftCode.write(to: swiftFile, atomically: true, encoding: .utf8)
    print("✅ Generated Swift code at \(swiftFile.path)")
    print("🎉 Generated code for \(allIcons.count) icons successfully!")
} catch {
    print("❌ Error writing Swift code: \(error)")
    exit(1)
}
EOF

# Run the Swift script
swift generate_icons.swift

# Clean up
rm generate_icons.swift

echo "✅ Swift code generated successfully!"

# Step 2: Test Build
echo "🧪 Testing build..."
swift build
echo "✅ Build test passed!"

# Step 3: Run Tests
echo "🧪 Running tests..."
swift test
echo "✅ All tests passed!"

# Step 4: Create Summary
echo "📊 Creating summary..."

# Count icons
ICON_COUNT=$(find Sources/DesignAssets/Resources -name "*.imageset" | wc -l)

# Count categories
CATEGORIES=$(grep -o "public enum [A-Za-z]*:" Sources/DesignAssets/GeneratedIcons.swift | wc -l)

echo ""
echo "## 🔍 Asset Scanning Summary"
echo ""
echo "| Metric | Value |"
echo "|--------|-------|"
echo "| 📦 Total Icons | $ICON_COUNT |"
echo "| 📂 Categories | $CATEGORIES |"
echo "| 🕒 Timestamp | $(date -u) |"
echo ""
echo "### 🎯 Categories Found:"
grep -o "public enum [A-Za-z]*:" Sources/DesignAssets/GeneratedIcons.swift | sed 's/public enum /- /' | sed 's/://'
echo ""
echo "### 📱 Usage:"
echo "\`\`\`swift"
echo "import DesignAssets"
echo ""
echo "// SwiftUI"
echo "GeneratedIcons.General.generalIcSearchDefault32.image"
echo ""
echo "// UIKit"
echo "GeneratedIcons.General.generalIcSearchDefault32.uiImage"
echo "\`\`\`"

echo ""
echo "🎉 Asset scanning and code generation completed successfully!"
echo "💡 This scans existing assets and generates type-safe Swift code"
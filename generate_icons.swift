import Foundation

@main
struct IconGenerator {
    static func main() {
        let resourcesDir = "Sources/DesignAssets/Resources"
        let outputFile = "Sources/DesignAssets/GeneratedIcons.swift"
        
        print("🔍 Scanning for existing icon assets...")
        
        let fm = FileManager.default
        let resourcesURL = URL(fileURLWithPath: resourcesDir)
        
        guard fm.fileExists(atPath: resourcesURL.path) else {
            print("⚠️ No Resources directory found")
            return
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
            return
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
            swiftCode += "\n                    \"\(iconName)\","
        }
        
        swiftCode += """

                ]
            }
            
            public static var categories: [String] {
                return [
        """
        
        for category in categories.sorted() {
            swiftCode += "\n                    \"\(category)\","
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
    }
}

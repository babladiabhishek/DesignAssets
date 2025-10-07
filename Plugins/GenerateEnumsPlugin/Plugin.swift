import Foundation
import PackagePlugin
#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
#endif

// MARK: - Data Models for Plugin

struct IconInfo {
    let id: String
    let name: String
    let category: String
    let variant: String
    let nodeId: String
    let filePath: String
    let size: CGSize
    let isComponent: Bool
    let thumbnailUrl: String?
    let description: String?
}

// MARK: - Main Plugin

@main
struct GenerateEnumsPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        print("🔍 Scanning for existing icon assets...")
        
        let resourcesDir = context.package.directory.appending(subpath: "Sources/DesignAssets/Resources")
        
        // Scan for existing icons
        let allIcons = scanForIcons(in: resourcesDir.string)
        
        if allIcons.isEmpty {
            print("⚠️ No icon assets found. Please add icons to Sources/DesignAssets/Resources/")
            return
        }
        
        print("📦 Found \(allIcons.count) icons")
        
        // Generate Swift code
        let swiftFile = context.package.directory.appending(subpath: "Sources/DesignAssets/GeneratedIcons.swift")
        try generateSwiftCode(icons: allIcons, outputPath: swiftFile)
        
        print("✅ Generated Swift code at \(swiftFile.string)")
        print("🎉 Generated code for \(allIcons.count) icons successfully!")
    }
}

// MARK: - Helper Functions

func scanForIcons(in directory: String) -> [IconInfo] {
    let fm = FileManager.default
    let resourcesURL = URL(fileURLWithPath: directory)
    
    guard fm.fileExists(atPath: resourcesURL.path) else {
        return []
    }
    
    var allIcons: [IconInfo] = []
    
    // Find all .xcassets directories
    let enumerator = fm.enumerator(at: resourcesURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
    
    while let fileURL = enumerator?.nextObject() as? URL {
        if fileURL.pathExtension == "xcassets" {
            // Find all .imageset directories
            let imagesetEnumerator = fm.enumerator(at: fileURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
            
            while let imagesetURL = imagesetEnumerator?.nextObject() as? URL {
                if imagesetURL.pathExtension == "imageset" {
                    let iconName = imagesetURL.deletingPathExtension().lastPathComponent
                    let category = determineCategory(from: iconName)
                    
                    let iconInfo = IconInfo(
                        id: iconName,
                        name: iconName,
                        category: category,
                        variant: "default",
                        nodeId: iconName,
                        filePath: imagesetURL.path,
                        size: CGSize(width: 32, height: 32),
                        isComponent: true,
                        thumbnailUrl: nil,
                        description: "Generated from existing assets"
                    )
                    
                    allIcons.append(iconInfo)
                }
            }
        }
    }
    
    return allIcons
}

func determineCategory(from iconName: String) -> String {
    if iconName.hasPrefix("flag_") {
        return "Flags"
    } else if iconName.hasPrefix("logo_") || iconName.contains("logo") {
        return "Logos"
    } else if iconName.hasPrefix("map_") {
        return "Map"
    } else if iconName.hasPrefix("status_") {
        return "Status"
    } else if iconName.hasPrefix("navigation_") {
        return "Navigation"
    } else if iconName.hasPrefix("il_") {
        return "Illustrations"
    } else if iconName.hasPrefix("im_") {
        return "Images"
    } else if iconName.hasPrefix("ic_") {
        return "Icons"
    } else {
        return "Icons" // Default category
    }
}

func generateSwiftCode(icons: [IconInfo], outputPath: Path) throws {
    let swiftFile = URL(fileURLWithPath: outputPath.string)
    
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
    let groupedIcons = Dictionary(grouping: icons) { $0.category }
    let categories = Set(icons.map { $0.category }).sorted()
    
    for category in categories {
        let enumName = category.replacingOccurrences(of: " ", with: "")
        swiftCode += "\n\n    public enum \(enumName): String, CaseIterable {"
        
        if let categoryIcons = groupedIcons[category] {
            for icon in categoryIcons.sorted(by: { $0.name < $1.name }) {
                let camelCaseName = camelCase(icon.name)
                swiftCode += "\n        case \(camelCaseName) = \"\(icon.name)\""
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
}


// MARK: - Helper Extensions

extension GeneratedIcons {
    public static var allIcons: [String] {
        return [
"""
    
    for icon in icons.sorted(by: { $0.name < $1.name }) {
        swiftCode += "\n            \"\(icon.name)\","
    }
    
    swiftCode += """

        ]
    }
    
    public static var categories: [String] {
        return [
"""
    
    for category in categories {
        swiftCode += "\n            \"\(category)\","
    }
    
    swiftCode += """

        ]
    }
    
    public static var totalIconCount: Int {
        return allIcons.count
    }
}
"""
    
    try swiftCode.write(to: swiftFile, atomically: true, encoding: .utf8)
}

func camelCase(_ string: String) -> String {
    // Replace hyphens and other special characters with underscores
    let cleaned = string.replacingOccurrences(of: "-", with: "_")
                       .replacingOccurrences(of: " ", with: "_")
                       .replacingOccurrences(of: ".", with: "_")
    
    let components = cleaned.components(separatedBy: "_")
    guard let first = components.first else { return string }
    
    // Ensure the first component is lowercase and valid Swift identifier
    let firstComponent = first.lowercased()
    let validFirst = firstComponent.isEmpty ? "icon" : firstComponent
    
    return validFirst + components.dropFirst().map { $0.capitalized }.joined()
}
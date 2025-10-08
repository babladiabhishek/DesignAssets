import Foundation
import PackagePlugin

// MARK: - Data Models for Plugin

struct IconInfo {
    let id: String
    let name: String
    let category: String
    let filePath: String
    let size: CGSize
}

// MARK: - Main Plugin

@main
struct GenerateEnumsPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let logName = "GenerateEnumsPlugin(BuildToolPlugin)"

        guard let target = target as? SourceModuleTarget else {
            Diagnostics.error("\(logName): unable to cast target as SourceModuleTarget")
            return []
        }

        let resourcesDir = target.directory.appending(subpath: "Resources")
        let allIcons = scanForIcons(in: resourcesDir.string)

        guard !allIcons.isEmpty else {
            Diagnostics.error("\(logName): No icon assets found in \(resourcesDir.string)")
            return []
        }

        let output = context.pluginWorkDirectory.appending("GeneratedIcons.swift")
        
        // Generate the Swift code content
        let swiftCode = generateSwiftCodeContent(icons: allIcons)
        
        // Write the generated code to the output file
        try swiftCode.write(to: URL(fileURLWithPath: output.string), atomically: true, encoding: .utf8)

        return [
            .buildCommand(
                displayName: "Generate Icon Enums",
                executable: .init("/usr/bin/true"), // No external tool needed
                arguments: [],
                inputFiles: [],
                outputFiles: [output]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension GenerateEnumsPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let logName = "GenerateEnumsPlugin(XcodeBuildToolPlugin)"

        let resourcesDir = target.directory.appending(subpath: "Resources")
        let allIcons = scanForIcons(in: resourcesDir.string)

        guard !allIcons.isEmpty else {
            Diagnostics.error("\(logName): No icon assets found in \(resourcesDir.string)")
            return []
        }

        let output = context.pluginWorkDirectory.appending("GeneratedIcons.swift")
        
        // Generate the Swift code content
        let swiftCode = generateSwiftCodeContent(icons: allIcons)
        
        // Write the generated code to the output file
        try swiftCode.write(to: URL(fileURLWithPath: output.string), atomically: true, encoding: .utf8)

        return [
            .buildCommand(
                displayName: "Generate Icon Enums",
                executable: .init("/usr/bin/true"), // No external tool needed
                arguments: [],
                inputFiles: [],
                outputFiles: [output]
            )
        ]
    }
}
#endif

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
                        filePath: imagesetURL.path,
                        size: CGSize(width: 32, height: 32)
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

func generateSwiftCodeContent(icons: [IconInfo]) -> String {
    var swiftCode = """
// Generated by GenerateEnumsPlugin
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
        
        #if canImport(SwiftUI)
        public var image: Image {
            Image(rawValue, bundle: bundle)
        }
        #endif
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
    
    return swiftCode
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
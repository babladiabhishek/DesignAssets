import Foundation
import PackagePlugin

@main
struct IconFetcherPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard target.name == "DesignAssets" else { return [] }

        Diagnostics.remark("🎨 IconFetcherPlugin: createBuildCommands called for target: \(target.name)")
        
        let tempOutputDir = context.pluginWorkDirectory // Use temp dir for generation
        let finalOutputDir = context.package.directory.appending(subpath: "Sources/DesignAssets/Resources") // Target dir (read-only during build)
        let scriptPath = tempOutputDir.appending("fetch_icons.swift")
        
        // Read configuration
        let configPath = context.package.directory.appending("icon-fetcher-config.json")
        
        let fileId: String
        var token: String
        
        if FileManager.default.fileExists(atPath: configPath.string) {
            let configData = try Data(contentsOf: URL(filePath: configPath.string))
            let config = try JSONDecoder().decode(Config.self, from: configData)
            fileId = config.figma.fileId
            token = config.figma.personalToken
        } else {
            // Use environment variables as fallback
            fileId = ProcessInfo.processInfo.environment["FIGMA_FILE_ID"] ?? "T0ahWzB1fWx5BojSMkfiAE"
            token = ProcessInfo.processInfo.environment["FIGMA_PERSONAL_TOKEN"] ?? ""
        }
        
        if token.isEmpty {
            token = ProcessInfo.processInfo.environment["FIGMA_PERSONAL_TOKEN"] ?? ""
        }
        
        guard !token.isEmpty else {
            Diagnostics.remark("⚠️ No Figma token found. Skipping icon fetch.")
            return []
        }

        let forceDownload = ProcessInfo.processInfo.environment["FORCE_DOWNLOAD"] == "true"

        // Create a script that generates Swift code from existing assets in temp directory
        let scriptContent = """
            import Foundation

            @main
            struct IconGenerator {
                static func main() {
                    let tempOutputDir = "\(tempOutputDir.string)"
                    let finalOutputDir = "\(finalOutputDir.string)"
                    
                    // Camel case function
                    func camelCase(_ string: String) -> String {
                        let components = string.components(separatedBy: "_")
                        guard let first = components.first else { return string }
                        return first + components.dropFirst().map { $0.capitalized }.joined()
                    }
                    
                    print("🔍 Scanning for existing icon assets...")
                    
                    // Scan for existing .xcassets directories in the final output directory
                    let fm = FileManager.default
                    let resourcesURL = URL(fileURLWithPath: finalOutputDir)
                    
                    guard fm.fileExists(atPath: resourcesURL.path) else {
                        print("⚠️ No Resources directory found. Run 'swift package plugin fetch-icons' first to download icons.")
                        exit(0)
                    }
                    
                    var allIcons: [(String, String)] = [] // (name, category)
                    var categories: Set<String> = []
                    
                    // Helper function to determine category from icon name
                    func determineCategory(from iconName: String) -> String {
                        if iconName.hasPrefix("general_") {
                            return "General"
                        } else if iconName.hasPrefix("map_") {
                            return "Map"
                        } else if iconName.hasPrefix("status_") {
                            return "Status"
                        } else if iconName.hasPrefix("navigation_") {
                            return "Navigation"
                        } else {
                            return "General"
                        }
                    }
                    
                    // Find all .xcassets directories
                    let enumerator = fm.enumerator(at: resourcesURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
                    
                    while let fileURL = enumerator?.nextObject() as? URL {
                        if fileURL.pathExtension == "xcassets" {
                            // Find all .imageset directories
                            let imagesetEnumerator = fm.enumerator(at: fileURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
                            
                            while let imagesetURL = imagesetEnumerator?.nextObject() as? URL {
                                if imagesetURL.pathExtension == "imageset" {
                                    let iconName = imagesetURL.deletingPathExtension().lastPathComponent
                                    
                                    // Parse category from icon name (e.g., "general_ic_search_default_32" -> "General")
                                    let category = determineCategory(from: iconName)
                                    categories.insert(category)
                                    allIcons.append((iconName, category))
                                }
                            }
                        }
                    }
                    
                    if allIcons.isEmpty {
                        print("⚠️ No icon assets found. Run 'swift package plugin fetch-icons' first to download icons.")
                        exit(0)
                    }
                    
                    print("📦 Found \\(allIcons.count) icons in \\(categories.count) categories")
                    
                    // Generate Swift code to temp directory
                    let swiftFile = URL(fileURLWithPath: tempOutputDir).appendingPathComponent("GeneratedIcons.swift")
                    var swiftCode = "import Foundation\\n#if canImport(SwiftUI)\\nimport SwiftUI\\n#endif\\n#if canImport(UIKit)\\nimport UIKit\\n#endif\\n\\npublic enum GeneratedIcons {\\n    public static let bundle = Bundle.module\\n"
                    
                    // Group icons by category
                    let groupedIcons = Dictionary(grouping: allIcons) { $0.1 }
                    
                    for category in categories.sorted() {
                        let enumName = category.replacingOccurrences(of: " ", with: "")
                        swiftCode += "\\n    public enum \\(enumName): String, CaseIterable {\\n"
                        
                        if let categoryIcons = groupedIcons[category] {
                            for (iconName, _) in categoryIcons.sorted(by: { $0.0 < $1.0 }) {
                                let camelCaseName = camelCase(iconName)
                                swiftCode += "        case " + camelCaseName + " = \\"" + iconName + "\\"\\n"
                            }
                        }
                        
                        swiftCode += "        public var image: Image {\\n"
                        swiftCode += "            Image(rawValue, bundle: bundle)\\n"
                        swiftCode += "        }\\n"
                        swiftCode += "        #if canImport(UIKit)\\n"
                        swiftCode += "        public var uiImage: UIImage? {\\n"
                        swiftCode += "            UIImage(named: rawValue, in: bundle, with: nil)\\n"
                        swiftCode += "        }\\n"
                        swiftCode += "        #endif\\n"
                        swiftCode += "    }\\n"
                    }
                    
                    swiftCode += "}\\n\\n"
                    swiftCode += "// MARK: - Helper Extensions\\n\\n"
                    swiftCode += "extension GeneratedIcons {\\n"
                    swiftCode += "    public static var allIcons: [String] {\\n"
                    swiftCode += "        return [\\n"
                    
                    for (iconName, _) in allIcons.sorted(by: { $0.0 < $1.0 }) {
                        swiftCode += "            \\"" + iconName + "\\",\\n"
                    }
                    
                    swiftCode += "        ]\\n"
                    swiftCode += "    }\\n\\n"
                    swiftCode += "    public static var categories: [String] {\\n"
                    swiftCode += "        return [\\n"
                    
                    for category in categories.sorted() {
                        swiftCode += "            \\"" + category + "\\",\\n"
                    }
                    
                    swiftCode += "        ]\\n"
                    swiftCode += "    }\\n"
                    swiftCode += "}\\n"
                    
                    do {
                        try swiftCode.data(using: .utf8)?.write(to: swiftFile)
                        print("✅ Generated Swift code at \\(swiftFile.path)")
                        print("🎉 Generated code for \\(allIcons.count) icons successfully!")
                        print("⚠️ Files generated in \\(tempOutputDir). Manually copy to \\(finalOutputDir) after build.")
                        print("💡 Run: cp -r \\(tempOutputDir)/* \\(finalOutputDir)/")
                    } catch {
                        print("❌ Error writing Swift code: \\(error)")
                        exit(1)
                    }
                }
            }
            """
        
        try scriptContent.data(using: .utf8)?.write(to: URL(filePath: scriptPath.string))
        
        // Make executable
        let chmod = Process()
        chmod.executableURL = URL(fileURLWithPath: "/bin/chmod")
        chmod.arguments = ["+x", scriptPath.string]
        try chmod.run()
        chmod.waitUntilExit()

            let executablePath = tempOutputDir.appending("icon_generator")
            
            return [
                .prebuildCommand(
                    displayName: "🎨 Generate Icons from Assets",
                    executable: Path("/usr/bin/swiftc"),
                    arguments: ["-parse-as-library", "-o", executablePath.string, scriptPath.string],
                    environment: [:],
                    outputFilesDirectory: tempOutputDir
                ),
                .prebuildCommand(
                    displayName: "🎨 Run Icon Generator",
                    executable: executablePath,
                    arguments: [],
                    environment: [:],
                    outputFilesDirectory: tempOutputDir
                )
            ]
    }
}

struct Config: Decodable {
    struct Figma: Decodable {
        let fileId: String
        let personalToken: String
    }
    struct Output: Decodable {
        let basePath: String
        let autoDetectLayers: Bool
        let createAssetCatalogs: Bool
    }
    struct Filtering: Decodable {
        let iconPrefixes: [String]
        let iconKeywords: [String]
        let excludeSizeIndicators: [String]
    }
    let figma: Figma
    let output: Output
    let filtering: Filtering
}

struct PluginError: Error, CustomStringConvertible {
    let description: String
    init(_ description: String) { self.description = description }
}
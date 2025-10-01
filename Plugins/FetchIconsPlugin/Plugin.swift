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
    let variant: String?
    let nodeId: String
    let filePath: String
    let size: CGSize
    let isComponent: Bool
    let thumbnailUrl: String?
    let description: String?
}

@main
struct FetchIconsPlugin: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        try await runFetch(context: context, arguments: arguments)
    }
}

#if canImport(XcodeProjectPlugin)
extension FetchIconsPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        Task {
            try await runFetch(context: context, arguments: arguments)
        }
    }
}
#endif

private func runFetch(context: some FetchContext, arguments: [String]) async throws {
    let packageDir = context.packageDirectory
    let outputDir = packageDir.appending(subpath: "Sources/DesignAssets/Resources")
    
    // Parse command line arguments
    var figmaToken: String?
    var figmaFileId: String?
    var includeVariants = true
    var generateAssetCatalog = true
    var generateSwiftCode = true
    
    // Get Figma token from arguments or environment
    figmaToken = ProcessInfo.processInfo.environment["FIGMA_PERSONAL_TOKEN"]
    figmaFileId = ProcessInfo.processInfo.environment["FIGMA_FILE_ID"]
    
    // Parse arguments
    for (index, argument) in arguments.enumerated() {
        switch argument {
        case "--token" where index + 1 < arguments.count:
            figmaToken = arguments[index + 1]
        case "--file-id" where index + 1 < arguments.count:
            figmaFileId = arguments[index + 1]
        case "--no-variants":
            includeVariants = false
        case "--no-asset-catalog":
            generateAssetCatalog = false
        case "--no-swift-code":
            generateSwiftCode = false
        case "--help", "-h":
            printHelp()
            return
        default:
            break
        }
    }
    
    guard let token = figmaToken, !token.isEmpty else {
        throw PluginError("FIGMA_PERSONAL_TOKEN not set. Set it in environment or pass --token <token>")
    }
    
    guard let fileId = figmaFileId, !fileId.isEmpty else {
        throw PluginError("FIGMA_FILE_ID not set. Set it in environment or pass --file-id <file-id>")
    }
    
    context.log("🚀 Starting supercharged Figma icon fetch...")
    context.log("📁 File ID: \(fileId)")
    context.log("📂 Output directory: \(outputDir)")
    context.log("🎨 Include variants: \(includeVariants)")
    context.log("📦 Generate asset catalog: \(generateAssetCatalog)")
    context.log("⚡ Generate Swift code: \(generateSwiftCode)")
    
    // Create output directory if it doesn't exist
    try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputDir.string), withIntermediateDirectories: true)
    
    do {
        context.log("🚀 Starting Figma integration...")
        context.log("📁 File ID: \(fileId)")
        context.log("🔑 Token: \(String(token.prefix(10)))...")
        
        // Fetch real icons from Figma API
        let icons = try await fetchIconsFromFigma(
            fileId: fileId,
            token: token,
            outputDirectory: URL(fileURLWithPath: outputDir.string),
            includeVariants: includeVariants,
            generateAssetCatalog: generateAssetCatalog,
            generateSwiftCode: generateSwiftCode
        )
        
        context.log("🎉 Successfully processed \(icons.count) icons from Figma!")
        context.log("📊 Categories: \(Set(icons.map { $0.category }).sorted().joined(separator: ", "))")
        
        // Icons successfully processed and generated
        
        context.log("✅ Integration completed successfully!")
        
    } catch {
        context.log("❌ Error in integration: \(error.localizedDescription)")
        throw error
    }
}

private func printHelp() {
    print("""
    🎨 DesignAssets Figma Integration Plugin
    
    Usage: swift package plugin fetch-icons [options]
    
    Options:
      --token <token>        Figma personal access token
      --file-id <file-id>    Figma file ID to fetch icons from
      --no-variants          Skip variant processing (filled/outline)
      --no-asset-catalog     Skip Xcode asset catalog generation
      --no-swift-code        Skip Swift code generation
      --help, -h             Show this help message
    
    Environment Variables:
      FIGMA_PERSONAL_TOKEN   Figma personal access token
      FIGMA_FILE_ID          Figma file ID
    
    Examples:
      swift package plugin fetch-icons --token abc123 --file-id T0ahWzB1fWx5BojSMkfiAE
      FIGMA_PERSONAL_TOKEN=abc123 FIGMA_FILE_ID=T0ahWzB1fWx5BojSMkfiAE swift package plugin fetch-icons
    """)
}


// MARK: - Mock Data for Testing

private func createMockIcons() -> [IconInfo] {
    return [
        IconInfo(
            id: "1",
            name: "home_icon",
            category: "General",
            variant: "filled",
            nodeId: "1:1",
            filePath: "",
            size: CGSize(width: 24, height: 24),
            isComponent: true,
            thumbnailUrl: nil,
            description: "Home icon"
        ),
        IconInfo(
            id: "2",
            name: "search_icon",
            category: "General",
            variant: "outline",
            nodeId: "1:2",
            filePath: "",
            size: CGSize(width: 24, height: 24),
            isComponent: true,
            thumbnailUrl: nil,
            description: "Search icon"
        ),
        IconInfo(
            id: "3",
            name: "location_pin",
            category: "Map",
            variant: "filled",
            nodeId: "1:3",
            filePath: "",
            size: CGSize(width: 24, height: 24),
            isComponent: true,
            thumbnailUrl: nil,
            description: "Location pin icon"
        ),
        IconInfo(
            id: "4",
            name: "success_icon",
            category: "Status",
            variant: "filled",
            nodeId: "1:4",
            filePath: "",
            size: CGSize(width: 24, height: 24),
            isComponent: true,
            thumbnailUrl: nil,
            description: "Success status icon"
        )
    ]
}

// MARK: - Asset Catalog Generation

private func generateAssetCatalogFiles(icons: [IconInfo], outputDirectory: URL) throws {
    print("📦 Generating Xcode Asset Catalog...")
    
    let assetCatalogDir = outputDirectory.appendingPathComponent("Icons.xcassets")
    try FileManager.default.createDirectory(at: assetCatalogDir, withIntermediateDirectories: true)
    
    // Generate Contents.json for the main catalog
    let catalogContents = """
    {
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }
    """
    try catalogContents.write(to: assetCatalogDir.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
    
    print("✅ Generated asset catalog with \(icons.count) image sets")
}

// MARK: - Swift Code Generation

private func generateSwiftCodeFiles(icons: [IconInfo], outputDirectory: URL) throws {
    print("⚡ Generating Swift code...")
    
    let swiftFile = outputDirectory.appendingPathComponent("GeneratedIcons.swift")
    
    // Group icons by category
    let groupedIcons = Dictionary(grouping: icons) { $0.category }
    
    var swiftCode = """
    // Generated by DesignAssets Figma Integration
    // Do not edit this file manually
    // Generated on: \(Date())
    
    import Foundation
    #if canImport(SwiftUI)
    import SwiftUI
    #endif
    #if canImport(UIKit)
    import UIKit
    #endif
    
    // MARK: - Generated Icons
    
    public struct GeneratedIcons {
        public static let bundle = Bundle.module
        
        // MARK: - Icon Access
        
        @available(iOS 13.0, macOS 10.15, *)
        public static func icon(named name: String) -> Image? {
            #if canImport(SwiftUI)
            return Image(name, bundle: bundle)
            #else
            return nil
            #endif
        }
        
        public static func uiImage(named name: String) -> Any? {
            #if canImport(UIKit)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
            #else
            return nil
            #endif
        }
    }
    
    // MARK: - Icon Categories
    
    """
    
    // Generate category enums
    for (category, categoryIcons) in groupedIcons.sorted(by: { $0.key < $1.key }) {
        let enumName = category.replacingOccurrences(of: " ", with: "")
        swiftCode += """
        
        public extension GeneratedIcons {
            enum \(enumName): String, CaseIterable {
        """
        
        for icon in categoryIcons.sorted(by: { $0.name < $1.name }) {
            let caseName = icon.name.replacingOccurrences(of: "-", with: "_")
            swiftCode += """
            
                case \(caseName) = "\(icon.name)"
            """
        }
        
        swiftCode += """
        
                @available(iOS 13.0, macOS 10.15, *)
                public var image: Image? {
                    return GeneratedIcons.icon(named: self.rawValue)
                }
                
                public var uiImage: Any? {
                    return GeneratedIcons.uiImage(named: self.rawValue)
                }
            }
        }
        
        """
    }
    
    // Generate master enum with all icons
    swiftCode += """
    
    // MARK: - All Icons
    
    public extension GeneratedIcons {
        enum All: String, CaseIterable {
    """
    
    for icon in icons.sorted(by: { $0.name < $1.name }) {
        let caseName = icon.name.replacingOccurrences(of: "-", with: "_")
        swiftCode += """
        
            case \(caseName) = "\(icon.name)"
        """
    }
    
    swiftCode += """
    
            @available(iOS 13.0, macOS 10.15, *)
            public var image: Image? {
                return GeneratedIcons.icon(named: self.rawValue)
            }
            
            public var uiImage: Any? {
                return GeneratedIcons.uiImage(named: self.rawValue)
            }
            
            public var category: String {
                switch self {
    """
    
    for (category, categoryIcons) in groupedIcons {
        for icon in categoryIcons {
            let caseName = icon.name.replacingOccurrences(of: "-", with: "_")
            swiftCode += """
            
            case .\(caseName):
                return "\(category)"
            """
        }
    }
    
    swiftCode += """
    
                }
            }
        }
    }
    """
    
    try swiftCode.write(to: swiftFile, atomically: true, encoding: .utf8)
    print("✅ Generated Swift code with \(icons.count) icons in \(groupedIcons.count) categories")
}

// MARK: - Figma API Implementation

private func fetchIconsFromFigma(
    fileId: String,
    token: String,
    outputDirectory: URL,
    includeVariants: Bool,
    generateAssetCatalog: Bool,
    generateSwiftCode: Bool
) async throws -> [FigmaIconInfo] {
    print("🔄 Fetching icons from Figma file: \(fileId)")
    
    // First, get the file structure to find icon components
    let fileData = try await getFigmaFile(fileId: fileId, token: token)
    
    // Find all components that look like icons
    let iconComponents = findIconComponents(in: fileData)
    
    print("📱 Found \(iconComponents.count) icon components")
    
    // Download each icon
    var downloadedIcons: [FigmaIconInfo] = []
    
    for component in iconComponents {
        do {
            let iconInfo = try await downloadIcon(
                component: component,
                fileId: fileId,
                token: token,
                outputDirectory: outputDirectory
            )
            downloadedIcons.append(iconInfo)
            print("✅ Downloaded: \(iconInfo.name)")
        } catch {
            print("❌ Failed to download \(component.name): \(error.localizedDescription)")
        }
    }
    
    print("🎉 Icon download completed! Downloaded \(downloadedIcons.count) icons")
    return downloadedIcons
}

// MARK: - Figma API Data Models

struct FigmaFile: Codable {
    let document: FigmaDocument
    let components: [String: FigmaComponent]
}

struct FigmaDocument: Codable {
    let children: [FigmaNode]
}

struct FigmaNode: Codable {
    let id: String
    let name: String
    let type: String
    let children: [FigmaNode]?
}

struct FigmaComponent: Codable {
    let key: String
    let name: String
    let description: String?
    let nodeId: String
    
    enum CodingKeys: String, CodingKey {
        case key, name, description
        case nodeId = "node_id"
    }
}

struct FigmaIconInfo {
    let id: String
    let name: String
    let category: String
    let variant: String?
    let nodeId: String
    let filePath: String
    let size: CGSize
    let isComponent: Bool
    let thumbnailUrl: String?
    let description: String?
}

// MARK: - Figma API Methods
    
    private func getFigmaFile(fileId: String, token: String) async throws -> FigmaFile {
        let url = URL(string: "https://api.figma.com/v1/files/\(fileId)")!
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Figma-Token")
        
    let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw FigmaError.apiError("Failed to fetch Figma file")
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(FigmaFile.self, from: data)
    }
    
    private func findIconComponents(in file: FigmaFile) -> [FigmaComponent] {
        var iconComponents: [FigmaComponent] = []
        
        // Look for components that match icon naming patterns
        for (_, component) in file.components {
            let name = component.name.lowercased()
            
            // Check if it looks like an icon (starts with ic_ or contains icon keywords)
            if name.hasPrefix("ic_") || 
               name.contains("icon") || 
           name.contains("home") ||
           name.contains("search") ||
           name.contains("location") ||
           name.contains("map") ||
           name.contains("status") ||
           name.contains("nav") ||
           name.contains("ui") {
                iconComponents.append(component)
            }
        }
        
        return iconComponents
    }
    
    private func downloadIcon(
        component: FigmaComponent,
        fileId: String,
        token: String,
        outputDirectory: URL
    ) async throws -> FigmaIconInfo {
        // Step 1: Get image URL from Figma API
        let imageUrl = try await getFigmaImageUrl(
            fileId: fileId,
            nodeId: component.nodeId,
            token: token
        )
        
        // Step 2: Download the actual image from the URL
        let imageData = try await downloadImage(from: imageUrl)
        
        // Create asset name from component name
        let assetName = sanitizeAssetName(component.name)
        let category = determineCategory(from: component.name)
        let variant = determineVariant(from: component.name)
        
        // Create imageset directory
        let imagesetDir = outputDirectory.appendingPathComponent("\(assetName).imageset")
        try FileManager.default.createDirectory(at: imagesetDir, withIntermediateDirectories: true)
        
        // Save as PDF
        let fileName = "\(assetName).pdf"
        let fileUrl = imagesetDir.appendingPathComponent(fileName)
        try imageData.write(to: fileUrl)
        
        // Create Contents.json for the imageset
        let contents: [String: Any] = [
            "images": [
                [
                    "filename": fileName,
                    "idiom": "universal",
                    "scale": "1x"
                ]
            ],
            "info": [
                "author": "xcode",
                "version": 1
            ]
        ]
        
        let contentsData = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
        let contentsPath = imagesetDir.appendingPathComponent("Contents.json")
        try contentsData.write(to: contentsPath)
        
        return FigmaIconInfo(
            id: component.key,
            name: assetName,
            category: category,
            variant: variant,
            nodeId: component.nodeId,
            filePath: imagesetDir.path,
            size: CGSize(width: 32, height: 32),
            isComponent: true,
            thumbnailUrl: nil,
            description: component.description
        )
    }
    
    private func getFigmaImageUrl(fileId: String, nodeId: String, token: String) async throws -> String {
        let url = URL(string: "https://api.figma.com/v1/images/\(fileId)")!
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Figma-Token")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "ids", value: nodeId),
            URLQueryItem(name: "format", value: "pdf"),
            URLQueryItem(name: "scale", value: "1") // Standard resolution
        ]
        
        request.url = components.url
        
    let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw FigmaError.apiError("Failed to get image URL from Figma API")
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let images = json?["images"] as? [String: Any],
              let imageUrl = images[nodeId] as? String else {
            throw FigmaError.apiError("Invalid response from Figma API")
        }
        
        return imageUrl
    }
    
    private func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw FigmaError.invalidUrl
        }
        
    let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw FigmaError.downloadError("Failed to download image")
        }
        
        return data
    }
    
    private func sanitizeAssetName(_ name: String) -> String {
        // Convert to lowercase and replace spaces/special chars with underscores
        return name.lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .replacingOccurrences(of: ".", with: "_")
}

private func determineCategory(from name: String) -> String {
    let lowercased = name.lowercased()
    
    if lowercased.contains("map") || lowercased.contains("location") || lowercased.contains("pin") {
        return "Map"
    } else if lowercased.contains("status") || lowercased.contains("notification") || lowercased.contains("alert") {
        return "Status"
    } else if lowercased.contains("nav") || lowercased.contains("navigation") || lowercased.contains("ui") {
        return "Navigation"
    } else {
        return "General"
    }
}

private func determineVariant(from name: String) -> String? {
    let lowercased = name.lowercased()
    
    if lowercased.contains("filled") || lowercased.contains("solid") {
        return "filled"
    } else if lowercased.contains("outline") || lowercased.contains("stroke") || lowercased.contains("line") {
        return "outline"
    } else if lowercased.contains("dark") {
        return "dark"
    } else if lowercased.contains("light") {
        return "light"
    }
    
    return nil
}

enum FigmaError: Error, LocalizedError {
    case invalidUrl
    case apiError(String)
    case downloadError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid Figma URL"
        case .apiError(let message):
            return "Figma API Error: \(message)"
        case .downloadError(let message):
            return "Download Error: \(message)"
        }
    }
}


protocol FetchContext {
    var packageDirectory: Path { get }
    var pluginWorkDirectory: Path { get }
    func log(_ message: String)
}

extension PackagePlugin.PluginContext: FetchContext {
    var packageDirectory: Path { self.package.directory }
    func log(_ message: String) { Diagnostics.remark(message) }
}

#if canImport(XcodeProjectPlugin)
extension XcodeProjectPlugin.XcodePluginContext: FetchContext {
    var packageDirectory: Path { self.xcodeProject.directory }
    func log(_ message: String) { Diagnostics.remark(message) }
}
#endif

struct PluginError: Error, CustomStringConvertible {
    let description: String
    init(_ d: String) { description = d }
}
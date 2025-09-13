import Foundation
import PackagePlugin
#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
#endif

// MARK: - Data Models

struct IconInfo {
    let name: String
    let originalName: String
    let nodeId: String
    let filePath: String
}

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

// MARK: - Figma API Client (embedded in plugin)

class FigmaAPIClient {
    static let shared = FigmaAPIClient()
    
    private let session = URLSession.shared
    
    struct Config {
        let figmaToken: String
        let fileId: String
        let outputDirectory: URL
    }
    
    func fetchIconsFromFigma(config: Config) async throws -> [IconInfo] {
        print("🔄 Fetching icons from Figma file: \(config.fileId)")
        
        // First, get the file structure to find icon components
        let fileData = try await getFigmaFile(fileId: config.fileId, token: config.figmaToken)
        
        // Find all components that look like icons
        let iconComponents = findIconComponents(in: fileData)
        
        print("📱 Found \(iconComponents.count) icon components")
        
        // Download each icon
        var downloadedIcons: [IconInfo] = []
        
        for component in iconComponents {
            do {
                let iconInfo = try await downloadIcon(
                    component: component,
                    fileId: config.fileId,
                    token: config.figmaToken,
                    outputDirectory: config.outputDirectory
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
    
    private func getFigmaFile(fileId: String, token: String) async throws -> FigmaFile {
        let url = URL(string: "https://api.figma.com/v1/files/\(fileId)")!
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Figma-Token")
        
        let (data, response) = try await session.data(for: request)
        
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
               name.contains("social") ||
               name.contains("facebook") ||
               name.contains("twitter") ||
               name.contains("instagram") ||
               name.contains("linkedin") ||
               name.contains("home") {
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
    ) async throws -> IconInfo {
        // Get image URL from Figma API
        let imageUrl = try await getFigmaImageUrl(
            fileId: fileId,
            nodeId: component.nodeId,
            token: token
        )
        
        // Download the image
        let imageData = try await downloadImage(from: imageUrl)
        
        // Create asset name from component name
        let assetName = sanitizeAssetName(component.name)
        
        // Save as PNG
        let fileName = "\(assetName).png"
        let fileUrl = outputDirectory.appendingPathComponent(fileName)
        try imageData.write(to: fileUrl)
        
        return IconInfo(
            name: assetName,
            originalName: component.name,
            nodeId: component.nodeId,
            filePath: fileUrl.path
        )
    }
    
    private func getFigmaImageUrl(fileId: String, nodeId: String, token: String) async throws -> String {
        let url = URL(string: "https://api.figma.com/v1/images/\(fileId)")!
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Figma-Token")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "ids", value: nodeId),
            URLQueryItem(name: "format", value: "png"),
            URLQueryItem(name: "scale", value: "1")
        ]
        
        request.url = components.url
        
        let (data, response) = try await session.data(for: request)
        
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
        
        let (data, response) = try await session.data(from: url)
        
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
    }
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
    let iconsDir = packageDir.appending(subpath: "Sources/DesignAssets/Resources/Icons.xcassets/Icons")
    
    // Get Figma token from arguments or environment
    var figmaToken = ProcessInfo.processInfo.environment["FIGMA_PERSONAL_TOKEN"]
    var figmaFileId = ProcessInfo.processInfo.environment["FIGMA_FILE_ID"]
    
    // Parse arguments for token and file ID
    for (index, argument) in arguments.enumerated() {
        if argument == "--token" && index + 1 < arguments.count {
            figmaToken = arguments[index + 1]
        } else if argument == "--file-id" && index + 1 < arguments.count {
            figmaFileId = arguments[index + 1]
        }
    }
    
    guard let token = figmaToken, !token.isEmpty else {
        throw PluginError("FIGMA_PERSONAL_TOKEN not set. Set it in environment or pass --token")
    }
    
    guard let fileId = figmaFileId, !fileId.isEmpty else {
        throw PluginError("FIGMA_FILE_ID not set. Set it in environment or pass --file-id")
    }
    
    context.log("🔄 Fetching icons from Figma using API...")
    context.log("📁 File ID: \(fileId)")
    context.log("📂 Output directory: \(iconsDir)")
    
    // Create output directory if it doesn't exist
    try FileManager.default.createDirectory(at: URL(fileURLWithPath: iconsDir.string), withIntermediateDirectories: true)
    
    // Configure Figma API client
    let config = FigmaAPIClient.Config(
        figmaToken: token,
        fileId: fileId,
        outputDirectory: URL(fileURLWithPath: iconsDir.string)
    )
    
    do {
        // Fetch icons from Figma
        let icons = try await FigmaAPIClient.shared.fetchIconsFromFigma(config: config)
        
        // Generate Swift code for the icons
        try generateIconEnum(icons: icons, outputPath: packageDir.appending(subpath: "Sources/DesignAssets/DesignAssets.swift"))
        
        context.log("✅ Successfully fetched \(icons.count) icons from Figma!")
        
    } catch {
        context.log("❌ Error fetching icons: \(error.localizedDescription)")
        throw error
    }
}

private func generateIconEnum(icons: [IconInfo], outputPath: Path) throws {
    let iconCases = icons.map { icon in
        "    case \(icon.name) = \"\(icon.name)\""
    }.joined(separator: "\n")
    
    let swiftCode = """
import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(UIKit)
import UIKit
#endif

public struct DesignAssets {
    public static let bundle = Bundle.module

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

public extension DesignAssets {
    enum IconName: String, CaseIterable {
        // Icons fetched from Figma API
\(iconCases)

        @available(iOS 13.0, macOS 10.15, *)
        public var image: Image? {
            return DesignAssets.icon(named: self.rawValue)
        }

        public var uiImage: Any? {
            return DesignAssets.uiImage(named: self.rawValue)
        }
    }
}
"""
    
    try swiftCode.write(to: URL(fileURLWithPath: outputPath.string), atomically: true, encoding: .utf8)
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
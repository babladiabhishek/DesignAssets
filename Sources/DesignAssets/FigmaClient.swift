import Foundation

// MARK: - Enhanced Figma API Client

public class FigmaClient {
    public static let shared = FigmaClient()
    
    private let session = URLSession.shared
    private let baseURL = "https://api.figma.com/v1"
    
    public init() {}
    
    // MARK: - Configuration
    
    public struct Configuration {
        public let accessToken: String
        public let fileId: String
        public let outputDirectory: URL
        public let includeVariants: Bool
        public let generateAssetCatalog: Bool
        public let generateSwiftCode: Bool
        
        public init(
            accessToken: String,
            fileId: String,
            outputDirectory: URL,
            includeVariants: Bool = true,
            generateAssetCatalog: Bool = true,
            generateSwiftCode: Bool = true
        ) {
            self.accessToken = accessToken
            self.fileId = fileId
            self.outputDirectory = outputDirectory
            self.includeVariants = includeVariants
            self.generateAssetCatalog = generateAssetCatalog
            self.generateSwiftCode = generateSwiftCode
        }
    }
    
    // MARK: - Data Models
    
    public struct FigmaFile: Codable {
        public let document: FigmaDocument
        public let components: [String: FigmaComponent]
        public let styles: [String: FigmaStyle]?
        public let name: String
        public let lastModified: String
        public let version: String
    }
    
    public struct FigmaDocument: Codable {
        public let id: String
        public let name: String
        public let type: String
        public let children: [FigmaNode]
    }
    
    public struct FigmaNode: Codable {
        public let id: String
        public let name: String
        public let type: String
        public let children: [FigmaNode]?
        public let absoluteBoundingBox: FigmaBoundingBox?
        public let fills: [FigmaFill]?
        public let strokes: [FigmaStroke]?
        public let strokeWeight: Double?
        public let cornerRadius: Double?
        public let componentPropertyDefinitions: [String: FigmaComponentProperty]?
    }
    
    public struct FigmaBoundingBox: Codable {
        public let x: Double
        public let y: Double
        public let width: Double
        public let height: Double
    }
    
    public struct FigmaFill: Codable {
        public let type: String
        public let color: FigmaColor?
        public let opacity: Double?
    }
    
    public struct FigmaColor: Codable {
        public let r: Double
        public let g: Double
        public let b: Double
        public let a: Double
    }
    
    public struct FigmaStroke: Codable {
        public let type: String
        public let color: FigmaColor?
        public let opacity: Double?
    }
    
    public struct FigmaComponent: Codable {
        public let key: String
        public let name: String
        public let description: String?
        public let nodeId: String
        public let document: FigmaNode?
        public let thumbnailUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case key, name, description, document, thumbnailUrl
            case nodeId = "node_id"
        }
    }
    
    public struct FigmaStyle: Codable {
        public let key: String
        public let name: String
        public let description: String?
        public let styleType: String
        
        enum CodingKeys: String, CodingKey {
            case key, name, description
            case styleType = "style_type"
        }
    }
    
    public struct FigmaComponentProperty: Codable {
        public let type: String
        public let variantOptions: [String]?
        public let defaultValue: String?
    }
    
    public struct FigmaImageResponse: Codable {
        public let images: [String: String]
        public let status: Int?
        public let err: String?
    }
    
    // MARK: - Icon Information
    
    public struct IconInfo {
        public let id: String
        public let name: String
        public let category: String
        public let variant: String?
        public let nodeId: String
        public let filePath: String
        public let size: CGSize
        public let isComponent: Bool
        public let thumbnailUrl: String?
        public let description: String?
        
        public init(
            id: String,
            name: String,
            category: String,
            variant: String? = nil,
            nodeId: String,
            filePath: String,
            size: CGSize,
            isComponent: Bool = false,
            thumbnailUrl: String? = nil,
            description: String? = nil
        ) {
            self.id = id
            self.name = name
            self.category = category
            self.variant = variant
            self.nodeId = nodeId
            self.filePath = filePath
            self.size = size
            self.isComponent = isComponent
            self.thumbnailUrl = thumbnailUrl
            self.description = description
        }
    }
    
    // MARK: - Main Fetch Method
    
    public func fetchAllIcons(config: Configuration) async throws -> [IconInfo] {
        print("🚀 Starting comprehensive Figma icon fetch...")
        print("📁 File ID: \(config.fileId)")
        print("📂 Output: \(config.outputDirectory.path)")
        
        // Step 1: Get the complete file structure
        let figmaFile = try await getFigmaFile(fileId: config.fileId, token: config.accessToken)
        print("📄 Loaded file: \(figmaFile.name)")
        
        // Step 2: Discover all icon components and instances
        let iconComponents = discoverIconComponents(in: figmaFile)
        print("🔍 Found \(iconComponents.count) icon components")
        
        // Step 3: Find all icon instances in the document
        let iconInstances = discoverIconInstances(in: figmaFile.document)
        print("🎯 Found \(iconInstances.count) icon instances")
        
        // Step 4: Combine and organize icons
        let allIcons = organizeIcons(components: iconComponents, instances: iconInstances)
        print("📊 Organized into \(allIcons.count) unique icons")
        
        // Step 5: Download all icons
        let downloadedIcons = try await downloadAllIcons(
            icons: allIcons,
            fileId: config.fileId,
            token: config.accessToken,
            outputDirectory: config.outputDirectory
        )
        
        // Step 6: Generate asset catalog if requested
        if config.generateAssetCatalog {
            try await generateAssetCatalog(icons: downloadedIcons, outputDirectory: config.outputDirectory)
        }
        
        // Step 7: Generate Swift code if requested
        if config.generateSwiftCode {
            try await generateSwiftCode(icons: downloadedIcons, outputDirectory: config.outputDirectory)
        }
        
        print("✅ Successfully processed \(downloadedIcons.count) icons!")
        return downloadedIcons
    }
    
    // MARK: - File Fetching
    
    private func getFigmaFile(fileId: String, token: String) async throws -> FigmaFile {
        let url = URL(string: "\(baseURL)/files/\(fileId)")!
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Figma-Token")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FigmaError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw FigmaError.apiError("HTTP \(httpResponse.statusCode): \(errorMessage)")
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(FigmaFile.self, from: data)
    }
    
    // MARK: - Icon Discovery
    
    private func discoverIconComponents(in file: FigmaFile) -> [FigmaComponent] {
        var components: [FigmaComponent] = []
        
        for (_, component) in file.components {
            if isIconComponent(component) {
                components.append(component)
            }
        }
        
        return components.sorted { $0.name < $1.name }
    }
    
    private func discoverIconInstances(in document: FigmaDocument) -> [FigmaNode] {
        var instances: [FigmaNode] = []
        
        func traverse(_ node: FigmaNode) {
            if isIconInstance(node) {
                instances.append(node)
            }
            
            if let children = node.children {
                for child in children {
                    traverse(child)
                }
            }
        }
        
        // Traverse all children of the document
        for child in document.children {
            traverse(child)
        }
        return instances
    }
    
    private func isIconComponent(_ component: FigmaComponent) -> Bool {
        let name = component.name.lowercased()
        
        // Check for icon naming patterns
        let iconPatterns = [
            "icon", "ic_", "ui_", "nav_", "status_", "map_",
            "filled", "outline", "solid", "stroke", "line"
        ]
        
        return iconPatterns.contains { name.contains($0) } ||
               name.hasPrefix("ic_") ||
               name.contains("icon")
    }
    
    private func isIconInstance(_ node: FigmaNode) -> Bool {
        // Check if it's a component instance
        guard node.type == "INSTANCE" else { return false }
        
        let name = node.name.lowercased()
        
        // Check for icon naming patterns
        let iconPatterns = [
            "icon", "ic_", "ui_", "nav_", "status_", "map_",
            "filled", "outline", "solid", "stroke", "line"
        ]
        
        return iconPatterns.contains { name.contains($0) } ||
               name.hasPrefix("ic_") ||
               name.contains("icon")
    }
    
    // MARK: - Icon Organization
    
    private func organizeIcons(components: [FigmaComponent], instances: [FigmaNode]) -> [IconInfo] {
        var organizedIcons: [IconInfo] = []
        var processedNames: Set<String> = []
        
        // Process components first (these are the master icons)
        for component in components {
            let category = determineCategory(from: component.name)
            let variant = determineVariant(from: component.name)
            let size = estimateSize(from: component)
            
            let iconInfo = IconInfo(
                id: component.key,
                name: sanitizeName(component.name),
                category: category,
                variant: variant,
                nodeId: component.nodeId,
                filePath: "", // Will be set during download
                size: size,
                isComponent: true,
                thumbnailUrl: component.thumbnailUrl,
                description: component.description
            )
            
            organizedIcons.append(iconInfo)
            processedNames.insert(iconInfo.name)
        }
        
        // Process instances that aren't already covered by components
        for instance in instances {
            let category = determineCategory(from: instance.name)
            let variant = determineVariant(from: instance.name)
            let size = estimateSize(from: instance)
            let sanitizedName = sanitizeName(instance.name)
            
            if !processedNames.contains(sanitizedName) {
                let iconInfo = IconInfo(
                    id: instance.id,
                    name: sanitizedName,
                    category: category,
                    variant: variant,
                    nodeId: instance.id,
                    filePath: "", // Will be set during download
                    size: size,
                    isComponent: false,
                    description: nil
                )
                
                organizedIcons.append(iconInfo)
                processedNames.insert(sanitizedName)
            }
        }
        
        return organizedIcons.sorted { $0.name < $1.name }
    }
    
    private func determineCategory(from name: String) -> String {
        let lowercased = name.lowercased()
        
        if lowercased.contains("map") || lowercased.contains("location") || lowercased.contains("pin") {
            return "Map"
        } else if lowercased.contains("status") || lowercased.contains("notification") || lowercased.contains("alert") {
            return "Status"
        } else if lowercased.contains("nav") || lowercased.contains("navigation") || lowercased.contains("ui") {
            return "Navigation"
        } else if lowercased.contains("social") || lowercased.contains("facebook") || lowercased.contains("twitter") {
            return "Social"
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
    
    private func estimateSize(from component: FigmaComponent) -> CGSize {
        // Default size for icons
        return CGSize(width: 24, height: 24)
    }
    
    private func estimateSize(from node: FigmaNode) -> CGSize {
        if let boundingBox = node.absoluteBoundingBox {
            return CGSize(width: boundingBox.width, height: boundingBox.height)
        }
        
        // Default size for icons
        return CGSize(width: 24, height: 24)
    }
    
    private func sanitizeName(_ name: String) -> String {
        return name.lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ".", with: "_")
    }
    
    // MARK: - Icon Downloading
    
    private func downloadAllIcons(
        icons: [IconInfo],
        fileId: String,
        token: String,
        outputDirectory: URL
    ) async throws -> [IconInfo] {
        var downloadedIcons: [IconInfo] = []
        
        // Create category directories
        let categories = Set(icons.map { $0.category })
        for category in categories {
            let categoryDir = outputDirectory.appendingPathComponent(category)
            try FileManager.default.createDirectory(at: categoryDir, withIntermediateDirectories: true)
        }
        
        // Download icons in batches to avoid rate limiting
        let batchSize = 10
        for i in stride(from: 0, to: icons.count, by: batchSize) {
            let batch = Array(icons[i..<min(i + batchSize, icons.count)])
            
            await withTaskGroup(of: IconInfo?.self) { group in
                for icon in batch {
                    group.addTask {
                        do {
                            return try await self.downloadIcon(
                                icon: icon,
                                fileId: fileId,
                                token: token,
                                outputDirectory: outputDirectory
                            )
                        } catch {
                            print("❌ Failed to download \(icon.name): \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
                
                for await result in group {
                    if let downloadedIcon = result {
                        downloadedIcons.append(downloadedIcon)
                        print("✅ Downloaded: \(downloadedIcon.name)")
                    }
                }
            }
            
            // Small delay between batches to be respectful to the API
            if i + batchSize < icons.count {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            }
        }
        
        return downloadedIcons.sorted { $0.name < $1.name }
    }
    
    private func downloadIcon(
        icon: IconInfo,
        fileId: String,
        token: String,
        outputDirectory: URL
    ) async throws -> IconInfo {
        // Get image URL from Figma API
        let imageUrl = try await getFigmaImageUrl(
            fileId: fileId,
            nodeId: icon.nodeId,
            token: token
        )
        
        // Download the image
        let imageData = try await downloadImage(from: imageUrl)
        
        // Create file path
        let categoryDir = outputDirectory.appendingPathComponent(icon.category)
        let fileName = "\(icon.name).png"
        let fileUrl = categoryDir.appendingPathComponent(fileName)
        
        // Save the image
        try imageData.write(to: fileUrl)
        
        // Return updated icon info with file path
        return IconInfo(
            id: icon.id,
            name: icon.name,
            category: icon.category,
            variant: icon.variant,
            nodeId: icon.nodeId,
            filePath: fileUrl.path,
            size: icon.size,
            isComponent: icon.isComponent,
            thumbnailUrl: icon.thumbnailUrl,
            description: icon.description
        )
    }
    
    private func getFigmaImageUrl(fileId: String, nodeId: String, token: String) async throws -> String {
        let url = URL(string: "\(baseURL)/images/\(fileId)")!
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Figma-Token")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "ids", value: nodeId),
            URLQueryItem(name: "format", value: "png"),
            URLQueryItem(name: "scale", value: "2") // High resolution
        ]
        
        request.url = components.url
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw FigmaError.apiError("Failed to get image URL from Figma API")
        }
        
        let decoder = JSONDecoder()
        let imageResponse = try decoder.decode(FigmaImageResponse.self, from: data)
        
        guard let imageUrl = imageResponse.images[nodeId] else {
            throw FigmaError.apiError("No image URL returned for node \(nodeId)")
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
            throw FigmaError.downloadError("Failed to download image from \(urlString)")
        }
        
        return data
    }
    
    // MARK: - Asset Catalog Generation
    
    private func generateAssetCatalog(icons: [IconInfo], outputDirectory: URL) async throws {
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
        
        // Create image sets for each icon
        for icon in icons {
            let imageSetDir = assetCatalogDir.appendingPathComponent("\(icon.name).imageset")
            try FileManager.default.createDirectory(at: imageSetDir, withIntermediateDirectories: true)
            
            // Copy the PNG file
            let sourceFile = URL(fileURLWithPath: icon.filePath)
            let destFile = imageSetDir.appendingPathComponent("\(icon.name).png")
            try FileManager.default.copyItem(at: sourceFile, to: destFile)
            
            // Generate Contents.json for the image set
            let imageSetContents = """
            {
              "images" : [
                {
                  "filename" : "\(icon.name).png",
                  "idiom" : "universal",
                  "scale" : "1x"
                },
                {
                  "idiom" : "universal",
                  "scale" : "2x"
                },
                {
                  "idiom" : "universal",
                  "scale" : "3x"
                }
              ],
              "info" : {
                "author" : "xcode",
                "version" : 1
              }
            }
            """
            try imageSetContents.write(to: imageSetDir.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
        }
        
        print("✅ Generated asset catalog with \(icons.count) image sets")
    }
    
    // MARK: - Swift Code Generation
    
    private func generateSwiftCode(icons: [IconInfo], outputDirectory: URL) async throws {
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
}

// MARK: - Errors

public enum FigmaError: Error, LocalizedError {
    case invalidUrl
    case invalidResponse
    case apiError(String)
    case downloadError(String)
    case fileError(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid Figma URL"
        case .invalidResponse:
            return "Invalid response from Figma API"
        case .apiError(let message):
            return "Figma API Error: \(message)"
        case .downloadError(let message):
            return "Download Error: \(message)"
        case .fileError(let message):
            return "File Error: \(message)"
        }
    }
}

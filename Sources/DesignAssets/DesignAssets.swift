import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - DesignAssets Package

/// Main entry point for the DesignAssets package
public struct DesignAssets {
    
    // MARK: - Public API
    
    /// Fetch icons from Figma and integrate them into the package
    /// - Parameters:
    ///   - fileId: The Figma file ID
    ///   - token: Your Figma personal access token
    ///   - includeVariants: Whether to include different variants of icons
    ///   - generateAssetCatalog: Whether to generate Xcode asset catalog
    ///   - generateSwiftCode: Whether to generate Swift enum code
    /// - Returns: Array of fetched icon information
    @discardableResult
    public static func fetchIconsFromFigma(
        fileId: String,
        token: String,
        includeVariants: Bool = true,
        generateAssetCatalog: Bool = true,
        generateSwiftCode: Bool = true
    ) async throws -> [FigmaIconInfo] {
        
        // This is a placeholder - in a real implementation, this would:
        // 1. Call the Figma API
        // 2. Download images
        // 3. Generate asset catalogs
        // 4. Generate Swift code
        
        print("🚀 DesignAssets: Use the build script to fetch icons!")
        print("Run: ./Scripts/fetch-icons.sh")
        
        return []
    }
    
    // MARK: - Available Icons
    
    /// Get all available icon names
    public static var availableIconNames: [String] {
        // Return a sample of available icon names
        return [
            "ic_light_bulb_default_32",
            "ic_search_default_32", 
            "ic_home_default_32",
            "ic_location_default_32",
            "ic_status_success_20"
        ]
    }
    
    /// Get all available icon categories
    public static var iconCategories: [String] {
        return ["General", "Map", "Navigation", "Status"]
    }
    
    // MARK: - Build Integration
    
    /// Check if icons need to be refreshed
    public static var needsIconRefresh: Bool {
        // Check if the last fetch was more than 24 hours ago
        let lastFetchFile = URL(fileURLWithPath: "Sources/DesignAssets/Resources/.last-fetch")
        
        guard let lastFetchData = try? Data(contentsOf: lastFetchFile),
              let lastFetch = try? JSONDecoder().decode(Date.self, from: lastFetchData) else {
            return true
        }
        
        return Date().timeIntervalSince(lastFetch) > 86400 // 24 hours
    }
    
    /// Mark icons as refreshed
    public static func markIconsRefreshed() {
        let lastFetchFile = URL(fileURLWithPath: "Sources/DesignAssets/Resources/.last-fetch")
        let data = try? JSONEncoder().encode(Date())
        try? data?.write(to: lastFetchFile)
    }
}

// MARK: - Figma Integration Types

public struct FigmaIconInfo {
    public let id: String
    public let name: String
    public let category: String
    public let variant: String
    public let nodeId: String
    public let filePath: String
    public let size: CGSize
    public let isComponent: Bool
    public let thumbnailUrl: String?
    public let description: String
    
    public init(
        id: String,
        name: String,
        category: String,
        variant: String,
        nodeId: String,
        filePath: String,
        size: CGSize,
        isComponent: Bool,
        thumbnailUrl: String?,
        description: String
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
import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - DesignAssets Package

/// Main entry point for the DesignAssets package
public struct DesignAssets {
    
    // MARK: - Public API
    
        /// Get all available icon names
        public static var availableIconNames: [String] {
            return GeneratedIcons.allIcons
        }

        /// Get all available icon categories
        public static var iconCategories: [String] {
            return GeneratedIcons.categories
        }
    
    /// Get all available icon layers
    public static var iconLayers: [String] {
        return ["FeelgoodIcons", "MapIcons", "StatusIcons", "GeneralIcons"]
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
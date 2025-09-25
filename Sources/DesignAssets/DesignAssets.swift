// DesignAssets - Supercharged Figma Integration
// A comprehensive Swift Package for dynamic icon management from Figma files

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(UIKit)
import UIKit
#endif

// MARK: - DesignAssets

public struct DesignAssets {
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
    
    // MARK: - Smart Appearance-Based Icon Access
    
    /// Returns the appropriate icon variant based on the current appearance (dark/light mode)
    @available(iOS 13.0, macOS 10.15, *)
    public static func adaptiveIcon(named baseName: String, in colorScheme: ColorScheme? = nil) -> Image? {
        #if canImport(SwiftUI)
        let isDarkMode: Bool
        if let colorScheme = colorScheme {
            isDarkMode = colorScheme == .dark
        } else {
            #if canImport(UIKit)
            isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
            #else
            isDarkMode = false
            #endif
        }
        
        let iconName = isDarkMode ? "\(baseName)_negative" : "\(baseName)_original"
        return Image(iconName, bundle: bundle)
        #else
        return nil
        #endif
    }
    
    /// Returns the appropriate UIImage variant based on the current appearance (dark/light mode)
    public static func adaptiveUIImage(named baseName: String, in traitCollection: Any? = nil) -> Any? {
        #if canImport(UIKit)
        let isDarkMode: Bool
        if let traitCollection = traitCollection as? UITraitCollection {
            isDarkMode = traitCollection.userInterfaceStyle == .dark
        } else {
            isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        }
        
        let iconName = isDarkMode ? "\(baseName)_negative" : "\(baseName)_original"
        return UIImage(named: iconName, in: bundle, compatibleWith: nil)
        #else
        return nil
        #endif
    }
}

// MARK: - Figma Integration

public extension DesignAssets {
    /// Fetches icons from a Figma file using the provided configuration
    /// This is a convenience method that uses the FigmaClient
    @available(iOS 13.0, macOS 10.15, *)
    static func fetchIconsFromFigma(
        fileId: String,
        accessToken: String,
        outputDirectory: URL? = nil,
        includeVariants: Bool = true,
        generateAssetCatalog: Bool = true,
        generateSwiftCode: Bool = true
    ) async throws -> [FigmaClient.IconInfo] {
        let config = FigmaClient.Configuration(
            accessToken: accessToken,
            fileId: fileId,
            outputDirectory: outputDirectory ?? URL(fileURLWithPath: NSTemporaryDirectory()),
            includeVariants: includeVariants,
            generateAssetCatalog: generateAssetCatalog,
            generateSwiftCode: generateSwiftCode
        )
        
        return try await FigmaClient.shared.fetchAllIcons(config: config)
    }
}

// MARK: - Icon Utilities

public extension DesignAssets {
    /// Returns all available icon names from the bundle
    static var availableIconNames: [String] {
        guard let resourcePath = bundle.resourcePath else { return [] }
        let resourceURL = URL(fileURLWithPath: resourcePath)
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)
            return contents
                .filter { $0.pathExtension == "png" || $0.pathExtension == "pdf" }
                .map { $0.deletingPathExtension().lastPathComponent }
                .sorted()
        } catch {
            return []
        }
    }
    
    /// Returns icons grouped by category (if using generated icons)
    static var iconCategories: [String: [String]] {
        let icons = availableIconNames
        var categories: [String: [String]] = [:]
        
        for iconName in icons {
            let category: String
            if iconName.contains("map") || iconName.contains("location") {
                category = "Map"
            } else if iconName.contains("status") || iconName.contains("notification") {
                category = "Status"
            } else if iconName.contains("nav") || iconName.contains("ui") {
                category = "Navigation"
            } else if iconName.contains("social") {
                category = "Social"
            } else {
                category = "General"
            }
            
            if categories[category] == nil {
                categories[category] = []
            }
            categories[category]?.append(iconName)
        }
        
        return categories
    }
}
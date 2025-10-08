import Foundation

/// DesignAssets - A clean, lightweight Swift Package Manager package for consuming design assets from Figma
public struct DesignAssets {
    /// The bundle containing the design assets
    public static let bundle: Bundle = {
        #if canImport(Foundation)
        return Bundle(for: BundleToken.self)
        #else
        return Bundle.main
        #endif
    }()
    
    /// Initialize the DesignAssets package
    public init() {}
}

// MARK: - Generated Icons Support

/// Placeholder for generated icons - will be populated by the GenerateEnumsPlugin
public enum GeneratedIcons {
    /// The bundle containing the icon assets
    public static let bundle: Bundle = {
        #if canImport(Foundation)
        return Bundle(for: BundleToken.self)
        #else
        return Bundle.main
        #endif
    }()
    
    /// All available icon names (will be populated by plugin)
    public static var allIcons: [String] {
        return []
    }
    
    /// All available categories (will be populated by plugin)
    public static var categories: [String] {
        return []
    }
    
    /// Total number of icons (will be populated by plugin)
    public static var totalIconCount: Int {
        return allIcons.count
    }
}

// MARK: - Bundle Token

private final class BundleToken {}

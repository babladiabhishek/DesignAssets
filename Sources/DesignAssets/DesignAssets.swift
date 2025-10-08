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

// MARK: - Bundle Token

private final class BundleToken {}

import SwiftUI
import DesignAssets

struct BundleInfoView: View {
    @State private var bundleInfo: BundleInfo?
    
    struct BundleInfo {
        let bundleIdentifier: String?
        let bundlePath: String
        let resourcePath: String?
        let iconCount: Int
        let catalogs: [String]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let info = bundleInfo {
                    // Bundle Overview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📦 Bundle Overview")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        InfoRow(label: "Bundle ID", value: info.bundleIdentifier ?? "Not available")
                        InfoRow(label: "Bundle Path", value: info.bundlePath)
                        InfoRow(label: "Resource Path", value: info.resourcePath ?? "Not available")
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Icon Statistics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📊 Icon Statistics")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        InfoRow(label: "Total Icons", value: "\(info.iconCount)")
                        InfoRow(label: "Icon Catalogs", value: "\(info.catalogs.count)")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Available Catalogs:")
                                .font(.headline)
                            
                            ForEach(info.catalogs, id: \.self) { catalog in
                                HStack {
                                    Image(systemName: "folder")
                                        .foregroundColor(.blue)
                                    Text(catalog)
                                        .font(.caption)
                                }
                                .padding(.leading, 16)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Icon Name Statistics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🎨 Icon Name Statistics")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        let allIcons = DesignAssets.IconName.allCases
                        let originalIcons = allIcons.filter { $0.rawValue.contains("_original") }
                        let negativeIcons = allIcons.filter { $0.rawValue.contains("_negative") }
                        let uniquePlatforms = Set(allIcons.map { $0.baseName })
                        
                        InfoRow(label: "Total Icon Names", value: "\(allIcons.count)")
                        InfoRow(label: "Original Variants", value: "\(originalIcons.count)")
                        InfoRow(label: "Negative Variants", value: "\(negativeIcons.count)")
                        InfoRow(label: "Unique Platforms", value: "\(uniquePlatforms.count)")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Platforms:")
                                .font(.headline)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 4) {
                                ForEach(Array(uniquePlatforms).sorted(), id: \.self) { platform in
                                    Text(platform)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Social Media Icons Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("👥 Social Media Icons")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        let socialIcons = SocialMediaIcons.allIcons
                        let platforms = Set(socialIcons.map { $0.platform })
                        
                        InfoRow(label: "Total Social Icons", value: "\(socialIcons.count)")
                        InfoRow(label: "Platforms", value: "\(platforms.count)")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Available Platforms:")
                                .font(.headline)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 4) {
                                ForEach(Array(platforms).sorted(), id: \.self) { platform in
                                    Text(platform)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                } else {
                    ProgressView("Loading bundle information...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
        }
        .navigationTitle("Bundle Information")
        .navigationSubtitle("DesignAssets package details")
        .onAppear {
            loadBundleInfo()
        }
    }
    
    private func loadBundleInfo() {
        let bundle = Bundle.main
        let fileManager = FileManager.default
        
        var catalogs: [String] = []
        var iconCount = 0
        
        // Try to find the DesignAssets bundle
        let bundlePath = bundle.bundlePath
        let designAssetsBundlePath = "\(bundlePath)/DesignAssets_DesignAssets.bundle"
        
        if fileManager.fileExists(atPath: designAssetsBundlePath) {
            if let designAssetsBundle = Bundle(path: designAssetsBundlePath) {
                if let resourcePath = designAssetsBundle.resourcePath {
                    do {
                        let contents = try fileManager.contentsOfDirectory(atPath: resourcePath)
                        catalogs = contents.filter { $0.hasSuffix(".xcassets") }
                        
                        // Count icons in Icons.xcassets
                        if let iconsPath = catalogs.first(where: { $0 == "Icons.xcassets" }) {
                            let fullIconsPath = "\(resourcePath)/\(iconsPath)"
                            let iconContents = try fileManager.contentsOfDirectory(atPath: fullIconsPath)
                            iconCount = iconContents.filter { $0.hasSuffix(".imageset") }.count
                        }
                    } catch {
                        print("Error reading bundle contents: \(error)")
                    }
                }
                
                bundleInfo = BundleInfo(
                    bundleIdentifier: designAssetsBundle.bundleIdentifier,
                    bundlePath: designAssetsBundle.bundlePath,
                    resourcePath: designAssetsBundle.resourcePath,
                    iconCount: iconCount,
                    catalogs: catalogs
                )
                return
            }
        }
        
        // Fallback to main bundle
        bundleInfo = BundleInfo(
            bundleIdentifier: bundle.bundleIdentifier,
            bundlePath: bundle.bundlePath,
            resourcePath: bundle.resourcePath,
            iconCount: iconCount,
            catalogs: catalogs
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(.body, design: .monospaced))
        }
    }
}

#Preview {
    BundleInfoView()
}

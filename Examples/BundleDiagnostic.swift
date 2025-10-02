import SwiftUI
import DesignAssets

@main
struct BundleDiagnostic: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Bundle Diagnostic")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Bundle.designAssets path: \(Bundle.designAssets.bundlePath)")
                
                // List all contents of the bundle
                if let resourcePath = Bundle.designAssets.resourcePath {
                    Text("Bundle contents:")
                    if let contents = try? FileManager.default.contentsOfDirectory(atPath: resourcePath) {
                        ForEach(contents, id: \.self) { item in
                            Text("• \(item)")
                        }
                    }
                }
                
                // Check if we can find the asset catalog
                if let statusIconsPath = Bundle.designAssets.path(forResource: "StatusIcons", ofType: "xcassets") {
                    Text("✅ Found StatusIcons.xcassets at: \(statusIconsPath)")
                    
                    // List contents of StatusIcons.xcassets
                    if let statusContents = try? FileManager.default.contentsOfDirectory(atPath: statusIconsPath) {
                        Text("StatusIcons contents:")
                        ForEach(statusContents, id: \.self) { item in
                            Text("  • \(item)")
                        }
                    }
                } else {
                    Text("❌ Could not find StatusIcons.xcassets")
                }
                
                // Try to find the specific imageset
                if let imagesetPath = Bundle.designAssets.path(forResource: "ic_status_success_16", ofType: "imageset") {
                    Text("✅ Found ic_status_success_16.imageset at: \(imagesetPath)")
                } else {
                    Text("❌ Could not find ic_status_success_16.imageset")
                }
            }
            .font(.caption)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
    }
}

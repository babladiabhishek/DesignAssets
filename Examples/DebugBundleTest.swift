import SwiftUI
import DesignAssets

@main
struct DebugBundleTest: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Bundle Debug Test")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Bundle.designAssets path: \(Bundle.designAssets.bundlePath)")
                
                // Test if we can find the resource
                if let path = Bundle.designAssets.path(forResource: "ic_status_success_16", ofType: "pdf") {
                    Text("✅ Found ic_status_success_16.pdf at: \(path)")
                } else {
                    Text("❌ Could not find ic_status_success_16.pdf")
                }
                
                // List all resources in designAssets bundle
                if let resourcePath = Bundle.designAssets.resourcePath {
                    Text("DesignAssets resources at: \(resourcePath)")
                    if let contents = try? FileManager.default.contentsOfDirectory(atPath: resourcePath) {
                        Text("Contents: \(contents.joined(separator: ", "))")
                    }
                }
            }
            .font(.caption)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Test the actual icon
            VStack {
                Text("Test Icon:")
                GeneratedIcons.ic_status_success_16.image
                    .resizable()
                    .frame(width: 32, height: 32)
                    .background(Color.red.opacity(0.3))
            }
        }
        .padding()
    }
}

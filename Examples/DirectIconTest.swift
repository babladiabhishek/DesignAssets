import SwiftUI
import DesignAssets
#if canImport(UIKit)
import UIKit
#endif

@main
struct DirectIconTest: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Direct Icon Test")
                .font(.title)
            
            VStack(spacing: 10) {
                Text("1. Direct UIImage test:")
                #if canImport(UIKit)
                if let uiImage = UIImage(named: "ic_status_success_16", in: Bundle.designAssets, compatibleWith: nil) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.green.opacity(0.3))
                    Text("✅ UIImage loaded successfully")
                } else {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 32, height: 32)
                    Text("❌ UIImage failed to load")
                }
                #else
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 32, height: 32)
                Text("UIKit not available")
                #endif
                
                Text("2. GeneratedIcons test:")
                GeneratedIcons.ic_status_success_16.image
                    .resizable()
                    .frame(width: 32, height: 32)
                    .background(Color.blue.opacity(0.3))
                
                Text("3. Direct Image with bundle:")
                Image("ic_status_success_16", bundle: Bundle.designAssets)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .background(Color.yellow.opacity(0.3))
                
                Text("4. System icon (control):")
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

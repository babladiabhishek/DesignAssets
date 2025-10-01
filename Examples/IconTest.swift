import SwiftUI
import DesignAssets

@main
struct IconTest: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 20) {
                Text("Icon Test")
                    .font(.title)
                
                // Test different ways to load icons
                VStack(spacing: 10) {
                    Text("Direct Image from StatusIcons:")
                    Image("ic_status_success_16")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.red.opacity(0.3))
                    
                    Text("GeneratedIcons.image:")
                    GeneratedIcons.ic_status_success_16.image
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.blue.opacity(0.3))
                    
                    Text("System Image (should work):")
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.yellow)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

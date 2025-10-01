import SwiftUI
import DesignAssets

@main
struct IconDebugTest: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 20) {
                Text("Icon Debug Test")
                    .font(.title)
                
                VStack(spacing: 10) {
                    Text("Testing different ways to load icons:")
                    
                    // Test 1: Direct from StatusIcons catalog
                    VStack {
                        Text("1. Direct from StatusIcons:")
                        Image("ic_status_success_16")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .background(Color.red.opacity(0.3))
                    }
                    
                    // Test 2: GeneratedIcons approach
                    VStack {
                        Text("2. GeneratedIcons.image:")
                        GeneratedIcons.ic_status_success_16.image
                            .resizable()
                            .frame(width: 32, height: 32)
                            .background(Color.blue.opacity(0.3))
                    }
                    
                    // Test 3: System icon (should work)
                    VStack {
                        Text("3. System icon (control):")
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

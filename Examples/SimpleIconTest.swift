import SwiftUI
import DesignAssets

@main
struct SimpleIconTest: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Simple Icon Test")
                .font(.title)
            
            VStack(spacing: 10) {
                Text("1. Direct from Icons.xcassets:")
                Image("ic_status_success_16")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .background(Color.red.opacity(0.3))
                
                Text("2. GeneratedIcons approach:")
                GeneratedIcons.ic_status_success_16.image
                    .resizable()
                    .frame(width: 32, height: 32)
                    .background(Color.blue.opacity(0.3))
                
                Text("3. Map pin icon:")
                Image("map_pin_single_default")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .background(Color.green.opacity(0.3))
                
                Text("4. Light bulb icon:")
                Image("ic_light_bulb_default_32")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .background(Color.yellow.opacity(0.3))
            }
        }
        .padding()
    }
}

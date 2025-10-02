import SwiftUI
import DesignAssets

@main
struct SwiftGenTest: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("SwiftGen Assets Test")
                .font(.title)
            
            VStack(spacing: 15) {
                Text("1. Status Icons:")
                HStack(spacing: 10) {
                    Image(asset: GeneratedAssets.StatusIcons.icStatusSuccess16)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.green.opacity(0.3))
                    
                    Image(asset: GeneratedAssets.StatusIcons.icStatusAlert16)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.red.opacity(0.3))
                }
                
                Text("2. Map Icons:")
                HStack(spacing: 10) {
                    Image(asset: GeneratedAssets.MapIcons.mapPinSingleDefault)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.blue.opacity(0.3))
                    
                    Image(asset: GeneratedAssets.MapIcons.icOrderDelivery32)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.orange.opacity(0.3))
                }
                
                Text("3. Feel Good Icons:")
                HStack(spacing: 10) {
                    Image(asset: GeneratedAssets.FeelGoodIcons.icLightBulbDefault32)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.yellow.opacity(0.3))
                    
                    Image(asset: GeneratedAssets.FeelGoodIcons.icSearchDefault32)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.purple.opacity(0.3))
                }
                
                Text("4. System Icon (control):")
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

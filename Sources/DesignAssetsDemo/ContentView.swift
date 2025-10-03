import SwiftUI
import DesignAssets

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var colorScheme: ColorScheme = .light
    
    var body: some View {
        HSplitView {
            // Sidebar
            VStack(alignment: .leading, spacing: 0) {
                Text("DesignAssets Demo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: { selectedTab = 0 }) {
                        HStack {
                            Image(systemName: "person.2")
                            Text("Social Media Icons")
                        }
                        .foregroundColor(selectedTab == 0 ? .accentColor : .primary)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { selectedTab = 1 }) {
                        HStack {
                            Image(systemName: "circle.lefthalf.filled")
                            Text("Adaptive Icons")
                        }
                        .foregroundColor(selectedTab == 1 ? .accentColor : .primary)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { selectedTab = 2 }) {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                            Text("All Icons")
                        }
                        .foregroundColor(selectedTab == 2 ? .accentColor : .primary)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { selectedTab = 3 }) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("Bundle Info")
                        }
                        .foregroundColor(selectedTab == 3 ? .accentColor : .primary)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                
                Spacer()
                
                Divider()
                
                HStack {
                    Button(action: {
                        colorScheme = colorScheme == .light ? .dark : .light
                    }) {
                        Image(systemName: colorScheme == .light ? "moon.fill" : "sun.max.fill")
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding()
            }
            .frame(width: 200)
            .background(Color.secondary.opacity(0.1))
            
            // Main content
            Group {
                switch selectedTab {
                case 0:
                    SocialMediaIconsView()
                case 1:
                    AdaptiveIconsView(colorScheme: $colorScheme)
                case 2:
                    AllIconsView()
                case 3:
                    BundleInfoView()
                default:
                    SocialMediaIconsView()
                }
            }
            .preferredColorScheme(colorScheme)
        }
    }
}


#Preview {
    ContentView()
}

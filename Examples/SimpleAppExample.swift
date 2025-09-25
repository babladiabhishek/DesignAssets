import SwiftUI
import DesignAssets

/// Simple example showing the minimum code needed to use DesignAssets in an app
struct SimpleAppExample: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("My App")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Simple icon usage
            HStack(spacing: 20) {
                GeneratedIcons.search_filled_32.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                GeneratedIcons.map_filled_32.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)
                
                GeneratedIcons.status_success_20.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)
            }
            
            Text("Icons from Figma!")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

/// Complete app structure example
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    GeneratedIcons.home_filled_32.image
                    Text("Home")
                }
            
            SearchView()
                .tabItem {
                    GeneratedIcons.search_filled_32.image
                    Text("Search")
                }
            
            ProfileView()
                .tabItem {
                    GeneratedIcons.person_filled_32.image
                    Text("Profile")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to My App!")
                    .font(.title)
                
                HStack(spacing: 30) {
                    VStack {
                        GeneratedIcons.play_filled.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        Text("Play")
                    }
                    
                    VStack {
                        GeneratedIcons.pause_filled.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)
                        Text("Pause")
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct SearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Search View")
                    .font(.title)
                
                GeneratedIcons.search_filled_32.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            .navigationTitle("Search")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile View")
                    .font(.title)
                
                GeneratedIcons.person_filled_32.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    SimpleAppExample()
}

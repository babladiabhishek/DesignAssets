import SwiftUI
import DesignAssets

/// Complete example showing how to use DesignAssets SPM in a real app
struct AppUsageExample: View {
    @State private var selectedIcon: GeneratedIcons = .search_default_32
    @State private var selectedCategory: String = "General"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("My App with Figma Icons")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Using DesignAssets SPM Package")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Current Icon Display
                VStack(spacing: 16) {
                    Text("Selected Icon")
                        .font(.headline)
                    
                    selectedIcon.image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    VStack(spacing: 4) {
                        Text(selectedIcon.imageName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("\(selectedIcon.category) • \(selectedIcon.variant)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                // Category Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.headline)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Array(GeneratedIcons.categories.keys.sorted()), id: \.self) { category in
                            Text(category)
                                .tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Icons Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(GeneratedIcons.categories[selectedCategory] ?? [], id: \.self) { icon in
                            Button(action: {
                                selectedIcon = icon
                            }) {
                                VStack(spacing: 8) {
                                    icon.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(selectedIcon == icon ? .white : .primary)
                                    
                                    Text(icon.imageName)
                                        .font(.caption2)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .foregroundColor(selectedIcon == icon ? .white : .primary)
                                }
                                .padding(8)
                                .background(selectedIcon == icon ? Color.blue : Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("My App")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Real App Examples

/// Example 1: Navigation Bar with Icons
struct NavigationExample: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Search")) {
                    HStack {
                        GeneratedIcons.search_filled_32.image?
                            .foregroundColor(.blue)
                        Text("Search")
                    }
                }
                
                NavigationLink(destination: Text("Map")) {
                    HStack {
                        GeneratedIcons.map_filled_32.image?
                            .foregroundColor(.green)
                        Text("Map")
                    }
                }
                
                NavigationLink(destination: Text("Settings")) {
                    HStack {
                        GeneratedIcons.settings_filled_32.image?
                            .foregroundColor(.gray)
                        Text("Settings")
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}

/// Example 2: Tab Bar with Icons
struct TabBarExample: View {
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

/// Example 3: Button with Icons
struct ButtonExample: View {
    @State private var isPlaying = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Play/Pause Button
            Button(action: {
                isPlaying.toggle()
            }) {
                HStack {
                    (isPlaying ? GeneratedIcons.pause_filled : GeneratedIcons.play_filled)?.image
                        .foregroundColor(.white)
                    Text(isPlaying ? "Pause" : "Play")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
            
            // Action Buttons
            HStack(spacing: 16) {
                Button(action: {}) {
                    VStack {
                        GeneratedIcons.heart_filled_32.image?
                            .foregroundColor(.red)
                        Text("Like")
                            .font(.caption)
                    }
                }
                
                Button(action: {}) {
                    VStack {
                        GeneratedIcons.share_filled_32.image?
                            .foregroundColor(.blue)
                        Text("Share")
                            .font(.caption)
                    }
                }
                
                Button(action: {}) {
                    VStack {
                        GeneratedIcons.bookmark_filled_32.image?
                            .foregroundColor(.orange)
                        Text("Save")
                            .font(.caption)
                    }
                }
            }
        }
    }
}

/// Example 4: Status Indicators
struct StatusExample: View {
    var body: some View {
        VStack(spacing: 16) {
            // Success Status
            HStack {
                GeneratedIcons.status_success_20.image?
                    .foregroundColor(.green)
                Text("Operation completed successfully")
                    .foregroundColor(.green)
            }
            
            // Warning Status
            HStack {
                GeneratedIcons.status_alert_20.image?
                    .foregroundColor(.orange)
                Text("Please check your input")
                    .foregroundColor(.orange)
            }
            
            // Error Status
            HStack {
                GeneratedIcons.status_blocker_20.image?
                    .foregroundColor(.red)
                Text("Something went wrong")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

// MARK: - Helper Views
struct HomeView: View {
    var body: some View {
        Text("Home View")
            .navigationTitle("Home")
    }
}

struct SearchView: View {
    var body: some View {
        Text("Search View")
            .navigationTitle("Search")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .navigationTitle("Profile")
    }
}

// MARK: - Preview
#Preview {
    AppUsageExample()
}

#Preview("Navigation Example") {
    NavigationExample()
}

#Preview("Tab Bar Example") {
    TabBarExample()
}

#Preview("Button Example") {
    ButtonExample()
}

#Preview("Status Example") {
    StatusExample()
}

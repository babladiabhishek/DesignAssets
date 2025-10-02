import SwiftUI
import DesignAssets

// MARK: - Helper Functions
private func loadCustomIcon(_ icon: GeneratedIcons) -> Image {
    // Load the custom icon directly from the asset catalogs
    return icon.image
}

// MARK: - Main App
@main
struct OrganizedIconsDemo: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // All Icons View
            AllIconsView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("All Icons")
                }
                .tag(0)
            
            // Category Picker View
            CategoryPickerView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Categories")
                }
                .tag(1)
            
            // Usage Examples View
            UsageExamplesView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Examples")
                }
                .tag(2)
        }
    }
}

// MARK: - All Icons View
struct AllIconsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Info banner
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🎨 Custom Icons Demo")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text("This demo shows the organized icon structure using the actual custom icons from Figma. Icons are organized by category for better performance and maintenance.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    LazyVStack(spacing: 20) {
                        // Status Icons Section
                        IconCategorySection(
                            title: "Status Icons (12x12, 16x16, 20x20)",
                            icons: getStatusIcons(),
                            color: .blue
                        )
                        
                        // Map Icons Section
                        IconCategorySection(
                            title: "Map Icons (Order Location)",
                            icons: getMapIcons(),
                            color: .green
                        )
                        
                        // Feel Good Icons Section
                        IconCategorySection(
                            title: "Feel Good Icons (Filled/Outline)",
                            icons: getFeelGoodIcons(),
                            color: .orange
                        )
                        
                        // General Icons Section (showing first 20 for performance)
                        IconCategorySection(
                            title: "General Icons (Sample)",
                            icons: getGeneralIcons(),
                            color: .purple
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Organized Icons")
        }
    }
    
    private func getStatusIcons() -> [GeneratedIcons] {
        return [
            .ic_status_success_16,
            .ic_status_alert_16,
            .ic_status_info_16,
            .ic_status_blocker_16,
            .ic_status_success_20,
            .ic_status_alert_20,
            .ic_status_info_20,
            .ic_status_blocker_20
        ]
    }
    
    private func getMapIcons() -> [GeneratedIcons] {
        return [
            .map_pin_single_default,
            .ic_order_delivery_32,
            .ic_order_location_32,
            .ic_map_default_32,
            .ic_delivery_instructions_default_32
        ]
    }
    
    private func getFeelGoodIcons() -> [GeneratedIcons] {
        return [
            .ic_light_bulb_default_32,
            .ic_search_default_32,
            .ic_play_default,
            .ic_pause_default,
            .ic_refresh_default_32,
            .ic_playground_default_32
        ]
    }
    
    private func getGeneralIcons() -> [GeneratedIcons] {
        return [
            .ic_hamburger_default_32,
            .ic_trash_default_32,
            .ic_voice_default_32,
            .ic_payment_default_32,
            .ic_restaurant_default_32,
            .ic_time_default_32,
            .ic_wi_fi_default_32,
            .ic_qr_code_default_32
        ]
    }
}

// MARK: - Category Picker View
struct CategoryPickerView: View {
    @State private var selectedCategory = "Status"
    @State private var selectedIcon: String = ""
    
    let categories = ["Status", "Map", "FeelGood", "General"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Category Picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Icons Grid
                ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                            ForEach(Array(iconsForCategory(selectedCategory).enumerated()), id: \.offset) { index, icon in
                                Button(action: {
                                    selectedIcon = "\(icon)"
                                }) {
                                    VStack(spacing: 4) {
                                        // Show custom icon from asset catalogs
                                        loadCustomIcon(icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(iconColor(for: selectedCategory))
                                        
                                        Text(verbatim: "You have \(icon) items") // ✅ no warning
                                            .font(.caption2)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                    }
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedIcon == "\(icon)" ? Color.blue : Color.gray.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    .padding()
                }
                
                // Selected Icon Info
                if !selectedIcon.isEmpty {
                    VStack {
                        Text("Selected:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(selectedIcon)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Category Picker")
        }
    }
    
    private func iconsForCategory(_ category: String) -> [GeneratedIcons] {
        switch category {
        case "Status":
            return [
                .ic_status_success_16,
                .ic_status_alert_16,
                .ic_status_info_16,
                .ic_status_blocker_16,
                .ic_status_success_20,
                .ic_status_alert_20,
                .ic_status_info_20,
                .ic_status_blocker_20
            ]
        case "Map":
            return [
                .map_pin_single_default,
                .ic_order_delivery_32,
                .ic_order_location_32,
                .ic_map_default_32,
                .ic_delivery_instructions_default_32
            ]
        case "FeelGood":
            return [
                .ic_light_bulb_default_32,
                .ic_search_default_32,
                .ic_play_default,
                .ic_pause_default,
                .ic_refresh_default_32,
                .ic_playground_default_32
            ]
        case "General":
            return [
                .ic_hamburger_default_32,
                .ic_trash_default_32,
                .ic_voice_default_32,
                .ic_payment_default_32,
                .ic_restaurant_default_32,
                .ic_time_default_32,
                .ic_wi_fi_default_32,
                .ic_qr_code_default_32
            ]
        default:
            return []
        }
    }
    
    private func iconColor(for category: String) -> Color {
        switch category {
        case "Status": return .blue
        case "Map": return .green
        case "FeelGood": return .orange
        case "General": return .purple
        default: return .gray
        }
    }
    
}

// MARK: - Usage Examples View
struct UsageExamplesView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Status Icons Usage
                    IconUsageSection(
                        title: "Status Icons",
                        color: .blue,
                        icons: [
                            ("Success", "ic_status_success_16", .green),
                            ("Alert", "ic_status_alert_16", .red),
                            ("Info", "ic_status_info_16", .blue),
                            ("Blocker", "ic_status_blocker_16", .orange)
                        ]
                    )
                    
                    // Map Icons Usage
                    IconUsageSection(
                        title: "Map Icons",
                        color: .green,
                        icons: [
                            ("Location", "map_pin_single_default", .red),
                            ("Delivery", "ic_order_delivery_32", .orange),
                            ("Order", "ic_order_location_32", .blue)
                        ]
                    )
                    
                    // Feel Good Icons Usage
                    IconUsageSection(
                        title: "Feel Good Icons",
                        color: .orange,
                        icons: [
                            ("Light Bulb", "ic_light_bulb_default_32", .yellow),
                            ("Search", "ic_search_default_32", .blue),
                            ("Home", "ic_home_default_32", .green),
                            ("Play", "ic_play_default", .purple)
                        ]
                    )
                    
                    // General Icons Usage
                    IconUsageSection(
                        title: "General Icons",
                        color: .purple,
                        icons: [
                            ("Menu", "ic_hamburger_default_32", .gray),
                            ("Delete", "ic_trash_default_32", .red),
                            ("Voice", "ic_voice_default_32", .blue),
                            ("Payment", "ic_payment_default_32", .green)
                        ]
                    )
                }
                .padding()
            }
            .navigationTitle("Usage Examples")
        }
    }
}

// MARK: - Helper Views
struct IconCategorySection: View {
    let title: String
    let icons: [GeneratedIcons]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                        ForEach(Array(icons.enumerated()), id: \.offset) { index, icon in
                            VStack(spacing: 4) {
                                // Show custom icon from asset catalogs
                                loadCustomIcon(icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(color)
                                
                                Text(verbatim: "You have \(icon) items") // ✅ no warning
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                            }
                            .frame(width: 50, height: 60)
                        }
                    }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct IconUsageSection: View {
    let title: String
    let color: Color
    let icons: [(String, String, Color)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(Array(icons.enumerated()), id: \.offset) { index, iconData in
                    HStack(spacing: 12) {
                        // Show custom icon from asset catalogs
                        Image(iconData.1) // Load from asset catalog by name
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(iconData.2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(iconData.0)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(iconData.1)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

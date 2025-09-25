import SwiftUI
import DesignAssets

/// Example showing how to use the new Figma-generated icons with adaptive behavior
struct AdaptiveIconsExample: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Sample icons from different categories
    private let sampleIcons: [GeneratedIcons] = [
        .search_default_32, .search_filled_32,
        .map_default_32, .map_filled_32,
        .status_success_20, .status_alert_20,
        .chevron_left_default_32, .chevron_right_filled_32,
        .play_default, .pause_filled,
        .light_bulb_default_32, .light_bulb_filled_32,
        .calendar_default_32, .calendar_filled_32,
        .phone_alt2_default_32, .phone_alt2_filled_32,
        .wi_fi_default_32, .wi_fi_filled_32
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🎨 Figma-Generated Icons")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("169 icons fetched from Figma with adaptive variants")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Current mode: \(colorScheme == .dark ? "🌙 Dark" : "☀️ Light")")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(.top)
                    
                    // Icon Categories Overview
                    VStack(alignment: .leading, spacing: 16) {
                        Text("📊 Icon Categories")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(Array(GeneratedIcons.categories.keys.sorted()), id: \.self) { category in
                                VStack(spacing: 8) {
                                    Text(category)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("\(GeneratedIcons.categories[category]?.count ?? 0) icons")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Sample Icons Grid
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🎯 Sample Icons")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                            ForEach(sampleIcons, id: \.self) { icon in
                                VStack(spacing: 8) {
                                    icon.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.primary)
                                    
                                    Text(icon.imageName)
                                        .font(.caption2)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    Text(icon.variant)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.secondary.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Variant Comparison
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🔄 Variant Comparison")
                            .font(.headline)
                        
                        VStack(spacing: 16) {
                            // Default vs Filled comparison
                            HStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text("Default")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    VStack(spacing: 8) {
                                        GeneratedIcons.search_default_32.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                        
                                        GeneratedIcons.map_default_32.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                        
                                        GeneratedIcons.play_default.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                
                                VStack(spacing: 8) {
                                    Text("Filled")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    VStack(spacing: 8) {
                                        GeneratedIcons.search_filled_32.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                        
                                        GeneratedIcons.map_filled_32.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                        
                                        GeneratedIcons.pause_filled.image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Usage Examples
                    VStack(alignment: .leading, spacing: 16) {
                        Text("💻 Usage Examples")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            CodeExample(
                                title: "Basic Usage",
                                code: """
// Access any icon
let searchIcon = GeneratedIcons.search_filled_32.image

// Use in SwiftUI
Image(systemName: "magnifyingglass")
    .foregroundColor(.blue)
"""
                            )
                            
                            CodeExample(
                                title: "Browse by Category",
                                code: """
// Get icons by category
let generalIcons = GeneratedIcons.categories["General"]
let statusIcons = GeneratedIcons.categories["Status"]

// Get all icons
let allIcons = GeneratedIcons.allIcons
"""
                            )
                            
                            CodeExample(
                                title: "Icon Properties",
                                code: """
let icon = GeneratedIcons.search_filled_32
print(icon.imageName)    // "search_filled_32"
print(icon.category)     // "General"
print(icon.variant)      // "filled"
"""
                            )
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📈 Statistics")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Total Icons: \(GeneratedIcons.allIcons.count)")
                            Text("• Categories: \(GeneratedIcons.categories.count)")
                            Text("• Variants: \(Set(GeneratedIcons.allIcons.map { $0.variant }).count)")
                            Text("• Source: Figma API Integration")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Figma Icons")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Helper view for code examples
struct CodeExample: View {
    let title: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(8)
        }
    }
}

#Preview {
    AdaptiveIconsExample()
}

#Preview("Dark Mode") {
    AdaptiveIconsExample()
        .preferredColorScheme(.dark)
}

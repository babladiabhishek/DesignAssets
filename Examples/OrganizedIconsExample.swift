// Organized Icons Example
// This example demonstrates how to use the category-organized icons

import SwiftUI
import DesignAssets

struct OrganizedIconsExample: View {
    var body: some View {
        NavigationView {
            List {
                // Status Icons Section
                Section("Status Icons (12x12, 16x16, 20x20)") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(GeneratedIcons.statusIcons, id: \.self) { icon in
                            VStack {
                                icon.image
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                
                                Text(icon.rawValue)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(4)
                        }
                    }
                }
                
                // Map Icons Section
                Section("Map Icons (Order Location)") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(GeneratedIcons.mapIcons, id: \.self) { icon in
                            VStack {
                                icon.image
                                    .font(.title2)
                                    .foregroundColor(.green)
                                
                                Text(icon.rawValue)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(4)
                        }
                    }
                }
                
                // Feel Good Icons Section
                Section("Feel Good Icons (Filled/Outline)") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(GeneratedIcons.feelGoodIcons, id: \.self) { icon in
                            VStack {
                                icon.image
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                
                                Text(icon.rawValue)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(4)
                        }
                    }
                }
                
                // General Icons Section
                Section("General Icons") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(GeneratedIcons.generalIcons, id: \.self) { icon in
                            VStack {
                                icon.image
                                    .font(.title2)
                                    .foregroundColor(.purple)
                                
                                Text(icon.rawValue)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(4)
                        }
                    }
                }
            }
            .navigationTitle("Organized Icons")
        }
    }
}

// MARK: - Usage Examples

struct IconUsageExamples: View {
    var body: some View {
        VStack(spacing: 20) {
            // Status Icons Usage
            VStack(alignment: .leading, spacing: 8) {
                Text("Status Icons")
                    .font(.headline)
                
                HStack {
                    GeneratedIcons.Status.ic_status_success_16.image
                        .foregroundColor(.green)
                    Text("Success")
                    
                    GeneratedIcons.Status.ic_status_alert_16.image
                        .foregroundColor(.red)
                    Text("Alert")
                    
                    GeneratedIcons.Status.ic_status_info_16.image
                        .foregroundColor(.blue)
                    Text("Info")
                }
            }
            
            // Map Icons Usage
            VStack(alignment: .leading, spacing: 8) {
                Text("Map Icons")
                    .font(.headline)
                
                HStack {
                    GeneratedIcons.Map.map_pin_single_default.image
                        .foregroundColor(.red)
                    Text("Location")
                    
                    GeneratedIcons.Map.ic_order_delivery_32.image
                        .foregroundColor(.orange)
                    Text("Delivery")
                }
            }
            
            // Feel Good Icons Usage
            VStack(alignment: .leading, spacing: 8) {
                Text("Feel Good Icons")
                    .font(.headline)
                
                HStack {
                    GeneratedIcons.FeelGood.ic_light_bulb_default_32.image
                        .foregroundColor(.yellow)
                    Text("Light Bulb")
                    
                    GeneratedIcons.FeelGood.ic_search_default_32.image
                        .foregroundColor(.blue)
                    Text("Search")
                    
                    GeneratedIcons.FeelGood.ic_home_default_32.image
                        .foregroundColor(.green)
                    Text("Home")
                }
            }
            
            // General Icons Usage
            VStack(alignment: .leading, spacing: 8) {
                Text("General Icons")
                    .font(.headline)
                
                HStack {
                    GeneratedIcons.General.ic_hamburger_default_32.image
                        .foregroundColor(.gray)
                    Text("Menu")
                    
                    GeneratedIcons.General.ic_trash_default_32.image
                        .foregroundColor(.red)
                    Text("Delete")
                }
            }
        }
        .padding()
    }
}

// MARK: - Category-based Icon Picker

struct CategoryIconPicker: View {
    @State private var selectedCategory = "Status"
    @State private var selectedIcon: String = ""
    
    let categories = ["Status", "Map", "FeelGood", "General"]
    
    var body: some View {
        VStack {
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                    ForEach(iconsForCategory(selectedCategory), id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon.rawValue
                        }) {
                            VStack {
                                icon.image
                                    .font(.title2)
                                    .foregroundColor(selectedIcon == icon.rawValue ? .blue : .primary)
                                
                                Text(icon.rawValue)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedIcon == icon.rawValue ? Color.blue.opacity(0.1) : Color.clear)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            if !selectedIcon.isEmpty {
                Text("Selected: \(selectedIcon)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    private func iconsForCategory(_ category: String) -> [any CaseIterable] {
        switch category {
        case "Status":
            return GeneratedIcons.statusIcons
        case "Map":
            return GeneratedIcons.mapIcons
        case "FeelGood":
            return GeneratedIcons.feelGoodIcons
        case "General":
            return GeneratedIcons.generalIcons
        default:
            return []
        }
    }
}

#Preview {
    OrganizedIconsExample()
}

#Preview("Usage Examples") {
    IconUsageExamples()
}

#Preview("Category Picker") {
    CategoryIconPicker()
}

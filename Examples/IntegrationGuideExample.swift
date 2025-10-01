// Integration Guide Example for DesignAssets
// This file demonstrates how to integrate and use the Figma icon system

import SwiftUI
import UIKit
import DesignAssets

// MARK: - Integration Guide Examples

struct IntegrationGuideExample: View {
    var body: some View {
        NavigationView {
            List {
                Section("Getting Started") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. Get your Figma Personal Access Token")
                            .font(.headline)
                        Text("Go to Figma → Settings → Account → Personal Access Tokens")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("2. Extract File ID from Figma URL")
                            .font(.headline)
                        Text("From: https://www.figma.com/design/T0ahWzB1fWx5BojSMkfiAE/Icons")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("File ID: T0ahWzB1fWx5BojSMkfiAE")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("3. Run the Plugin")
                            .font(.headline)
                        Text("swift package plugin fetch-icons --token YOUR_TOKEN --file-id T0ahWzB1fWx5BojSMkfiAE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Generated Code Structure") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("The plugin generates organized Swift code:")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• GeneratedIcons.General - General UI icons")
                            Text("• GeneratedIcons.Map - Map and location icons")
                            Text("• GeneratedIcons.Status - Status and notification icons")
                            Text("• GeneratedIcons.Navigation - Navigation icons")
                            Text("• GeneratedIcons.All - All icons in one enum")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                
                Section("Usage Examples") {
                    NavigationLink("Icon Categories", destination: IconCategoriesExample())
                    NavigationLink("Icon Variants", destination: IconVariantsExample())
                    NavigationLink("Dynamic Icon Loading", destination: DynamicIconExample())
                }
            }
            .navigationTitle("Figma Integration")
        }
    }
}

// MARK: - Icon Categories Example

struct IconCategoriesExample: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                // Note: These examples show the structure that would be generated
                // The actual GeneratedIcons enum will be created by the plugin
                
                Text("Icon Categories")
                    .font(.title)
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("General Icons")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                        ForEach(0..<12) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("\(index + 1)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                )
                        }
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Map Icons")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                        ForEach(0..<6) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.1))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("📍")
                                        .font(.caption)
                                )
                        }
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Status Icons")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                        ForEach(0..<8) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("●")
                                        .font(.caption)
                                )
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Icon Variants Example

struct IconVariantsExample: View {
    @State private var selectedVariant = "filled"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Icon Variants")
                .font(.title)
                .padding()
            
            Picker("Variant", selection: $selectedVariant) {
                Text("Filled").tag("filled")
                Text("Outline").tag("outline")
                Text("Light").tag("light")
                Text("Dark").tag("dark")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 15) {
                    ForEach(0..<24) { index in
                        VStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(variantColor(for: selectedVariant))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(variantSymbol(for: selectedVariant))
                                        .font(.caption)
                                        .foregroundColor(variantTextColor(for: selectedVariant))
                                )
                            
                            Text("icon_\(index + 1)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Variants")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func variantColor(for variant: String) -> Color {
        switch variant {
        case "filled": return Color.blue.opacity(0.2)
        case "outline": return Color.clear
        case "light": return Color.yellow.opacity(0.2)
        case "dark": return Color.black.opacity(0.2)
        default: return Color.gray.opacity(0.2)
        }
    }
    
    private func variantTextColor(for variant: String) -> Color {
        switch variant {
        case "filled": return .blue
        case "outline": return .blue
        case "light": return .yellow
        case "dark": return .white
        default: return .gray
        }
    }
    
    private func variantSymbol(for variant: String) -> String {
        switch variant {
        case "filled": return "●"
        case "outline": return "○"
        case "light": return "☀"
        case "dark": return "●"
        default: return "?"
        }
    }
}

// MARK: - Dynamic Icon Example

struct DynamicIconExample: View {
    @State private var selectedCategory = "General"
    @State private var searchText = ""
    
    private let categories = ["General", "Map", "Status", "Navigation", "Social"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dynamic Icon Loading")
                .font(.title)
                .padding()
            
            VStack(spacing: 12) {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                TextField("Search icons...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
                    ForEach(filteredIcons, id: \.self) { iconName in
                        VStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text("🎨")
                                        .font(.title2)
                                )
                            
                            Text(iconName)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Dynamic Loading")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var filteredIcons: [String] {
        let baseIcons = (1...20).map { "\(selectedCategory.lowercased())_icon_\($0)" }
        
        if searchText.isEmpty {
            return baseIcons
        } else {
            return baseIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

// MARK: - Advanced Usage Example

struct AdvancedFigmaUsageExample: View {
    @State private var isLoading = false
    @State private var icons: [String] = []
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Advanced Usage")
                .font(.title)
                .padding()
            
            if isLoading {
                ProgressView("Loading icons from Figma...")
                    .padding()
            } else if let error = errorMessage {
                VStack {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                    
                    Button("Retry") {
                        loadIcons()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 15) {
                        ForEach(icons, id: \.self) { iconName in
                            VStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text("🎨")
                                            .font(.title2)
                                    )
                                
                                Text(iconName)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            loadIcons()
        }
    }
    
    private func loadIcons() {
        isLoading = true
        errorMessage = nil
        
        // Simulate loading from Figma
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            
            // Simulate successful load
            icons = (1...30).map { "figma_icon_\($0)" }
        }
    }
}

// MARK: - Preview

struct FigmaIntegrationExample_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FigmaIntegrationExample()
                .previewDisplayName("Main Example")
            
            IconCategoriesExample()
                .previewDisplayName("Categories")
            
            IconVariantsExample()
                .previewDisplayName("Variants")
            
            DynamicIconExample()
                .previewDisplayName("Dynamic Loading")
        }
    }
}

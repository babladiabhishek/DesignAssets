import SwiftUI
import DesignAssets

struct AllIconsView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    let categories = ["All", "Original", "Negative"]
    
    var filteredIcons: [DesignAssets.IconName] {
        let allIcons = DesignAssets.IconName.allCases
        
        let categoryFiltered: [DesignAssets.IconName]
        switch selectedCategory {
        case "Original":
            categoryFiltered = allIcons.filter { $0.rawValue.contains("_original") }
        case "Negative":
            categoryFiltered = allIcons.filter { $0.rawValue.contains("_negative") }
        default:
            categoryFiltered = allIcons
        }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { icon in
                icon.baseName.localizedCaseInsensitiveContains(searchText) ||
                icon.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and filter controls
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search icons...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            // Icons grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 6), spacing: 20) {
                    ForEach(filteredIcons, id: \.self) { icon in
                        VStack(spacing: 8) {
                            // Icon display
                            if let image = icon.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.secondary.opacity(0.1))
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.secondary.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "questionmark")
                                            .foregroundColor(.secondary)
                                    )
                            }
                            
                            // Icon name
                            Text(icon.baseName)
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                            
                            // Variant indicator
                            Text(icon.rawValue.contains("_original") ? "O" : "N")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(icon.rawValue.contains("_original") ? .blue : .purple)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(icon.rawValue.contains("_original") ? Color.blue.opacity(0.2) : Color.purple.opacity(0.2))
                                )
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                        .contextMenu {
                            Button("Copy Name") {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(icon.rawValue, forType: .string)
                            }
                            
                            Button("Copy Base Name") {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(icon.baseName, forType: .string)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("All Icons")
        .navigationSubtitle("\(filteredIcons.count) of \(DesignAssets.IconName.allCases.count) icons")
    }
}

#Preview {
    AllIconsView()
}

import SwiftUI
import DesignAssets

struct SocialMediaIconsView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 30) {
                ForEach(Array(SocialMediaIcons.allIcons.enumerated()), id: \.offset) { index, icon in
                    VStack(spacing: 12) {
                        // Icon display
                        if let image = DesignAssets.icon(named: icon.name) {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.secondary.opacity(0.1))
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "questionmark")
                                        .font(.system(size: 30))
                                        .foregroundColor(.secondary)
                                )
                        }
                        
                        // Icon info
                        VStack(spacing: 4) {
                            Text(icon.platform)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(icon.color)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(icon.size))pt")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        // Figma link
                        if let url = URL(string: icon.figmaUrl) {
                            Link("View in Figma", destination: url)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(NSColor.controlBackgroundColor))
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Social Media Icons")
        .navigationSubtitle("\(SocialMediaIcons.allIcons.count) icons available")
    }
}

#Preview {
    SocialMediaIconsView()
}

import SwiftUI
import DesignAssets

struct AdaptiveIconsView: View {
    @Binding var colorScheme: ColorScheme
    
    let sampleIcons = [
        "facebook", "instagram", "x_twitter", "linkedin", 
        "youtube", "tiktok", "snapchat", "pinterest"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text("🎨 Adaptive Icons")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Icons that automatically adapt to light/dark mode")
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
                
                // Method 1: Using adaptiveIcon function
                VStack(alignment: .leading, spacing: 16) {
                    Text("Method 1: Direct Function Call")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(sampleIcons, id: \.self) { platform in
                            VStack(spacing: 8) {
                                if let image = DesignAssets.adaptiveIcon(named: platform, in: colorScheme) {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "questionmark")
                                                .foregroundColor(.secondary)
                                        )
                                }
                                
                                Text(platform.capitalized)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Method 2: Using IconName enum with adaptive methods
                VStack(alignment: .leading, spacing: 16) {
                    Text("Method 2: IconName Enum")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach([
                            DesignAssets.IconName.facebookOriginal,
                            DesignAssets.IconName.instagramOriginal,
                            DesignAssets.IconName.xTwitterOriginal,
                            DesignAssets.IconName.linkedinOriginal,
                            DesignAssets.IconName.youtubeOriginal,
                            DesignAssets.IconName.tiktokOriginal,
                            DesignAssets.IconName.snapchatOriginal,
                            DesignAssets.IconName.pinterestOriginal
                        ], id: \.self) { icon in
                            VStack(spacing: 8) {
                                if let image = icon.adaptiveImage(in: colorScheme) {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "questionmark")
                                                .foregroundColor(.secondary)
                                        )
                                }
                                
                                Text(icon.baseName.capitalized)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Comparison: Original vs Negative
                VStack(alignment: .leading, spacing: 16) {
                    Text("Comparison: Original vs Negative")
                        .font(.headline)
                    
                    HStack(spacing: 40) {
                        VStack(spacing: 12) {
                            Text("Original")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            VStack(spacing: 8) {
                                if let image = DesignAssets.IconName.facebookOriginal.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                                
                                if let image = DesignAssets.IconName.instagramOriginal.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                                
                                if let image = DesignAssets.IconName.xTwitterOriginal.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Text("Negative")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            VStack(spacing: 8) {
                                if let image = DesignAssets.IconName.facebookNegative.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                                
                                if let image = DesignAssets.IconName.instagramNegative.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                                
                                if let image = DesignAssets.IconName.xTwitterNegative.image {
                                    image
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
                
                // Usage Instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text("💡 Usage Instructions")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Icons automatically switch between Original (light mode) and Negative (dark mode)")
                        Text("• Use `adaptiveIcon(named:)` for direct function calls")
                        Text("• Use `icon.adaptiveImage()` for enum-based access")
                        Text("• Icons will update automatically when appearance changes")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Adaptive Icons")
        .navigationSubtitle("Light/Dark mode adaptation")
    }
}

#Preview {
    AdaptiveIconsView(colorScheme: .constant(.light))
}

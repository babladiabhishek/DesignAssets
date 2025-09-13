import SwiftUI
import DesignAssets

/// Example showing how to use adaptive icons that automatically switch between light and dark mode
struct AdaptiveIconsExample: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
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
                            ForEach(["facebook", "instagram", "x_twitter", "linkedin", "youtube", "tiktok", "snapchat", "pinterest"], id: \.self) { platform in
                                VStack(spacing: 8) {
                                    DesignAssets.adaptiveIcon(named: platform, in: colorScheme)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
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
                                    icon.adaptiveImage(in: colorScheme)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
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
                                    DesignAssets.IconName.facebookOriginal.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    
                                    DesignAssets.IconName.instagramOriginal.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    
                                    DesignAssets.IconName.xTwitterOriginal.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            
                            VStack(spacing: 12) {
                                Text("Negative")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                VStack(spacing: 8) {
                                    DesignAssets.IconName.facebookNegative.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    
                                    DesignAssets.IconName.instagramNegative.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    
                                    DesignAssets.IconName.xTwitterNegative.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
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
            .navigationBarTitleDisplayMode(.inline)
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

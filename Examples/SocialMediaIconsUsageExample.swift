// Social Media Icons Usage Example for DesignAssets
// This file demonstrates how to use the social media icons in your DesignAssets package

import SwiftUI
import UIKit
import DesignAssets

// MARK: - SwiftUI Usage Examples

struct SocialMediaIconsSwiftUIExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Social Media Icons - SwiftUI")
                .font(.title)
                .padding()
            
            // Instagram icons
            HStack {
                Text("Instagram:")
                SocialMediaIcons.Instagram.blue.image
                SocialMediaIcons.Instagram.white.image
            }
            
            // Facebook icons
            HStack {
                Text("Facebook:")
                SocialMediaIcons.Facebook.blue.image
                SocialMediaIcons.Facebook.white.image
            }
            
            // Twitter icons
            HStack {
                Text("Twitter:")
                SocialMediaIcons.Twitter.blue.image
                SocialMediaIcons.Twitter.white.image
            }
            
            // All icons for a platform
            VStack(alignment: .leading) {
                Text("All LinkedIn Icons:")
                HStack {
                    ForEach(SocialMediaIcons.linkedinIcons, id: \.name) { icon in
                        icon.image
                    }
                }
            }
            
            // Dynamic platform selection
            VStack(alignment: .leading) {
                Text("Available Platforms:")
                ForEach(SocialMediaIcons.availablePlatforms, id: \.self) { platform in
                    Text("• \(platform)")
                }
            }
        }
        .padding()
    }
}

// MARK: - UIKit Usage Examples

class SocialMediaIconsUIKitExample: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocialMediaIcons()
    }
    
    private func setupSocialMediaIcons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Instagram icons
        let instagramStack = createIconStack(
            title: "Instagram:",
            icons: [SocialMediaIcons.Instagram.blue, SocialMediaIcons.Instagram.white]
        )
        stackView.addArrangedSubview(instagramStack)
        
        // Facebook icons
        let facebookStack = createIconStack(
            title: "Facebook:",
            icons: [SocialMediaIcons.Facebook.blue, SocialMediaIcons.Facebook.white]
        )
        stackView.addArrangedSubview(facebookStack)
        
        // All LinkedIn icons
        let linkedinStack = createIconStack(
            title: "All LinkedIn Icons:",
            icons: SocialMediaIcons.linkedinIcons
        )
        stackView.addArrangedSubview(linkedinStack)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createIconStack(title: String, icons: [SocialIconInfo]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        stackView.addArrangedSubview(titleLabel)
        
        for icon in icons {
            if let imageView = icon.uiImage {
                let imageView = UIImageView(image: imageView)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                stackView.addArrangedSubview(imageView)
            }
        }
        
        return stackView
    }
}

// MARK: - Advanced Usage Examples

struct SocialMediaIconsAdvancedExample: View {
    @State private var selectedPlatform = "Instagram"
    @State private var selectedColor = "Blue"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Advanced Social Media Icons")
                .font(.title)
                .padding()
            
            // Platform picker
            Picker("Platform", selection: $selectedPlatform) {
                ForEach(SocialMediaIcons.availablePlatforms, id: \.self) { platform in
                    Text(platform).tag(platform)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            // Color picker for selected platform
            Picker("Color", selection: $selectedColor) {
                ForEach(SocialMediaIcons.colorVariants(for: selectedPlatform), id: \.self) { color in
                    Text(color).tag(color)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Display selected icon
            if let selectedIcon = getSelectedIcon() {
                VStack {
                    Text("Selected Icon:")
                    selectedIcon.image
                        .frame(width: 48, height: 48)
                    
                    Text(selectedIcon.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Show all icons for selected platform
            VStack(alignment: .leading) {
                Text("All \(selectedPlatform) Icons:")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(SocialMediaIcons.icons(for: selectedPlatform), id: \.name) { icon in
                        VStack {
                            icon.image
                                .frame(width: 32, height: 32)
                            Text(icon.color)
                                .font(.caption2)
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
    }
    
    private func getSelectedIcon() -> SocialIconInfo? {
        return SocialMediaIcons.icons(for: selectedPlatform)
            .first { $0.color == selectedColor }
    }
}

// MARK: - Icon Button Examples

struct SocialMediaIconButton: View {
    let icon: SocialIconInfo
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                icon.image
                    .frame(width: 32, height: 32)
                Text(icon.platform)
                    .font(.caption)
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SocialMediaIconButtonsExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Social Media Icon Buttons")
                .font(.title)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 15) {
                SocialMediaIconButton(icon: SocialMediaIcons.Instagram.blue) {
                    print("Instagram tapped")
                }
                
                SocialMediaIconButton(icon: SocialMediaIcons.Facebook.blue) {
                    print("Facebook tapped")
                }
                
                SocialMediaIconButton(icon: SocialMediaIcons.Twitter.blue) {
                    print("Twitter tapped")
                }
                
                SocialMediaIconButton(icon: SocialMediaIcons.LinkedIn.blue) {
                    print("LinkedIn tapped")
                }
            }
        }
        .padding()
    }
}

// MARK: - Preview

struct SocialMediaIconsUsageExample_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SocialMediaIconsSwiftUIExample()
                .previewDisplayName("SwiftUI Example")
            
            SocialMediaIconsAdvancedExample()
                .previewDisplayName("Advanced Example")
            
            SocialMediaIconsIconButtonsExample()
                .previewDisplayName("Icon Buttons Example")
        }
    }
}

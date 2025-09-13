import XCTest
@testable import DesignAssets

final class DesignAssetsTests: XCTestCase {
    
    func testSocialMediaIconsExist() throws {
        // Test that all expected social media icons exist
        XCTAssertNotNil(SocialMediaIcons.Instagram.blue)
        XCTAssertNotNil(SocialMediaIcons.Instagram.white)
        XCTAssertNotNil(SocialMediaIcons.Facebook.blue)
        XCTAssertNotNil(SocialMediaIcons.Facebook.white)
        XCTAssertNotNil(SocialMediaIcons.Twitter.blue)
        XCTAssertNotNil(SocialMediaIcons.Twitter.white)
        XCTAssertNotNil(SocialMediaIcons.LinkedIn.blue)
        XCTAssertNotNil(SocialMediaIcons.LinkedIn.white)
        XCTAssertNotNil(SocialMediaIcons.YouTube.red)
        XCTAssertNotNil(SocialMediaIcons.YouTube.white)
    }
    
    func testSocialIconInfoProperties() throws {
        let icon = SocialMediaIcons.Instagram.blue
        
        XCTAssertEqual(icon.name, "social_instagram_blue")
        XCTAssertEqual(icon.platform, "Instagram")
        XCTAssertEqual(icon.color, "Blue")
        XCTAssertEqual(icon.size, 24.0)
        XCTAssertTrue(icon.figmaUrl.contains("figma.com"))
    }
    
    func testPlatformCollections() throws {
        // Test Instagram icons collection
        let instagramIcons = SocialMediaIcons.instagramIcons
        XCTAssertEqual(instagramIcons.count, 2)
        XCTAssertTrue(instagramIcons.contains { $0.color == "Blue" })
        XCTAssertTrue(instagramIcons.contains { $0.color == "White" })
        
        // Test Facebook icons collection
        let facebookIcons = SocialMediaIcons.facebookIcons
        XCTAssertEqual(facebookIcons.count, 2)
        XCTAssertTrue(facebookIcons.contains { $0.color == "Blue" })
        XCTAssertTrue(facebookIcons.contains { $0.color == "White" })
    }
    
    func testAllIconsCollection() throws {
        let allIcons = SocialMediaIcons.allIcons
        XCTAssertEqual(allIcons.count, 10) // 5 platforms × 2 variants each
        
        // Test that all platforms are represented
        let platforms = Set(allIcons.map { $0.platform })
        XCTAssertTrue(platforms.contains("Instagram"))
        XCTAssertTrue(platforms.contains("Facebook"))
        XCTAssertTrue(platforms.contains("Twitter"))
        XCTAssertTrue(platforms.contains("LinkedIn"))
        XCTAssertTrue(platforms.contains("YouTube"))
    }
    
    func testPlatformFiltering() throws {
        // Test filtering by platform
        let instagramIcons = SocialMediaIcons.icons(for: "Instagram")
        XCTAssertEqual(instagramIcons.count, 2)
        XCTAssertTrue(instagramIcons.allSatisfy { $0.platform == "Instagram" })
        
        let facebookIcons = SocialMediaIcons.icons(for: "Facebook")
        XCTAssertEqual(facebookIcons.count, 2)
        XCTAssertTrue(facebookIcons.allSatisfy { $0.platform == "Facebook" })
    }
    
    func testColorVariants() throws {
        // Test getting color variants for a platform
        let instagramColors = SocialMediaIcons.colorVariants(for: "Instagram")
        XCTAssertEqual(instagramColors.count, 2)
        XCTAssertTrue(instagramColors.contains("Blue"))
        XCTAssertTrue(instagramColors.contains("White"))
        
        let youtubeColors = SocialMediaIcons.colorVariants(for: "YouTube")
        XCTAssertEqual(youtubeColors.count, 2)
        XCTAssertTrue(youtubeColors.contains("Red"))
        XCTAssertTrue(youtubeColors.contains("White"))
    }
    
    func testAvailablePlatforms() throws {
        let platforms = SocialMediaIcons.availablePlatforms
        XCTAssertEqual(platforms.count, 5)
        XCTAssertTrue(platforms.contains("Instagram"))
        XCTAssertTrue(platforms.contains("Facebook"))
        XCTAssertTrue(platforms.contains("Twitter"))
        XCTAssertTrue(platforms.contains("LinkedIn"))
        XCTAssertTrue(platforms.contains("YouTube"))
    }
    
    func testIconVariantDetection() throws {
        // Test dark/light variant detection
        XCTAssertTrue(SocialMediaIcons.Instagram.white.isLightVariant)
        XCTAssertFalse(SocialMediaIcons.Instagram.blue.isLightVariant)
        
        XCTAssertFalse(SocialMediaIcons.Instagram.white.isDarkVariant)
        XCTAssertFalse(SocialMediaIcons.Instagram.blue.isDarkVariant) // Blue is not considered dark
    }
    
    func testDisplayName() throws {
        let icon = SocialMediaIcons.Instagram.blue
        XCTAssertEqual(icon.displayName, "Instagram Blue")
        
        let whiteIcon = SocialMediaIcons.Facebook.white
        XCTAssertEqual(whiteIcon.displayName, "Facebook White")
    }
    
    func testFigmaUrlFormat() throws {
        let icon = SocialMediaIcons.Twitter.blue
        XCTAssertTrue(icon.figmaUrl.contains("figma.com"))
        XCTAssertTrue(icon.figmaUrl.contains("design"))
        XCTAssertTrue(icon.figmaUrl.contains("node-id"))
    }
}

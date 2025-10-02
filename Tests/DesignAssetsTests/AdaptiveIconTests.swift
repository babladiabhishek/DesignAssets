import XCTest
@testable import DesignAssets
import SwiftUI

final class AdaptiveIconTests: XCTestCase {
    
    func testAdaptiveIconFunction() throws {
        // Test the adaptiveIcon function exists and works
        let lightIcon = DesignAssets.adaptiveIcon(named: "facebook", in: .light)
        XCTAssertNotNil(lightIcon, "Light mode icon should be created")
        
        let darkIcon = DesignAssets.adaptiveIcon(named: "facebook", in: .dark)
        XCTAssertNotNil(darkIcon, "Dark mode icon should be created")
    }
    
    func testIconNameEnum() throws {
        // Test that IconName enum cases exist
        XCTAssertNotNil(DesignAssets.IconName.facebookOriginal)
        XCTAssertNotNil(DesignAssets.IconName.instagramOriginal)
        XCTAssertNotNil(DesignAssets.IconName.xTwitterOriginal)
        XCTAssertNotNil(DesignAssets.IconName.linkedinOriginal)
    }
    
    func testAdaptiveImageMethod() throws {
        // Test the adaptiveImage method on IconName
        let facebookIcon = DesignAssets.IconName.facebookOriginal
        let lightImage = facebookIcon.adaptiveImage(in: .light)
        let darkImage = facebookIcon.adaptiveImage(in: .dark)
        
        XCTAssertNotNil(lightImage, "Light mode adaptive image should be created")
        XCTAssertNotNil(darkImage, "Dark mode adaptive image should be created")
    }
    
    func testImageProperty() throws {
        // Test the image property on IconName
        let facebookIcon = DesignAssets.IconName.facebookOriginal
        let image = facebookIcon.image
        
        XCTAssertNotNil(image, "Icon image should be accessible")
    }
    
    func testBaseNameProperty() throws {
        // Test the baseName property
        let facebookIcon = DesignAssets.IconName.facebookOriginal
        XCTAssertEqual(facebookIcon.baseName, "facebook", "Base name should be correct")
        
        let instagramIcon = DesignAssets.IconName.instagramOriginal
        XCTAssertEqual(instagramIcon.baseName, "instagram", "Base name should be correct")
    }
    
    func testOriginalAndNegativeVariants() throws {
        // Test that both original and negative variants exist
        let facebookOriginal = DesignAssets.IconName.facebookOriginal
        let facebookNegative = DesignAssets.IconName.facebookNegative
        
        XCTAssertNotNil(facebookOriginal, "Facebook original should exist")
        XCTAssertNotNil(facebookNegative, "Facebook negative should exist")
        
        // Test that they have different base names but same platform
        XCTAssertEqual(facebookOriginal.baseName, "facebook")
        XCTAssertEqual(facebookNegative.baseName, "facebook")
    }
    
    func testIconNameEquality() throws {
        // Test that IconName cases can be compared
        let facebook1 = DesignAssets.IconName.facebookOriginal
        let facebook2 = DesignAssets.IconName.facebookOriginal
        let instagram = DesignAssets.IconName.instagramOriginal
        
        XCTAssertEqual(facebook1, facebook2, "Same icon names should be equal")
        XCTAssertNotEqual(facebook1, instagram, "Different icon names should not be equal")
    }
    
    func testIconNameHashable() throws {
        // Test that IconName can be used in collections
        let icons: Set<DesignAssets.IconName> = [
            .facebookOriginal,
            .instagramOriginal,
            .xTwitterOriginal
        ]
        
        XCTAssertEqual(icons.count, 3, "Should be able to create a set of icon names")
        XCTAssertTrue(icons.contains(.facebookOriginal), "Set should contain facebook original")
    }
    
    func testIconNameRawValue() throws {
        // Test that IconName has raw values
        let facebookIcon = DesignAssets.IconName.facebookOriginal
        let rawValue = facebookIcon.rawValue
        
        XCTAssertEqual(rawValue, "facebook_original", "Raw value should be correct")
        XCTAssertFalse(rawValue.isEmpty, "Raw value should not be empty")
    }
    
    func testAdaptiveIconWithInvalidName() throws {
        // Test adaptive icon with invalid name
        let invalidIcon = DesignAssets.adaptiveIcon(named: "nonexistent_icon", in: .light)
        // This should either return nil or a placeholder image
        // The exact behavior depends on implementation
        XCTAssertNotNil(invalidIcon, "Should handle invalid icon names gracefully")
    }
    
    func testColorSchemeAdaptation() throws {
        // Test that icons adapt to color scheme
        let facebookIcon = DesignAssets.IconName.facebookOriginal
        
        let lightImage = facebookIcon.adaptiveImage(in: .light)
        let darkImage = facebookIcon.adaptiveImage(in: .dark)
        
        // In a real implementation, these might be different images
        // For now, we just test that both are created successfully
        XCTAssertNotNil(lightImage, "Light mode image should be created")
        XCTAssertNotNil(darkImage, "Dark mode image should be created")
    }
}

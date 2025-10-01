import XCTest
@testable import DesignAssets

final class DesignAssetsTests: XCTestCase {
    
    func testGeneratedIconsExist() throws {
        // Test that GeneratedIcons enum exists and has cases
        // We can test by accessing specific known icons from the All enum
        let _ = GeneratedIcons.All.deprecated__ic_add_filled_32
        let _ = GeneratedIcons.All.ic_light_bulb_default_32
        let _ = GeneratedIcons.All.ic_status_success_20
        // If we get here without compilation errors, the enums exist
    }
    
    func testIconCategories() throws {
        // Test that we have the expected categories
        let categories = DesignAssets.iconCategories
        XCTAssertTrue(categories.contains("General"))
        XCTAssertTrue(categories.contains("Map"))
        XCTAssertTrue(categories.contains("Navigation"))
        XCTAssertTrue(categories.contains("Status"))
    }
    
    func testIconImageAccess() throws {
        // Test that icons can be accessed and have image properties
        let sampleIcon = GeneratedIcons.ic_light_bulb_default_32
        
        // Test SwiftUI Image access
        #if canImport(SwiftUI)
        let image = sampleIcon.image
        XCTAssertNotNil(image)
        #endif
        
        // Test UIKit UIImage access
        #if canImport(UIKit)
        let uiImage = sampleIcon.uiImage
        // UIImage might be nil if the asset isn't loaded, which is expected
        #endif
    }
    
    func testIconCategoryProperty() throws {
        // Test that icons have category information
        let sampleIcon = GeneratedIcons.ic_light_bulb_default_32
        let category = sampleIcon.category
        XCTAssertFalse(category.isEmpty, "Icon should have a non-empty category")
        XCTAssertTrue(DesignAssets.iconCategories.contains(category), "Category should be in the list of available categories")
    }
    
    func testAvailableIconNames() throws {
        // Test that we can get available icon names
        let iconNames = DesignAssets.availableIconNames
        XCTAssertGreaterThan(iconNames.count, 0, "Should have available icon names")
        
        // Test that all names are non-empty
        for name in iconNames {
            XCTAssertFalse(name.isEmpty, "Icon name should not be empty")
        }
    }
    
    func testIconNameSanitization() throws {
        // Test that icon names are properly sanitized (no special characters)
        let iconNames = DesignAssets.availableIconNames
        
        for name in iconNames {
            // Should not contain spaces, special characters, or emojis
            XCTAssertFalse(name.contains(" "), "Icon name should not contain spaces: \(name)")
            XCTAssertFalse(name.contains("🛑"), "Icon name should not contain emojis: \(name)")
            XCTAssertTrue(name.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }, "Icon name should only contain letters, numbers, and underscores: \(name)")
        }
    }
    
    func testFigmaIntegration() throws {
        // Test that the Figma integration API exists
        let fileId = "T0ahWzB1fWx5BojSMkfiAE"
        let token = "test_token"
        
        // This should not crash (even though it won't actually fetch without a real token)
        let expectation = XCTestExpectation(description: "Figma fetch should complete")
        
        Task {
            do {
                _ = try await DesignAssets.fetchIconsFromFigma(
                    fileId: fileId,
                    token: token,
                    includeVariants: true,
                    generateAssetCatalog: true,
                    generateSwiftCode: true
                )
            } catch {
                // Expected to fail with test token, but should not crash
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testIconRefreshLogic() throws {
        // Test the icon refresh logic
        let needsRefresh = DesignAssets.needsIconRefresh
        // The refresh logic depends on file existence and timing
        // Just test that the method doesn't crash
        XCTAssertNotNil(needsRefresh, "Refresh check should not crash")
        
        // Mark as refreshed
        DesignAssets.markIconsRefreshed()
        
        // Test that marking as refreshed doesn't crash
        XCTAssertTrue(true, "Mark as refreshed should not crash")
    }
}
import XCTest
@testable import DesignAssets

final class DesignAssetsTests: XCTestCase {
    
    func testAvailableIconNames() throws {
        // Test that we can get available icon names
        let iconNames = DesignAssets.availableIconNames
        XCTAssertGreaterThan(iconNames.count, 0, "Should have available icon names")
        
        // Test that all names are non-empty
        for name in iconNames {
            XCTAssertFalse(name.isEmpty, "Icon name should not be empty")
        }
    }
    
    func testIconCategories() throws {
        // Test that we have the expected categories
        let categories = DesignAssets.iconCategories
        XCTAssertTrue(categories.contains("General"))
        XCTAssertTrue(categories.contains("Map"))
        XCTAssertTrue(categories.contains("Navigation"))
        XCTAssertTrue(categories.contains("Status"))
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
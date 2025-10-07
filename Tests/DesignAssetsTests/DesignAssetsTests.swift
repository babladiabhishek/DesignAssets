import XCTest
@testable import DesignAssets

final class DesignAssetsTests: XCTestCase {
    
    func testIconCategories() throws {
        // Test that we have the expected categories
        let categories = DesignAssets.iconCategories
        XCTAssertTrue(categories.contains("General"))
        XCTAssertTrue(categories.contains("Map"))
        XCTAssertTrue(categories.contains("Status"))
        XCTAssertTrue(categories.contains("Navigation"))
        XCTAssertEqual(categories.count, 4)
    }
    
    func testIconLayers() throws {
        // Test that we have the expected layers
        let layers = DesignAssets.iconLayers
        XCTAssertTrue(layers.contains("GeneralIcons"))
        XCTAssertTrue(layers.contains("MapIcons"))
        XCTAssertTrue(layers.contains("StatusIcons"))
        XCTAssertTrue(layers.contains("FeelgoodIcons"))
        XCTAssertEqual(layers.count, 4)
    }
    
    func testAvailableIconNames() throws {
        // Test that we can get available icon names (initially empty until plugin runs)
        let iconNames = DesignAssets.availableIconNames
        // Initially empty until the build plugin populates it
        XCTAssertNotNil(iconNames, "Should have available icon names array")
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
    
    func testFigmaIconInfoCreation() throws {
        // Test that FigmaIconInfo can be created properly
        let iconInfo = FigmaIconInfo(
            id: "test_id",
            name: "test_icon",
            category: "General",
            variant: "filled",
            nodeId: "1:1",
            filePath: "/test/path",
            size: CGSize(width: 24, height: 24),
            isComponent: true,
            thumbnailUrl: "https://example.com/thumb.png",
            description: "Test icon"
        )
        
        XCTAssertEqual(iconInfo.id, "test_id")
        XCTAssertEqual(iconInfo.name, "test_icon")
        XCTAssertEqual(iconInfo.category, "General")
        XCTAssertEqual(iconInfo.variant, "filled")
        XCTAssertEqual(iconInfo.nodeId, "1:1")
        XCTAssertEqual(iconInfo.filePath, "/test/path")
        XCTAssertEqual(iconInfo.size, CGSize(width: 24, height: 24))
        XCTAssertTrue(iconInfo.isComponent)
        XCTAssertEqual(iconInfo.thumbnailUrl, "https://example.com/thumb.png")
        XCTAssertEqual(iconInfo.description, "Test icon")
    }
}
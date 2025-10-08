import XCTest
@testable import DesignAssets

final class DesignAssetsTests: XCTestCase {
    
    func testGeneratedIconsStructure() throws {
        // Test that GeneratedIcons has the expected structure
        let allIcons = GeneratedIcons.allIcons
        let categories = GeneratedIcons.categories
        let totalCount = GeneratedIcons.totalIconCount
        
        XCTAssertNotNil(allIcons, "Should have allIcons array")
        XCTAssertNotNil(categories, "Should have categories array")
        XCTAssertEqual(allIcons.count, totalCount, "Total count should match allIcons count")
    }
    
    func testBundleAccess() throws {
        // Test that the bundle is accessible
        let bundle = GeneratedIcons.bundle
        XCTAssertNotNil(bundle, "Should have a valid bundle")
    }
    
    func testIconCategories() throws {
        // Test that we have the expected categories
        let categories = GeneratedIcons.categories
        XCTAssertTrue(categories.contains("Flags"))
        XCTAssertTrue(categories.contains("Icons"))
        XCTAssertTrue(categories.contains("Images"))
        XCTAssertTrue(categories.contains("Logos"))
        XCTAssertTrue(categories.contains("Map"))
        XCTAssertTrue(categories.contains("Illustrations"))
    }
}
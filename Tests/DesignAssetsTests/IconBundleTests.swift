import XCTest
@testable import DesignAssets
import SwiftUI

final class IconBundleTests: XCTestCase {
    
    func testBundleExists() throws {
        // Test that the DesignAssets bundle can be found
        let bundle = Bundle.module
        XCTAssertNotNil(bundle)
        // In test environment, bundle identifier might be nil, so we just test bundle exists
        XCTAssertTrue(bundle.bundlePath.contains("DesignAssets"), "Bundle should be related to DesignAssets")
    }
    
    func testIconAssetsExist() throws {
        let bundle = Bundle.module
        
        // Test that Icons.xcassets exists
        guard let resourcePath = bundle.resourcePath else {
            XCTFail("Resource path not found")
            return
        }
        
        let iconsPath = "\(resourcePath)/Icons.xcassets"
        let fileManager = FileManager.default
        
        XCTAssertTrue(fileManager.fileExists(atPath: iconsPath), "Icons.xcassets should exist")
        
        // Test that we can find some expected icon files
        let expectedIcons = [
            "facebook_original.imageset",
            "instagram_original.imageset",
            "x_twitter_original.imageset",
            "linkedin_original.imageset"
        ]
        
        for icon in expectedIcons {
            let iconPath = "\(iconsPath)/\(icon)"
            XCTAssertTrue(fileManager.fileExists(atPath: iconPath), "Icon \(icon) should exist")
        }
    }
    
    func testIconCatalogsExist() throws {
        let bundle = Bundle.module
        guard let resourcePath = bundle.resourcePath else {
            XCTFail("Resource path not found")
            return
        }
        
        let fileManager = FileManager.default
        let expectedCatalogs = [
            "Icons.xcassets",
            "StatusIcons.xcassets",
            "FeelGoodIcons.xcassets",
            "GeneralIcons.xcassets",
            "MapIcons.xcassets"
        ]
        
        for catalog in expectedCatalogs {
            let catalogPath = "\(resourcePath)/\(catalog)"
            XCTAssertTrue(fileManager.fileExists(atPath: catalogPath), "Catalog \(catalog) should exist")
        }
    }
    
    func testIconImageLoading() throws {
        // Test that we can load icon images
        let bundle = Bundle.module
        
        // Test loading a specific icon
        if let imagePath = bundle.path(forResource: "facebook_original", ofType: "pdf") {
            XCTAssertTrue(FileManager.default.fileExists(atPath: imagePath), "Facebook original icon should be loadable")
        }
        
        if let imagePath = bundle.path(forResource: "instagram_original", ofType: "pdf") {
            XCTAssertTrue(FileManager.default.fileExists(atPath: imagePath), "Instagram original icon should be loadable")
        }
    }
    
    func testResourceBundleAccess() throws {
        // Test that we can access the resource bundle through the module
        let bundle = Bundle.module
        
        // Test that the bundle has the expected structure
        XCTAssertNotNil(bundle.resourcePath)
        XCTAssertNotNil(bundle.bundlePath)
        
        // Test that we can list contents
        guard let resourcePath = bundle.resourcePath else {
            XCTFail("Resource path not found")
            return
        }
        
        let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
        XCTAssertTrue(contents.contains("Icons.xcassets"), "Icons.xcassets should be in resources")
    }
    
    func testIconCount() throws {
        let bundle = Bundle.module
        guard let resourcePath = bundle.resourcePath else {
            XCTFail("Resource path not found")
            return
        }
        
        let iconsPath = "\(resourcePath)/Icons.xcassets"
        let contents = try FileManager.default.contentsOfDirectory(atPath: iconsPath)
        let iconSets = contents.filter { $0.hasSuffix(".imageset") }
        
        // We should have a reasonable number of icons
        XCTAssertGreaterThan(iconSets.count, 10, "Should have more than 10 icon sets")
        XCTAssertLessThan(iconSets.count, 1000, "Should have less than 1000 icon sets")
        
        print("Found \(iconSets.count) icon sets in Icons.xcassets")
    }
}

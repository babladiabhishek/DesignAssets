#!/usr/bin/env swift

import Foundation

// Test if we can access the images from the bundle
func testImageAccess() {
    print("🧪 Testing Image Access in DesignAssets Package")
    print(String(repeating: "=", count: 50))
    
    // Get the main bundle (since we're running as a script)
    let bundle = Bundle.main
    
    print("📦 Bundle: \(bundle)")
    print("📁 Bundle path: \(bundle.bundlePath)")
    
    // Test a few key icons by checking if the files exist
    let testIcons = [
        "facebook_original",
        "instagram_original", 
        "x_twitter_original",
        "linkedin_original",
        "youtube_original"
    ]
    
    for iconName in testIcons {
        print("\n🔍 Testing: \(iconName)")
        
        // Check if the imageset directory exists
        let imagesetPath = "Sources/DesignAssets/Resources/Icons.xcassets/\(iconName).imageset"
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: imagesetPath) {
            print("  ✅ Imageset found: \(imagesetPath)")
            
            // Check if the PDF file exists
            let pdfPath = "\(imagesetPath)/\(iconName).pdf"
            if fileManager.fileExists(atPath: pdfPath) {
                print("  ✅ PDF file found: \(pdfPath)")
                
                // Check file size
                if let attributes = try? fileManager.attributesOfItem(atPath: pdfPath),
                   let fileSize = attributes[FileAttributeKey.size] as? Int {
                    print("  📏 File size: \(fileSize) bytes")
                }
            } else {
                print("  ❌ PDF file not found")
            }
        } else {
            print("  ❌ Imageset not found")
        }
    }
    
    print("\n🎉 Image access test complete!")
}

// Run the test
testImageAccess()

#!/bin/bash

# Figma Icons Fetch Script
# This script can be run during build time to fetch fresh icons from Figma

set -e

# Configuration
FIGMA_TOKEN="${FIGMA_PERSONAL_TOKEN}"
FIGMA_FILE_ID="${FIGMA_FILE_ID:-T0ahWzB1fWx5BojSMkfiAE}"
OUTPUT_DIR="Sources/DesignAssets/Resources"
MAX_ICONS="${MAX_ICONS:-9999}"
FORCE_DOWNLOAD="${FORCE_DOWNLOAD:-false}"

echo "🚀 Fetching icons from Figma..."
echo "📁 File ID: $FIGMA_FILE_ID"
echo "🔑 Token: ${FIGMA_TOKEN:0:10}..."
echo "📂 Output: $OUTPUT_DIR"
echo "📊 Max icons: $MAX_ICONS"
echo "🔄 Force download: $FORCE_DOWNLOAD"

# Check if token is provided
if [ -z "$FIGMA_TOKEN" ]; then
    echo "❌ Error: FIGMA_PERSONAL_TOKEN environment variable is required"
    echo "Please set your Figma token:"
    echo "export FIGMA_PERSONAL_TOKEN=\"your_token_here\""
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR/Icons.xcassets"

# Create the Swift script
cat > /tmp/fetch-figma-icons.swift << 'EOF'
import Foundation

// Fetch icons from Figma with proper two-step process
let token = ProcessInfo.processInfo.environment["FIGMA_PERSONAL_TOKEN"] ?? ""
let fileId = ProcessInfo.processInfo.environment["FIGMA_FILE_ID"] ?? "T0ahWzB1fWx5BojSMkfiAE"
let maxIcons = Int(ProcessInfo.processInfo.environment["MAX_ICONS"] ?? "9999") ?? 9999
let forceDownload = ProcessInfo.processInfo.environment["FORCE_DOWNLOAD"] == "true"

print("🚀 Starting Figma icon fetch...")

// First, get the file data to extract component IDs
let url = URL(string: "https://api.figma.com/v1/files/\(fileId)")!
var request = URLRequest(url: url)
request.setValue(token, forHTTPHeaderField: "X-Figma-Token")

print("📡 Fetching Figma file...")

let semaphore = DispatchSemaphore(value: 0)
var fileData: Data?

URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        print("❌ Error: \(error.localizedDescription)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("📊 Status: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode == 200 {
            print("✅ File fetched successfully!")
            fileData = data
        } else {
            print("❌ HTTP error: \(httpResponse.statusCode)")
        }
    }
    
    semaphore.signal()
}.resume()

semaphore.wait()

guard let data = fileData else {
    print("❌ No data received")
    exit(1)
}

// Parse the JSON to get component IDs
do {
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    guard let dict = json as? [String: Any] else {
        print("❌ Invalid JSON format")
        exit(1)
    }
    
    // Extract components
    guard let components = dict["components"] as? [String: Any] else {
        print("❌ No components found")
        exit(1)
    }
    
    print("🧩 Found \(components.count) components")
    
    // Get first N components
    let componentIds = Array(components.keys.prefix(maxIcons))
    print("📋 Downloading \(componentIds.count) components")
    
    // Download images for these components
    let outputDir = URL(fileURLWithPath: "Sources/DesignAssets/Resources/Icons.xcassets")
    
    // Create category-specific directories
    let statusDir = URL(fileURLWithPath: "Sources/DesignAssets/Resources/Icons/StatusIcons.xcassets")
    let mapDir = URL(fileURLWithPath: "Sources/DesignAssets/Resources/Icons/MapIcons.xcassets")
    let feelGoodDir = URL(fileURLWithPath: "Sources/DesignAssets/Resources/Icons/FeelGoodIcons.xcassets")
    let generalDir = URL(fileURLWithPath: "Sources/DesignAssets/Resources/Icons/GeneralIcons.xcassets")
    
    // Ensure directories exist
    try? FileManager.default.createDirectory(at: statusDir, withIntermediateDirectories: true)
    try? FileManager.default.createDirectory(at: mapDir, withIntermediateDirectories: true)
    try? FileManager.default.createDirectory(at: feelGoodDir, withIntermediateDirectories: true)
    try? FileManager.default.createDirectory(at: generalDir, withIntermediateDirectories: true)
    
    // Function to determine icon category
    func getCategoryDirectory(for name: String) -> URL {
        let lowercased = name.lowercased()
        
        // Status icons (12x12, 16x16, 20x20)
        if lowercased.contains("status") || lowercased.contains("alert") || lowercased.contains("success") || 
           lowercased.contains("info") || lowercased.contains("blocker") || lowercased.contains("selected") {
            return statusDir
        }
        
        // Map icons (order location, map pins)
        if lowercased.contains("map") || lowercased.contains("location") || lowercased.contains("pin") || 
           lowercased.contains("order") || lowercased.contains("delivery") {
            return mapDir
        }
        
        // Feel Good icons (main icon set - filled/outline)
        if lowercased.contains("light") || lowercased.contains("bulb") || lowercased.contains("search") || 
           lowercased.contains("home") || lowercased.contains("heart") || lowercased.contains("play") || 
           lowercased.contains("pause") || lowercased.contains("refresh") || lowercased.contains("edit") {
            return feelGoodDir
        }
        
        // Default to general for everything else
        return generalDir
    }
    var successCount = 0
    var failCount = 0
    
    for (index, nodeId) in componentIds.enumerated() {
        print("\n⬇️ Processing image \(index + 1)/\(componentIds.count): \(nodeId)")
        
        // Get component info
        guard let componentData = components[nodeId] as? [String: Any],
              let name = componentData["name"] as? String else {
            print("⚠️ Skipping invalid component: \(nodeId)")
            failCount += 1
            continue
        }
        
        let sanitizedName = sanitizeAssetName(name)
        print("📝 Component name: \(name) -> \(sanitizedName)")
        
        // Step 1: Get the image URL from Figma
        let imageUrl = "https://api.figma.com/v1/images/\(fileId)?ids=\(nodeId)&format=pdf&scale=1"
        
        guard let imageRequestUrl = URL(string: imageUrl) else {
            print("❌ Invalid image URL")
            failCount += 1
            continue
        }
        
        var imageRequest = URLRequest(url: imageRequestUrl)
        imageRequest.setValue(token, forHTTPHeaderField: "X-Figma-Token")
        
        let imageSemaphore = DispatchSemaphore(value: 0)
        var imageUrlData: Data?
        
        print("🔍 Getting image URL from Figma...")
        URLSession.shared.dataTask(with: imageRequest) { data, response, error in
            if let error = error {
                print("❌ Image URL request error: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("✅ Image URL received!")
                    imageUrlData = data
                } else {
                    print("❌ Image URL request failed: \(httpResponse.statusCode)")
                }
            }
            imageSemaphore.signal()
        }.resume()
        
        imageSemaphore.wait()
        
        // Step 2: Parse the JSON response to get the actual image URL
        guard let imageUrlData = imageUrlData else {
            print("❌ No image URL data received")
            failCount += 1
            continue
        }
        
        do {
            let imageUrlJson = try JSONSerialization.jsonObject(with: imageUrlData, options: [])
            guard let imageUrlDict = imageUrlJson as? [String: Any],
                  let images = imageUrlDict["images"] as? [String: Any],
                  let actualImageUrl = images[nodeId] as? String else {
                print("❌ Could not parse image URL from response")
                failCount += 1
                continue
            }
            
            print("🔗 Actual image URL: \(String(actualImageUrl.prefix(50)))...")
            
            // Step 3: Download the actual image from the URL
            guard let downloadUrl = URL(string: actualImageUrl) else {
                print("❌ Invalid download URL")
                failCount += 1
                continue
            }
            
            let downloadSemaphore = DispatchSemaphore(value: 0)
            var actualImageData: Data?
            
            print("⬇️ Downloading actual image...")
            URLSession.shared.dataTask(with: downloadUrl) { data, response, error in
                if let error = error {
                    print("❌ Image download error: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("✅ Actual image downloaded successfully!")
                        actualImageData = data
                    } else {
                        print("❌ Image download failed: \(httpResponse.statusCode)")
                    }
                }
                downloadSemaphore.signal()
            }.resume()
            
            downloadSemaphore.wait()
            
        // Step 4: Determine category and create appropriate directory
        let categoryDir = getCategoryDirectory(for: name)
        let imagesetDir = categoryDir.appendingPathComponent("\(sanitizedName).imageset")
        let pdfPath = imagesetDir.appendingPathComponent("\(sanitizedName).pdf")
        
        // Skip if already downloaded and file exists (unless force download)
        if !forceDownload && FileManager.default.fileExists(atPath: pdfPath.path) {
            print("⏭️ Skipping \(sanitizedName) - already downloaded")
            successCount += 1
            continue
        }
        
        // Step 5: Save the actual image
        if let actualImageData = actualImageData {
            try? FileManager.default.createDirectory(at: imagesetDir, withIntermediateDirectories: true)
            try? actualImageData.write(to: pdfPath)
            
            // Create Contents.json for the imageset
            let contents: [String: Any] = [
                "images": [
                    [
                        "filename": "\(sanitizedName).pdf",
                        "idiom": "universal",
                        "scale": "1x"
                    ]
                ],
                "info": [
                    "author": "xcode",
                    "version": 1
                ]
            ]
            
            let contentsData = try? JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
            let contentsPath = imagesetDir.appendingPathComponent("Contents.json")
            try? contentsData?.write(to: contentsPath)
            
            print("💾 Downloaded: \(sanitizedName).imageset")
            successCount += 1
        } else {
            print("❌ No image data received")
            failCount += 1
        }
            
        } catch {
            print("❌ JSON parsing error: \(error.localizedDescription)")
            failCount += 1
        }
    }
    
    print("\n🎉 Download completed!")
    print("✅ Success: \(successCount) icons")
    print("❌ Failed: \(failCount) icons")
    print("📁 Check: \(outputDir.path)")
    
} catch {
    print("❌ Error: \(error.localizedDescription)")
    exit(1)
}

func sanitizeAssetName(_ name: String) -> String {
    var sanitized = name
        .replacingOccurrences(of: " ", with: "_")
        .replacingOccurrences(of: "-", with: "_")
        .replacingOccurrences(of: "🛑", with: "deprecated_")
        .replacingOccurrences(of: "__", with: "_")
        .lowercased()
    
    // Remove any remaining special characters
    sanitized = sanitized.components(separatedBy: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_")).inverted).joined()
    
    return sanitized
}
EOF

# Set environment variables
export FIGMA_PERSONAL_TOKEN="$FIGMA_TOKEN"
export FIGMA_FILE_ID="$FIGMA_FILE_ID"
export MAX_ICONS="$MAX_ICONS"

# Run the Swift script
echo "⚡ Running Swift fetch script..."
swift /tmp/fetch-figma-icons.swift

# Clean up
rm -f /tmp/fetch-figma-icons.swift

echo "🎉 Icon fetch completed!"

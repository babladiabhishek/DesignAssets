#!/usr/bin/env swift

import Foundation

// Figma Icons Build Tool
// This runs during SPM build to fetch fresh icons

let token = ProcessInfo.processInfo.environment["FIGMA_PERSONAL_TOKEN"] ?? ""
let fileId = ProcessInfo.processInfo.environment["FIGMA_FILE_ID"] ?? "T0ahWzB1fWx5BojSMkfiAE"
let maxIcons = Int(ProcessInfo.processInfo.environment["MAX_ICONS"] ?? "9999") ?? 9999
let forceDownload = ProcessInfo.processInfo.environment["FORCE_DOWNLOAD"] == "true"

print("🚀 Build-time Figma icon fetch...")
print("📁 File ID: \(fileId)")
print("🔑 Token: \(String(token.prefix(10)))...")
print("📊 Max icons: \(maxIcons)")

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
    var successCount = 0
    var failCount = 0
    
    for (index, nodeId) in componentIds.enumerated() {
        print("⬇️ Processing \(index + 1)/\(componentIds.count): \(nodeId)")
        
        // Get component info
        guard let componentData = components[nodeId] as? [String: Any],
              let name = componentData["name"] as? String else {
            print("⚠️ Skipping invalid component: \(nodeId)")
            failCount += 1
            continue
        }
        
        let sanitizedName = sanitizeAssetName(name)
        
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
        
        URLSession.shared.dataTask(with: imageRequest) { data, response, error in
            if let error = error {
                print("❌ Image URL request error: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
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
            
            // Step 3: Download the actual image from the URL
            guard let downloadUrl = URL(string: actualImageUrl) else {
                print("❌ Invalid download URL")
                failCount += 1
                continue
            }
            
            let downloadSemaphore = DispatchSemaphore(value: 0)
            var actualImageData: Data?
            
            URLSession.shared.dataTask(with: downloadUrl) { data, response, error in
                if let error = error {
                    print("❌ Image download error: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        actualImageData = data
                    } else {
                        print("❌ Image download failed: \(httpResponse.statusCode)")
                    }
                }
                downloadSemaphore.signal()
            }.resume()
            
            downloadSemaphore.wait()
            
            // Step 4: Check if image already exists
            let imagesetDir = outputDir.appendingPathComponent("\(sanitizedName).imageset")
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
                failCount += 1
            }
            
        } catch {
            print("❌ JSON parsing error: \(error.localizedDescription)")
            failCount += 1
        }
    }
    
    print("🎉 Build-time download completed!")
    print("✅ Success: \(successCount) icons")
    print("❌ Failed: \(failCount) icons")
    
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

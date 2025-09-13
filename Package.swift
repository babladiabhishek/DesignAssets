// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "DesignAssets",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(name: "DesignAssets", targets: ["DesignAssets"])
  ],
  targets: [
    .target(
      name: "DesignAssets",
      resources: [.process("Resources/Icons.xcassets")]
    ),
    .plugin(
      name: "FetchIconsPlugin",
      capability: .command(
        intent: .custom(
          verb: "fetch-icons",
          description: "Fetch icons from Figma API directly into Icons.xcassets"
        ),
        permissions: [
          // Explicitly declare we'll access network & write sources
          .writeToPackageDirectory(reason: "Update Icons.xcassets with downloaded icons")
        ]
      )
    )
  ]
)

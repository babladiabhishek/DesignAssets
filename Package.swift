// swift-tools-version: 5.8
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
          dependencies: [],
          resources: [
            .process("Resources")
          ],
          plugins: [
            .plugin(name: "GenerateEnumsPlugin")
          ]
        ),
    .testTarget(
      name: "DesignAssetsTests",
      dependencies: ["DesignAssets"]
    ),
    .plugin(
        name: "GenerateEnumsPlugin",
        capability: .buildTool()
    ),
  ]
)

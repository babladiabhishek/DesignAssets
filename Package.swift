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
          path: "Sources/DesignAssets",
          resources: [
            .process("Resources")
          ],
          plugins: [
            .plugin(name: "GenerateEnumsPlugin")
          ]
        ),
    .testTarget(
      name: "DesignAssetsTests",
      dependencies: ["DesignAssets"],
      path: "Tests/DesignAssetsTests"
    ),
    .plugin(
        name: "GenerateEnumsPlugin",
        capability: .buildTool(),
        dependencies: [],
        path: "Plugins/GenerateEnumsPlugin"
    ),
  ]
)

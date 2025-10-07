// swift-tools-version: 5.10
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
          ]
        ),
    .testTarget(
      name: "DesignAssetsTests",
      dependencies: ["DesignAssets"]
    ),
    .plugin(
        name: "GenerateEnumsPlugin",
        capability: .command(
            intent: .custom(
                verb: "generate-enums",
                description: "Scan existing icon assets and generate type-safe Swift enums"
            ),
            permissions: [
                .writeToPackageDirectory(reason: "Generate Swift enums from existing icon assets")
            ]
        )
    ),
  ]
)

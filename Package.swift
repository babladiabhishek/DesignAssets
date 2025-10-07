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
        name: "GenerateIconsPlugin",
        capability: .command(
            intent: .custom(
                verb: "generate-icons",
                description: "Scan existing icon assets and generate type-safe Swift code"
            ),
            permissions: [
                .writeToPackageDirectory(reason: "Generate Swift code from existing icon assets")
            ]
        )
    ),
  ]
)

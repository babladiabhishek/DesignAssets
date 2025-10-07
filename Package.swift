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
          name: "FetchIconsPlugin",
          capability: .command(
            intent: .custom(
              verb: "fetch-icons",
              description: "Supercharged Figma icon fetcher - downloads all icons from any Figma file"
            ),
            permissions: [
              // Explicitly declare we'll access network & write sources
              .writeToPackageDirectory(reason: "Download and organize icons from Figma into asset catalogs"),
              .allowNetworkConnections(scope: .all(ports: []), reason: "Fetch icon metadata and SVGs from Figma API")
            ]
          )
        ),
  ]
)

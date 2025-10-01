// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "DesignAssets",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(name: "DesignAssets", targets: ["DesignAssets"]),
    .executable(name: "OrganizedIconsDemo", targets: ["OrganizedIconsDemo"]),
    .executable(name: "IconDebugTest", targets: ["IconDebugTest"])
  ],
  targets: [
    .target(
      name: "DesignAssets",
      dependencies: ["FetchIconsBuildTool"],
      resources: [
        .process("Resources/Icons/StatusIcons.xcassets"),
        .process("Resources/Icons/MapIcons.xcassets"),
        .process("Resources/Icons/FeelGoodIcons.xcassets"),
        .process("Resources/Icons/GeneralIcons.xcassets")
      ]
    ),
    .executableTarget(
      name: "FetchIconsBuildTool",
      path: "Scripts"
    ),
    .executableTarget(
      name: "OrganizedIconsDemo",
      dependencies: ["DesignAssets"],
      path: "Examples",
      sources: ["OrganizedIconsDemo.swift"]
    ),
    .executableTarget(
      name: "IconDebugTest",
      dependencies: ["DesignAssets"],
      path: "Examples",
      sources: ["IconDebugTest.swift"]
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
          .writeToPackageDirectory(reason: "Download and organize icons from Figma into asset catalogs")
        ]
      )
    )
  ]
)

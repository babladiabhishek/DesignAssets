// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OrganizedIconsExample",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .executable(name: "OrganizedIconsExample", targets: ["OrganizedIconsExample"])
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "OrganizedIconsExample",
            dependencies: ["DesignAssets"],
            path: ".",
            sources: ["OrganizedIconsDemo.swift"]
        )
    ]
)

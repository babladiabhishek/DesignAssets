#!/bin/bash

# Organized Icons Demo Runner
# This script runs the SwiftUI demo app

echo "🎨 Running Organized Icons Demo..."
echo ""

# Check if we're in the right directory
if [ ! -f "OrganizedIconsDemo.swift" ]; then
    echo "❌ Error: Please run this script from the Examples directory"
    echo "   cd Examples && ./run-demo.sh"
    exit 1
fi

# Check if Swift is available
if ! command -v swift &> /dev/null; then
    echo "❌ Error: Swift is not installed or not in PATH"
    exit 1
fi

# Create a temporary Package.swift for the demo
cat > Package.swift << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OrganizedIconsDemo",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .executable(name: "OrganizedIconsDemo", targets: ["OrganizedIconsDemo"])
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "OrganizedIconsDemo",
            dependencies: ["DesignAssets"],
            path: ".",
            sources: ["OrganizedIconsDemo.swift"]
        )
    ]
)
EOF

echo "📦 Building demo app..."
swift build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🚀 Running demo app..."
    echo "   (Press Ctrl+C to stop)"
    echo ""
    swift run OrganizedIconsDemo
else
    echo "❌ Build failed!"
    exit 1
fi

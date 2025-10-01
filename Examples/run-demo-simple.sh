#!/bin/bash

# Simple Demo Runner for Organized Icons
echo "🎨 Running Organized Icons Demo..."
echo ""

# Check if we're in the right directory
if [ ! -f "OrganizedIconsDemo.swift" ]; then
    echo "❌ Error: Please run this script from the Examples directory"
    echo "   cd Examples && ./run-demo-simple.sh"
    exit 1
fi

# Check if Swift is available
if ! command -v swift &> /dev/null; then
    echo "❌ Error: Swift is not installed or not in PATH"
    exit 1
fi

echo "📦 Building demo app..."
swift build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🚀 Running demo app..."
    echo "   (Press Ctrl+C to stop)"
    echo ""
    swift run OrganizedIconsExample
else
    echo "❌ Build failed!"
    exit 1
fi

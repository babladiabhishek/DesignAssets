#!/bin/bash

# Test script for the supercharged Figma integration
# This script demonstrates how to use the plugin with the provided Figma file

echo "🎨 Testing DesignAssets Figma Integration"
echo "========================================"

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Please run this script from the DesignAssets package root"
    exit 1
fi

# Check if Figma token is set
if [ -z "$FIGMA_PERSONAL_TOKEN" ]; then
    echo "⚠️  Warning: FIGMA_PERSONAL_TOKEN not set"
    echo "   Please set your Figma personal access token:"
    echo "   export FIGMA_PERSONAL_TOKEN='your_token_here'"
    echo ""
    echo "   You can get a token from: https://www.figma.com/settings"
    echo ""
    read -p "Enter your Figma token (or press Enter to skip): " token
    if [ ! -z "$token" ]; then
        export FIGMA_PERSONAL_TOKEN="$token"
    else
        echo "Skipping token setup. You can set it later and run the plugin manually."
        exit 0
    fi
fi

# Set the file ID from the provided Figma URL
export FIGMA_FILE_ID="T0ahWzB1fWx5BojSMkfiAE"

echo "🚀 Running Figma integration plugin..."
echo "📁 File ID: $FIGMA_FILE_ID"
echo "🔑 Token: ${FIGMA_PERSONAL_TOKEN:0:10}..."
echo ""

# Run the plugin
swift package plugin fetch-icons --token "$FIGMA_PERSONAL_TOKEN" --file-id "$FIGMA_FILE_ID"

# Check if the plugin ran successfully
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Plugin executed successfully!"
    echo ""
    echo "📁 Check the following files:"
    echo "   - Sources/DesignAssets/Resources/GeneratedIcons.swift"
    echo "   - Sources/DesignAssets/Resources/Icons.xcassets/"
    echo "   - Sources/DesignAssets/Resources/icon-summary.md"
    echo ""
    echo "🎉 Your Figma icons have been integrated into DesignAssets!"
else
    echo ""
    echo "❌ Plugin execution failed. Check the error messages above."
    echo ""
    echo "🔧 Troubleshooting tips:"
    echo "   1. Verify your Figma token has access to the file"
    echo "   2. Check that the file ID is correct"
    echo "   3. Ensure the file contains icon components"
    echo "   4. Try running: swift package plugin fetch-icons --help"
fi

#!/bin/bash

# Test script for real Figma integration
# This script demonstrates how to fetch real icons from your Figma file

echo "🎨 Testing Real Figma Integration"
echo "================================="

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Please run this script from the DesignAssets package root"
    exit 1
fi

# Set the file ID from your Figma URL
export FIGMA_FILE_ID="T0ahWzB1fWx5BojSMkfiAE"

echo "📁 File ID: $FIGMA_FILE_ID"
echo ""

# Check if Figma token is set
if [ -z "$FIGMA_PERSONAL_TOKEN" ]; then
    echo "⚠️  You need to set your Figma personal access token first:"
    echo ""
    echo "1. Go to https://www.figma.com/settings"
    echo "2. Click 'Personal Access Tokens'"
    echo "3. Create a new token"
    echo "4. Set it as an environment variable:"
    echo "   export FIGMA_PERSONAL_TOKEN='your_token_here'"
    echo ""
    echo "Then run this script again, or run the plugin directly:"
    echo "swift package plugin fetch-icons --token YOUR_TOKEN --file-id $FIGMA_FILE_ID --allow-writing-to-package-directory"
    echo ""
    exit 0
fi

echo "🔑 Token: ${FIGMA_PERSONAL_TOKEN:0:10}..."
echo ""

# Run the plugin with real Figma API
echo "🚀 Fetching real icons from Figma..."
swift package plugin fetch-icons --token "$FIGMA_PERSONAL_TOKEN" --file-id "$FIGMA_FILE_ID" --allow-writing-to-package-directory

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
    echo "🎉 Your real Figma icons have been integrated into DesignAssets!"
    echo ""
    echo "📊 Summary of what was fetched:"
    if [ -f "Sources/DesignAssets/Resources/icon-summary.md" ]; then
        cat "Sources/DesignAssets/Resources/icon-summary.md"
    fi
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

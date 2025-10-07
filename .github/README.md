# 🤖 GitHub Actions for Icon Management

This directory contains a GitHub Actions workflow that automatically fetches icons from Figma and generates type-safe Swift code for iOS development.

## 🎯 Overview

The workflow provides:
- **Automated icon fetching** from Figma on schedule or manual trigger
- **iOS Swift code generation** with type-safe enums
- **Asset catalog management** with proper Xcode integration
- **Cross-platform compatibility** - same assets can be used by any platform

## 📋 Workflow

### 🍎 iOS Icon Fetch (`fetch-icons.yml`)

**Triggers:**
- Manual dispatch (workflow_dispatch)
- Weekly schedule (every Monday at 9 AM UTC)
- Config file changes (icon-fetcher-config.json)
- Pull requests affecting config

**What it does:**
1. Fetches latest icons from Figma using the command plugin
2. Generates `GeneratedIcons.swift` with type-safe enums
3. Runs tests to ensure everything works
4. Commits and pushes changes automatically

**Output:**
- Updated `Sources/DesignAssets/GeneratedIcons.swift`
- Updated asset catalogs in `Sources/DesignAssets/Resources/`
- Build and test verification

## 🔧 Setup

### Required Secrets

Add these secrets to your GitHub repository:

1. **`FIGMA_PERSONAL_TOKEN`**
   - Go to [Figma Settings](https://www.figma.com/settings)
   - Navigate to **Account** → **Personal Access Tokens**
   - Create a new token with file access permissions
   - Add it as a repository secret

2. **`FIGMA_FILE_ID`**
   - Extract from your Figma file URL
   - Example: `https://www.figma.com/design/T0ahWzB1fWx5BojSMkfiAE/Icons`
   - File ID: `T0ahWzB1fWx5BojSMkfiAE`
   - Add it as a repository secret

### Configuration

The workflow uses the existing `icon-fetcher-config.json` file for additional configuration:

```json
{
  "figma": {
    "fileId": "your_file_id_here",
    "personalToken": "your_token_here"
  },
  "output": {
    "basePath": "Sources/DesignAssets/Resources",
    "autoDetectLayers": true,
    "createAssetCatalogs": true
  },
  "filtering": {
    "iconPrefixes": ["ic_", "map_", "status_", "navigation_"],
    "iconKeywords": ["icon", "ui", "button", "action"],
    "excludeSizeIndicators": ["_12", "_16", "_20", "_24", "_32"]
  }
}
```

## 🚀 Usage

### Manual Trigger

1. Go to **Actions** tab in your GitHub repository
2. Select **🎨 Fetch Icons from Figma**
3. Click **Run workflow**
4. Choose the branch and click **Run workflow**

### Automatic Triggers

- **Weekly Schedule**: Icons are fetched every Monday at 9 AM UTC
- **Config Changes**: Icons are fetched when `icon-fetcher-config.json` is modified
- **Pull Requests**: Icons are fetched when PRs affect the config

### Integration

#### iOS Integration

The generated `GeneratedIcons.swift` provides type-safe access:

```swift
import DesignAssets

// Use icons in SwiftUI
GeneratedIcons.General.generalIcSearchDefault32.image

// Use icons in UIKit
let imageView = UIImageView()
imageView.image = GeneratedIcons.General.generalIcSearchDefault32.uiImage

// Get all icons
let allIcons = DesignAssets.availableIconNames
let categories = DesignAssets.iconCategories
```

#### Cross-Platform Usage

The same SVG assets can be consumed by any platform:

- **React Native**: Use the SVG files directly
- **Flutter**: Convert SVGs to Flutter-compatible format
- **Web**: Use SVGs directly in HTML/CSS
- **Android**: Convert to Android drawable format

## 📊 Monitoring

### Workflow Status

- Check the **Actions** tab for workflow status
- Green checkmark ✅ = Success
- Red X ❌ = Failure (check logs for details)

### Summary Reports

Each workflow run generates a summary with:
- Total number of icons fetched
- Number of categories found
- Timestamp of the run
- List of categories discovered
- Usage examples

### Notifications

Configure notifications in your repository settings to get notified of:
- Workflow failures
- Successful icon updates
- Schedule changes

## 🔍 Troubleshooting

### Common Issues

1. **"Invalid token" error**
   - Verify `FIGMA_PERSONAL_TOKEN` secret is correct
   - Ensure token has file access permissions
   - Check token hasn't expired

2. **"No icons found"**
   - Verify `FIGMA_FILE_ID` secret is correct
   - Check that the Figma file contains icon components
   - Ensure token has access to the file

3. **Build failures**
   - Check that the generated Swift code compiles
   - Verify all dependencies are available
   - Review the workflow logs for specific errors

4. **Permission errors**
   - Ensure the workflow has write permissions
   - Check that the repository allows Actions to modify files
   - Verify the `GITHUB_TOKEN` has sufficient permissions

### Debug Mode

To enable debug logging, add this to your workflow:

```yaml
- name: 🎨 Fetch Icons from Figma
  run: |
    export DEBUG=true
    # ... rest of the command
```

### Manual Testing

You can test the workflow locally:

```bash
# Test the fetch command
swift package plugin --allow-writing-to-package-directory --allow-network-connections all fetch-icons --token YOUR_TOKEN --file-id YOUR_FILE_ID

# Test the generation script
swift generate_icons.swift
```

## 🔄 Customization

### Schedule Changes

Modify the cron schedule in the workflow file:

```yaml
schedule:
  - cron: '0 9 * * 1'  # Every Monday at 9 AM UTC
  - cron: '0 0 * * *'  # Daily at midnight UTC
  - cron: '0 0 1 * *'  # Monthly on the 1st
```

### Filtering Options

Update `icon-fetcher-config.json` to customize which icons are fetched:

```json
{
  "filtering": {
    "iconPrefixes": ["ic_", "map_", "status_"],
    "iconKeywords": ["icon", "ui", "button"],
    "excludeSizeIndicators": ["_12", "_16", "_20"]
  }
}
```

### Output Customization

Modify the generated Swift code structure by editing the generation script in the workflow.

## 📈 Benefits

### For iOS Teams
- **Type Safety**: Compile-time checking of icon names
- **Auto-completion**: IDE support for all available icons
- **Consistency**: Standardized naming and organization
- **Automation**: No manual icon management needed

### For Cross-Platform Teams
- **Single Source**: One Figma file for all platforms
- **Consistency**: Same icons across all platforms
- **Version Control**: Track icon changes in Git history
- **Easy Integration**: Simple to consume by any platform

### For Design Teams
- **Single Source**: One Figma file for all platforms
- **Automation**: No manual export process needed
- **Consistency**: Same icons across all platforms
- **Version Control**: Track icon changes in Git history

## 🎉 Success!

With this workflow set up, your design system becomes truly cross-platform and automated. The iOS team gets type-safe, auto-completed icons, while other platforms can consume the same SVG assets. Designers can focus on creating great designs without worrying about the technical implementation details.

## 🔗 Related

- [Main README](../README.md) - Complete package documentation
- [Package.swift](../Package.swift) - Swift Package Manager configuration
- [icon-fetcher-config.json](../icon-fetcher-config.json) - Configuration file
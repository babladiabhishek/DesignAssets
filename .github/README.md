# GitHub Actions Workflows

This directory contains automated workflows for managing design assets from Figma.

## 🚀 Available Workflows

### 1. Production Icon Sync (`production.yml`)

**Triggers:**
- Manual trigger via GitHub Actions UI
- Every Monday at 9 AM UTC (scheduled)
- When the Python script or workflow files are updated

**What it does:**
- Fetches all icons from your production Figma file
- Uses advanced categorization algorithm
- Generates Swift code automatically
- Commits changes back to the repository
- Provides detailed summary of results

### 2. Manual Icon Fetch (`manual.yml`)

**Triggers:**
- Manual trigger only
- Includes option to force refresh all icons

**What it does:**
- Same as production workflow but manual control
- Option to force re-download all icons (ignores cache)
- Shows results without auto-committing

## 🔧 Setup Required

### Repository Secrets

Add these secrets to your GitHub repository settings:

1. **`FIGMA_FILE_ID`**: Your Figma file ID (e.g., `Ek2nrkmlV9KouRmmXE7j0C`)
2. **`FIGMA_PERSONAL_TOKEN`**: Your Figma personal access token

### How to Add Secrets:

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add both secrets with the exact names above

## 📋 Usage

### Manual Trigger (Recommended for testing):

1. Go to **Actions** tab in your repository
2. Select **Manual Icon Fetch** or **Fetch Icons from Production Figma**
3. Click **Run workflow**
4. For manual workflow, you can choose to force refresh all icons

### Automatic Updates:

The production workflow will automatically:
- Run every Monday at 9 AM UTC
- Check for new icons in your Figma file
- Update your repository with any changes
- Generate commit messages with detailed statistics

## 📊 What Gets Updated

When the workflow runs, it updates:

- **Asset Catalogs**: All `.xcassets` folders in `Sources/DesignAssets/Resources/`
- **Swift Code**: `Sources/DesignAssets/GeneratedIcons.swift`
- **Categories**: Flags, Icons, Images, Logos, Map, Illustrations

## 🔍 Monitoring

Check the **Actions** tab to see:
- Workflow execution history
- Detailed logs of the fetch process
- Summary of icons downloaded
- Any errors or issues

## 🛠️ Troubleshooting

### Common Issues:

1. **Missing Secrets**: Ensure both `FIGMA_FILE_ID` and `FIGMA_PERSONAL_TOKEN` are set
2. **Permission Errors**: Make sure your Figma token has access to the file
3. **No Changes**: If no icons are updated, your Figma file might not have changed

### Force Refresh:

Use the manual workflow with "Force refresh" enabled to re-download all icons, useful when:
- Testing the workflow
- Figma file structure changed
- You want to ensure all icons are up to date

## 📈 Benefits

- **Automated**: No manual intervention needed
- **Consistent**: Same process every time
- **Trackable**: Full history in GitHub Actions
- **Efficient**: Only downloads changed icons (unless forced)
- **Integrated**: Works seamlessly with your development workflow
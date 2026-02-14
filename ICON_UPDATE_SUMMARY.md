# Flutter Windows App Icon Replacement - Complete Solution

## Overview
This solution provides automated scripts to replace the default Flutter branding with your custom logo on Windows applications. The scripts convert your PNG logo to a multi-resolution ICO file and automatically replace the default app icon.

## Files Included

### Main Scripts
1. **`update_app_icon.ps1`** - PowerShell script (Recommended for Windows)
2. **`update_app_icon.py`** - Python script (Alternative option)
3. **`update_app_icon.bat`** - Batch wrapper for easy execution

### Documentation
4. **`ICON_UPDATE_README.md`** - Detailed usage instructions
5. **`test_icon_update.py`** - Test script to verify functionality

## Quick Start (PowerShell - Recommended)

1. **Navigate to your Flutter project directory:**
   ```powershell
   cd c:\xampp\htdocs\Boardinghouse-Finder\FE-Finder
   ```

2. **Run the icon update script:**
   ```powershell
   .\update_app_icon.ps1
   ```

3. **Rebuild your Flutter app:**
   ```bash
   flutter build windows
   ```

## How It Works

### PowerShell Script Features:
- **Automatic ImageMagick Installation**: If not present, installs via Chocolatey
- **Multi-resolution ICO Creation**: Generates 16x16, 24x24, 32x32, 48x48, 64x64, 128x128, 256x256 versions
- **Automatic Backup**: Preserves your existing icon with `.backup` extension
- **High-quality Resizing**: Uses ImageMagick for professional image processing
- **Progress Feedback**: Shows detailed conversion progress

### Python Script Features:
- **Automatic Pillow Installation**: Installs PIL library if missing
- **Multi-resolution ICO Creation**: Same quality resolutions as PowerShell version
- **High-quality Resampling**: Uses LANCZOS algorithm for crisp results
- **Cross-platform**: Works on Windows, macOS, and Linux

## Default Configuration

The scripts are pre-configured for the BH-Finder project:
- **Source Logo**: `assets/icons/BH-Finder.png`
- **Target Location**: `windows/runner/resources/app_icon.ico`
- **Backup**: Creates `app_icon.ico.backup` if icon exists

## Custom Usage Examples

### PowerShell:
```powershell
# Use custom logo path
.\update_app_icon.ps1 -SourceLogo "assets/images/my-logo.png"

# Specify different project directory
.\update_app_icon.ps1 -ProjectPath "C:\MyProjects\MyApp"

# Force ImageMagick installation
.\update_app_icon.ps1 -Force

# Combine options
.\update_app_icon.ps1 -SourceLogo "logo.png" -ProjectPath "../my-app" -Force
```

### Python:
```bash
# Use custom logo path
python update_app_icon.py --source-logo assets/images/my-logo.png

# Specify different project directory
python update_app_icon.py --project-path /path/to/my/project

# Combine options
python update_app_icon.py --source-logo logo.png --project-path ../my-app
```

## Requirements

### PowerShell Version:
- Windows PowerShell 5.1 or later
- Internet connection (for automatic ImageMagick installation)
- Administrator privileges (for Chocolatey/ImageMagick installation)

### Python Version:
- Python 3.6 or later
- Internet connection (for automatic Pillow installation)

## Troubleshooting

### Common Issues:

1. **"ImageMagick not found" (PowerShell):**
   - Script will attempt automatic installation
   - If it fails, manually install from: https://imagemagick.org/script/download.php#windows

2. **"Pillow not found" (Python):**
   - Script will automatically install Pillow
   - Manual installation: `pip install Pillow`

3. **Execution Policy Errors (PowerShell):**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Permission Denied:**
   - Run PowerShell/Command Prompt as Administrator
   - Ensure write permissions to project directory

## Verification

After running the script and rebuilding your app:

1. **Check the icon file:**
   ```
   FE-Finder\windows\runner\resources\app_icon.ico
   ```

2. **Rebuild the application:**
   ```bash
   flutter build windows
   ```

3. **Run the application:**
   ```bash
   flutter run -d windows
   ```

4. **Verify the icon appears in:**
   - Windows taskbar
   - Desktop shortcuts
   - Application window title bar
   - Windows Start menu

## Technical Details

### ICO File Specifications:
- **Formats**: 16x16, 24x24, 32x32, 48x48, 64x64, 128x128, 256x256 pixels
- **Color Depth**: 32-bit with alpha channel (transparency support)
- **Compression**: Uncompressed for maximum quality
- **Standard**: Windows ICO format compliant

### Image Processing:
- **PowerShell**: ImageMagick with high-quality resampling
- **Python**: PIL/Pillow with LANCZOS resampling algorithm
- **Transparency**: Properly handled for PNG files with alpha channels

## Best Practices

1. **Logo Design**:
   - Use PNG format with transparent background
   - Recommended size: 256x256 pixels or larger
   - Simple design that's recognizable at small sizes

2. **Testing**:
   - Always test on actual Windows machine
   - Check icon appearance at different sizes
   - Verify in taskbar, desktop, and start menu

3. **Backup**:
   - The script automatically creates backups
   - Keep original Flutter icons for reference

## Support

For issues with these scripts:
1. Check the detailed README: `ICON_UPDATE_README.md`
2. Run the test script: `python test_icon_update.py`
3. Verify your Flutter project structure matches expectations

## License

These scripts are provided for the BH-Finder project and can be freely modified for other Flutter projects.
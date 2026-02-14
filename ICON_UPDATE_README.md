# Flutter Windows App Icon Updater

This repository contains scripts to automatically convert your custom logo to a Windows ICO file and replace the default Flutter app icon.

## Available Scripts

### 1. PowerShell Script (`update_app_icon.ps1`)
- **Best for**: Windows users who prefer PowerShell
- **Requirements**: ImageMagick (automatically installs if missing)
- **Features**: 
  - Automatic ImageMagick installation via Chocolatey
  - Multi-resolution ICO creation (16x16, 24x24, 32x32, 48x48, 64x64, 128x128, 256x256)
  - Automatic backup of existing icon
  - Detailed progress output

### 2. Python Script (`update_app_icon.py`)
- **Best for**: Users who prefer Python or have Python environment set up
- **Requirements**: Python 3.6+ and Pillow library (automatically installs if missing)
- **Features**:
  - Uses PIL/Pillow for image processing
  - Multi-resolution ICO creation with high-quality resampling
  - Automatic backup of existing icon
  - Cross-platform compatibility

## Usage

### PowerShell Version

```powershell
# Basic usage (uses default paths)
.\update_app_icon.ps1

# Specify custom logo path
.\update_app_icon.ps1 -SourceLogo "path\to\your\logo.png"

# Specify project path
.\update_app_icon.ps1 -ProjectPath "C:\path\to\your\project"

# Force installation of ImageMagick without prompts
.\update_app_icon.ps1 -Force

# Combine parameters
.\update_app_icon.ps1 -SourceLogo "assets\icons\mylogo.png" -ProjectPath "..\my-flutter-app"
```

### Python Version

```bash
# Basic usage (uses default paths)
python update_app_icon.py

# Specify custom logo path
python update_app_icon.py --source-logo path/to/your/logo.png

# Specify project path
python update_app_icon.py --project-path /path/to/your/project

# Combine parameters
python update_app_icon.py --source-logo assets/icons/mylogo.png --project-path ../my-flutter-app
```

## Default Configuration

The scripts are pre-configured for the BH-Finder project:

- **Source Logo**: `assets/icons/BH-Finder.png`
- **Target Icon**: `windows/runner/resources/app_icon.ico`
- **Supported Resolutions**: 16x16, 24x24, 32x32, 48x48, 64x64, 128x128, 256x256

## How It Works

1. **Validation**: Checks if the source logo exists
2. **Backup**: Creates a backup of the existing app icon
3. **Conversion**: 
   - PowerShell: Uses ImageMagick to resize and combine multiple resolutions
   - Python: Uses PIL/Pillow with LANCZOS resampling for high quality
4. **Replacement**: Overwrites the default `app_icon.ico` file
5. **Verification**: Confirms successful replacement

## After Running the Script

To see your new icon in action:

1. Rebuild your Flutter Windows application:
   ```bash
   flutter build windows
   ```

2. Run the application:
   ```bash
   flutter run -d windows
   ```

3. Your custom icon will now appear:
   - In the Windows taskbar
   - On the desktop when pinned
   - In the application window title bar
   - In the Windows Start menu

## Troubleshooting

### PowerShell Script Issues

**ImageMagick not found:**
- The script will attempt to install ImageMagick automatically via Chocolatey
- If automatic installation fails, download manually from: https://imagemagick.org/script/download.php#windows

**Execution Policy Errors:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Python Script Issues

**Pillow installation fails:**
```bash
pip install Pillow
```

**Permission denied:**
- Run as administrator
- Or ensure the script has write permissions to the project directory

## Customization

You can modify the scripts to:
- Add/remove icon resolutions
- Change the default source/destination paths
- Adjust image processing quality
- Add support for other image formats

## Supported Image Formats

Both scripts support common image formats:
- PNG (recommended for transparency)
- JPEG
- BMP
- GIF

For best results, use PNG with transparent background.

## License

This tool is provided as-is for the BH-Finder project. Feel free to modify for your own projects.
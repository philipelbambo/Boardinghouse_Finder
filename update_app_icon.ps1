# Flutter Windows App Icon Updater
# This script converts a PNG logo to a multi-resolution ICO file and replaces the default Flutter app icon
# Usage: .\update_app_icon.ps1 [-SourceLogo "path\to\logo.png"] [-ProjectPath "path\to\flutter\project"]

param(
    [string]$SourceLogo = "assets\icons\BH-Finder.png",
    [string]$ProjectPath = ".",
    [switch]$Force = $false
)

# Function to check if required tools are available
function Test-ImageMagick {
    try {
        $magickPath = Get-Command "magick" -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Function to install ImageMagick if not present
function Install-ImageMagick {
    Write-Host "ImageMagick not found. Installing via Chocolatey..." -ForegroundColor Yellow
    
    # Check if Chocolatey is installed
    if (!(Get-Command "choco" -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey first..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    # Install ImageMagick
    choco install imagemagick -y
    refreshenv
    
    # Verify installation
    if (Test-ImageMagick) {
        Write-Host "ImageMagick installed successfully!" -ForegroundColor Green
    } else {
        Write-Error "Failed to install ImageMagick. Please install it manually from https://imagemagick.org/script/download.php#windows"
        exit 1
    }
}

# Function to convert PNG to multi-resolution ICO
function Convert-ToMultiResICO {
    param(
        [string]$InputPath,
        [string]$OutputPath
    )
    
    Write-Host "Converting $InputPath to multi-resolution ICO..." -ForegroundColor Cyan
    
    try {
        # Create temporary directory
        $tempDir = [System.IO.Path]::GetTempPath() + "flutter_icon_" + (Get-Random)
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        # Generate multiple resolutions for crisp display
        $resolutions = @(16, 24, 32, 48, 64, 128, 256)
        $tempFiles = @()
        
        foreach ($size in $resolutions) {
            $tempFile = Join-Path $tempDir "$size.png"
            magick convert $InputPath -resize "${size}x${size}" -background transparent -gravity center -extent "${size}x${size}" $tempFile
            $tempFiles += $tempFile
            Write-Host "  ✓ Created ${size}x${size} version" -ForegroundColor Green
        }
        
        # Combine all resolutions into a single ICO file
        $tempFilesString = $tempFiles -join " "
        magick convert $tempFilesString $OutputPath
        
        # Clean up temporary files
        Remove-Item -Path $tempDir -Recurse -Force
        
        Write-Host "ICO file created successfully at: $OutputPath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Failed to convert image: $($_.Exception.Message)"
        return $false
    }
}

# Function to get file size in human readable format
function Get-FileSize {
    param([string]$Path)
    if (Test-Path $Path) {
        $size = (Get-Item $Path).Length
        if ($size -gt 1MB) {
            return "$([math]::Round($size / 1MB, 2)) MB"
        } elseif ($size -gt 1KB) {
            return "$([math]::Round($size / 1KB, 2)) KB"
        } else {
            return "$size bytes"
        }
    }
    return "0 bytes"
}

# Main script execution
Write-Host "=== Flutter Windows App Icon Updater ===" -ForegroundColor Magenta
Write-Host ""

# Resolve absolute paths
$ProjectPath = Resolve-Path $ProjectPath
$SourceLogo = Join-Path $ProjectPath $SourceLogo
$TargetIconPath = Join-Path $ProjectPath "windows\runner\resources\app_icon.ico"

Write-Host "Project Path: $ProjectPath" -ForegroundColor White
Write-Host "Source Logo: $SourceLogo" -ForegroundColor White
Write-Host "Target Icon: $TargetIconPath" -ForegroundColor White
Write-Host ""

# Check if source logo exists
if (!(Test-Path $SourceLogo)) {
    Write-Error "Source logo not found: $SourceLogo"
    Write-Host "Please ensure your logo file exists at the specified path." -ForegroundColor Yellow
    exit 1
}

Write-Host "Source logo size: $(Get-FileSize $SourceLogo)" -ForegroundColor Gray
Write-Host ""

# Check for ImageMagick
if (!(Test-ImageMagick)) {
    if ($Force) {
        Install-ImageMagick
    } else {
        Write-Host "ImageMagick is required for image conversion." -ForegroundColor Yellow
        Write-Host "Would you like to install it now? (y/n): " -ForegroundColor Yellow -NoNewline
        $response = Read-Host
        if ($response -eq 'y' -or $response -eq 'yes') {
            Install-ImageMagick
        } else {
            Write-Host "Please install ImageMagick manually from https://imagemagick.org/script/download.php#windows" -ForegroundColor Red
            exit 1
        }
    }
}

# Backup existing icon
if (Test-Path $TargetIconPath) {
    $backupPath = "$TargetIconPath.backup"
    Copy-Item $TargetIconPath $backupPath -Force
    Write-Host "Backed up existing icon to: $backupPath" -ForegroundColor Yellow
}

# Convert and replace icon
if (Convert-ToMultiResICO -InputPath $SourceLogo -OutputPath $TargetIconPath) {
    Write-Host ""
    Write-Host "✅ Successfully updated app icon!" -ForegroundColor Green
    Write-Host "New icon size: $(Get-FileSize $TargetIconPath)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To see the changes:" -ForegroundColor Cyan
    Write-Host "1. Run 'flutter build windows' to rebuild your app" -ForegroundColor White
    Write-Host "2. The new icon will appear in the Windows taskbar and desktop" -ForegroundColor White
    Write-Host ""
} else {
    Write-Error "Failed to update app icon"
    exit 1
}

Write-Host "=== Process Complete ===" -ForegroundColor Magenta
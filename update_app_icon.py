# Flutter Windows App Icon Updater (Python Version)
# This script converts a PNG logo to a multi-resolution ICO file and replaces the default Flutter app icon
# Usage: python update_app_icon.py [--source-logo PATH] [--project-path PATH]

import argparse
import os
import sys
import subprocess
import tempfile
import shutil
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Pillow (PIL) is required. Installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow"])
    from PIL import Image

def get_file_size(filepath):
    """Get file size in human readable format"""
    if not os.path.exists(filepath):
        return "0 bytes"
    
    size = os.path.getsize(filepath)
    if size > 1024 * 1024:
        return f"{size / (1024 * 1024):.2f} MB"
    elif size > 1024:
        return f"{size / 1024:.2f} KB"
    else:
        return f"{size} bytes"

def convert_to_multi_res_ico(input_path, output_path):
    """
    Convert PNG to multi-resolution ICO file with multiple sizes for crisp display
    """
    print(f"Converting {input_path} to multi-resolution ICO...")
    
    try:
        # Open the source image
        img = Image.open(input_path)
        
        # Ensure image has transparency if it's a PNG with alpha channel
        if img.mode != 'RGBA':
            img = img.convert('RGBA')
        
        # Define standard Windows icon sizes for crisp display
        sizes = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
        
        # Create a list to hold resized images
        icon_images = []
        
        for size in sizes:
            # Resize image with high quality
            resized = img.resize(size, Image.Resampling.LANCZOS)
            
            # Handle transparency properly
            if resized.mode == 'RGBA':
                # Create a white background version for better visibility
                background = Image.new('RGBA', size, (255, 255, 255, 255))
                background.paste(resized, mask=resized.split()[-1])
                icon_images.append(background.convert('RGB'))
            else:
                icon_images.append(resized.convert('RGB'))
            
            print(f"  ✓ Created {size[0]}x{size[1]} version")
        
        # Save as ICO with multiple resolutions
        icon_images[0].save(
            output_path,
            format='ICO',
            sizes=sizes,
            append_images=icon_images[1:]
        )
        
        print(f"ICO file created successfully at: {output_path}")
        return True
        
    except Exception as e:
        print(f"Error converting image: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Update Flutter Windows app icon')
    parser.add_argument('--source-logo', default='assets/icons/BH-Finder.png',
                       help='Path to source PNG logo (relative to project root)')
    parser.add_argument('--project-path', default='.',
                       help='Path to Flutter project root')
    parser.add_argument('--force', action='store_true',
                       help='Skip confirmation prompts')
    
    args = parser.parse_args()
    
    print("=== Flutter Windows App Icon Updater (Python) ===\n")
    
    # Resolve absolute paths
    project_path = Path(args.project_path).resolve()
    source_logo = project_path / args.source_logo
    target_icon = project_path / "windows" / "runner" / "resources" / "app_icon.ico"
    
    print(f"Project Path: {project_path}")
    print(f"Source Logo: {source_logo}")
    print(f"Target Icon: {target_icon}")
    print()
    
    # Check if source logo exists
    if not source_logo.exists():
        print(f"Error: Source logo not found: {source_logo}")
        print("Please ensure your logo file exists at the specified path.")
        return 1
    
    print(f"Source logo size: {get_file_size(str(source_logo))}")
    print()
    
    # Backup existing icon
    if target_icon.exists():
        backup_path = target_icon.with_suffix('.ico.backup')
        shutil.copy2(target_icon, backup_path)
        print(f"Backed up existing icon to: {backup_path}")
    
    # Create target directory if it doesn't exist
    target_icon.parent.mkdir(parents=True, exist_ok=True)
    
    # Convert and replace icon
    if convert_to_multi_res_ico(str(source_logo), str(target_icon)):
        print()
        print("✅ Successfully updated app icon!")
        print(f"New icon size: {get_file_size(str(target_icon))}")
        print()
        print("To see the changes:")
        print("1. Run 'flutter build windows' to rebuild your app")
        print("2. The new icon will appear in the Windows taskbar and desktop")
        print()
        return 0
    else:
        print("Failed to update app icon")
        return 1

if __name__ == "__main__":
    sys.exit(main())
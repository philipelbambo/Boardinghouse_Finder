# Test script to verify icon update functionality
# This creates a simple test logo and runs the update process

import os
import sys
from pathlib import Path

def create_test_logo():
    """Create a simple test logo if one doesn't exist"""
    try:
        from PIL import Image, ImageDraw, ImageFont
        
        # Create a simple 256x256 test image
        img = Image.new('RGBA', (256, 256), (0, 100, 200, 255))  # Blue background
        draw = ImageDraw.Draw(img)
        
        # Draw "BH" text
        try:
            # Try to use a system font
            font = ImageFont.truetype("arial.ttf", 80)
        except:
            # Fallback to default font
            font = ImageFont.load_default()
        
        # Draw text centered
        text = "BH"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (256 - text_width) // 2
        y = (256 - text_height) // 2
        
        draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)
        
        # Save test logo
        test_logo_path = Path("assets/icons/BH-Finder.png")
        test_logo_path.parent.mkdir(parents=True, exist_ok=True)
        img.save(test_logo_path)
        
        print(f"✓ Created test logo: {test_logo_path}")
        return str(test_logo_path)
        
    except ImportError:
        print("Pillow not available, using existing logo")
        return "assets/icons/BH-Finder.png"

if __name__ == "__main__":
    print("=== Testing Icon Update Process ===\n")
    
    # Create test logo if needed
    logo_path = create_test_logo()
    
    # Test the Python script
    print("\nTesting Python script...")
    os.system(f'python update_app_icon.py --source-logo "{logo_path}"')
    
    print("\n=== Test Complete ===")
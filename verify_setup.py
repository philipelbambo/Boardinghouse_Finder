# Verification Script for Icon Update Setup
# Checks if all required components are properly configured

import os
import sys
from pathlib import Path

def check_file_exists(filepath, description):
    """Check if a file exists and report status"""
    exists = Path(filepath).exists()
    status = "✓" if exists else "✗"
    print(f"{status} {description}: {filepath}")
    return exists

def check_directory_exists(dirpath, description):
    """Check if a directory exists and report status"""
    exists = Path(dirpath).exists()
    status = "✓" if exists else "✗"
    print(f"{status} {description}: {dirpath}")
    return exists

def check_python_packages():
    """Check if required Python packages are available"""
    try:
        import PIL
        print("✓ Pillow (PIL) is available")
        return True
    except ImportError:
        print("✗ Pillow (PIL) not found - will be installed automatically")
        return False

def main():
    print("=== Flutter Windows Icon Update - Setup Verification ===\n")
    
    project_root = Path(".")
    
    # Check project structure
    print("Project Structure Check:")
    checks = [
        ("assets/icons/BH-Finder.png", "Source logo"),
        ("windows/runner/resources/app_icon.ico", "Target icon location"),
        ("windows/runner/Runner.rc", "Resource file"),
        ("pubspec.yaml", "Flutter config file")
    ]
    
    all_files_exist = True
    for filepath, description in checks:
        if not check_file_exists(filepath, description):
            all_files_exist = False
    
    print()
    
    # Check Python environment
    print("Python Environment Check:")
    print(f"✓ Python version: {sys.version}")
    check_python_packages()
    
    print()
    
    # Check script files
    print("Script Files Check:")
    script_checks = [
        ("update_app_icon.ps1", "PowerShell script"),
        ("update_app_icon.py", "Python script"),
        ("update_app_icon.bat", "Batch wrapper"),
        ("ICON_UPDATE_README.md", "Documentation"),
        ("ICON_UPDATE_SUMMARY.md", "Summary guide")
    ]
    
    all_scripts_exist = True
    for filepath, description in script_checks:
        if not check_file_exists(filepath, description):
            all_scripts_exist = False
    
    print()
    
    # Overall status
    if all_files_exist and all_scripts_exist:
        print("🎉 All checks passed! You're ready to update your app icon.")
        print("\nTo update your icon, run one of these commands:")
        print("  PowerShell: .\\update_app_icon.ps1")
        print("  Python:     python update_app_icon.py")
        print("  Batch:      update_app_icon.bat")
    else:
        print("⚠️  Some checks failed. Please verify your project setup.")
        if not all_files_exist:
            print("  - Missing required project files")
        if not all_scripts_exist:
            print("  - Missing script files")
    
    print("\n" + "="*60)

if __name__ == "__main__":
    main()
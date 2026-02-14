@echo off
REM Flutter Windows App Icon Updater - Batch Wrapper
REM This batch file runs the PowerShell icon update script

echo === Flutter Windows App Icon Updater ===
echo.

REM Check if PowerShell script exists
if not exist "update_app_icon.ps1" (
    echo Error: update_app_icon.ps1 not found in current directory
    echo Please run this batch file from the Flutter project root directory
    pause
    exit /b 1
)

REM Run the PowerShell script with execution policy bypass
echo Running PowerShell script...
echo.
powershell -ExecutionPolicy Bypass -File "update_app_icon.ps1" %*

echo.
echo Script execution completed.
pause
---
name: screenshot
description: Capture a screenshot of the running WPF application UI. Use this skill when asked to see, view, capture, or screenshot the current state of the WPF application's user interface.
---

# Vibe Screenshot Skill

This skill captures a PNG screenshot of the currently running WPF application and saves it to the `screenshots/` folder.

## When to Use

Use this skill when:
- You need to see the current visual state of the WPF application
- Verifying UI changes after modifying XAML or C# code
- Debugging visual layout issues
- Documenting the application's appearance

## Prerequisites

The WPF application must be running with the VibeServer extension. Start it with:
```powershell
cd MyWpfApp
dotnet watch run
```

## Usage

Run the script from the repository root:
```powershell
.\.github\skills\vibe-screenshot\get-screenshot.ps1
```

## Output

- Saves a timestamped PNG file to `screenshots/screenshot_YYYYMMDD_HHMMSS.png`
- Automatically opens the screenshot for viewing
- Returns the path to the saved screenshot

## Workflow Integration

After making UI changes:
1. Restart the app if needed (see vibe-restart skill)
2. Wait 2-3 seconds for the app to fully load
3. Run this script to capture the current state
4. Review the screenshot to verify changes

---
name: restart
description: Restart the WPF application to apply code or XAML changes. Use this skill when you need to restart the app after making changes, or when the UI needs to be refreshed because WPF hot reload is limited.
---

# Vibe Restart Skill

This skill triggers a restart of the WPF application via dotnet watch, allowing changes to be applied without manually pressing Ctrl+R.

## When to Use

Use this skill when:
- You've made changes to XAML files that didn't hot reload
- You've made changes to C# code that require a restart
- The application state needs to be reset
- You want to see changes take effect after editing files

## Prerequisites

The WPF application must be running in watch mode with the VibeServer extension:
```powershell
cd MyWpfApp
dotnet watch run
```

**Important**: The `dotnet watch run` process must be running in a separate terminal for the restart to work.

## Usage

Run the script from the repository root:
```powershell
.\.github\skills\vibe-restart\restart-app.ps1
```

## How It Works

1. Sends a shutdown signal to the running app via the `/restart/` endpoint
2. Waits briefly for the app to close
3. Touches `MyWpfApp\App.xaml.cs` to trigger `dotnet watch` to rebuild and restart

## Workflow Integration

Typical iteration workflow:
1. Make XAML or C# changes
2. Run this restart script
3. Wait 2-3 seconds for restart to complete
4. Use vibe-screenshot to verify the changes

Quick iteration command combining restart and screenshot:
```powershell
.\.github\skills\vibe-restart\restart-app.ps1; Start-Sleep -Seconds 3; .\.github\skills\vibe-screenshot\get-screenshot.ps1
```

## Notes

- WPF XAML hot reload is limited and often requires a restart for changes to apply
- The restart is graceful - it allows the app to shut down cleanly before restarting
- If the app is not running, you'll see an error message

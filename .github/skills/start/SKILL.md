```skill
---
name: start
description: Start the WPF application in watch mode. Use this skill when you need to launch the app for the first time or when it's not currently running.
---

# Vibe Start Skill

This skill starts the WPF application in watch mode and waits for it to be fully ready before returning.

## When to Use

Use this skill when:
- You need to start the WPF application for the first time
- The application is not currently running
- You want to ensure the app is ready before capturing screenshots or inspecting the tree

## Prerequisites

None - this skill will start the app from scratch.

## Usage

Run the script from the repository root:
```powershell
.\.github\skills\start\start-app.ps1
```

## How It Works

1. Checks if the app is already running (via port 5010)
2. If not running, starts `dotnet watch run` in the background
3. Waits up to 15 seconds for the app to become available
4. Reports success or failure

## Output

- Indicates if the app was already running
- Shows progress as it waits for the app to start
- Confirms when the app is ready for interaction

## Workflow Integration

Typical workflow for AI assistants:
1. Use this skill to start the app (only needs to be done once per session)
2. Make XAML or C# changes
3. Use restart skill to apply changes
4. Use screenshot skill to verify the result

## Notes

- The app runs in watch mode, so it will automatically rebuild and restart when files change
- You only need to start the app once - it stays running until manually closed
- If the app is already running, this skill will detect it and skip starting

# Vibe WPF Development Repository

This repository contains a WPF application with live inspection capabilities for rapid UI development and iteration.

## Project Structure

- **MyWpfApp/** - Main WPF application
- **VibeExtensions/** - Extension library providing HTTP server for live inspection
- **get-vibe.ps1** - PowerShell script to inspect running application

## Running the Application

Start the application in watch mode for hot reload during development:

```powershell
cd MyWpfApp
dotnet watch run
```

The app will automatically rebuild and restart when you modify `.cs` or `.xaml` files.

## Live Inspection with get-vibe.ps1

While the app is running, use `get-vibe.ps1` to inspect the UI:

### Get Screenshot
```powershell
.\get-vibe.ps1 ui
# or simply
.\get-vibe.ps1
```
Captures the current UI as PNG, saves with timestamp, and opens it.

### Get Visual Tree
```powershell
.\get-vibe.ps1 tree
```
Outputs the complete WPF visual tree as formatted JSON to console, showing element types, names, and hierarchy.

## Development Workflow for AI Assistants

When iterating on WPF UI:

1. **Start watch mode in a background terminal** (leave it running):
   ```powershell
   cd MyWpfApp
   dotnet watch run
   ```
   This terminal should remain open and running throughout your development session. The app will stay open and automatically rebuild/restart when files change.

2. **Make changes** to XAML or C# files (in your editor, not the terminal)

3. **Capture results** using get-vibe.ps1 (from a different terminal):
   - `.\get-vibe.ps1 ui` - Verify visual appearance
   - `.\get-vibe.ps1 tree` - Inspect element structure and naming

4. **Iterate** - Changes trigger automatic rebuild/restart via dotnet watch

This enables rapid feedback loops without manual restarts.

## VibeServer Details

The VibeExtensions library provides an HTTP server (initialized in App.xaml.cs) that exposes:
- `http://localhost:5010/ui/` - PNG screenshot endpoint
- `http://localhost:5010/tree/` - JSON visual tree endpoint

These endpoints allow external processes to observe the running application state.

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
Captures the current UI as PNG, saves with timestamp to `screenshots/` folder, and opens it.

### Get Visual Tree
```powershell
.\get-vibe.ps1 tree
```
Outputs the complete WPF visual tree as formatted JSON to console, showing element types, names, and hierarchy.

### Restart Application
```powershell
.\get-vibe.ps1 restart
```
Triggers `dotnet watch` to restart the application (equivalent to pressing Ctrl+R in the watch terminal). Useful for applying XAML changes that don't hot reload automatically.

## Development Workflow for AI Assistants

When iterating on WPF UI:

1. **Start the application**:
   - **In Visual Studio**: Run with F5 (hot reload works automatically)
   - **Using dotnet watch**: Run in a background terminal (leave it running):
     ```powershell
     cd MyWpfApp
     dotnet watch run
     ```
     This terminal should remain open and running throughout your development session. The app will stay open and automatically rebuild/restart when files change.

2. **Make changes** to XAML or C# files (in your editor, not the terminal)

3. **Apply changes and capture results**:
   - **In Visual Studio**: 
     - XAML changes apply automatically via hot reload (no restart needed)
     - Use `.\get-vibe.ps1 ui` to capture screenshots
     - Use `.\get-vibe.ps1 tree` to inspect element structure
   
   - **Using dotnet watch**:
     - `.\get-vibe.ps1 restart` - Restart the app to apply XAML changes (WPF hot reload is limited in dotnet watch)
     - Wait 2-3 seconds for restart to complete
     - `.\get-vibe.ps1 ui` - Verify visual appearance
     - `.\get-vibe.ps1 tree` - Inspect element structure and naming
     
     **Quick iteration**: Combine commands to restart and capture in one line:
     ```powershell
     .\get-vibe.ps1 restart; Start-Sleep -Seconds 3; .\get-vibe.ps1 ui
     ```

4. **Iterate** - Make changes and capture screenshots to verify

**Note on Hot Reload**: 
- **Visual Studio**: Hot reload works well for XAML changes when running with F5. No restart needed.
- **dotnet watch**: WPF XAML hot reload is limited and often requires a restart via `.\get-vibe.ps1 restart` instead of manually pressing Ctrl+R in the watch terminal.

This enables rapid feedback loops without manual restarts.

## VibeServer Details

The VibeExtensions library provides an HTTP server (initialized in App.xaml.cs) that exposes:
- `http://localhost:5010/ui/` - PNG screenshot endpoint
- `http://localhost:5010/tree/` - JSON visual tree endpoint

These endpoints allow external processes to observe the running application state.

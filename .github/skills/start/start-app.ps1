#!/usr/bin/env pwsh
# Start the WPF application in watch mode
# Usage: .\.github\skills\start\start-app.ps1

# Import shared utilities
$scriptRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
. (Join-Path $scriptRoot "common.ps1")

Write-Host "Checking if WPF app is already running..." -ForegroundColor Cyan

# Check if already running
if (Test-VibeServerConnection) {
    Write-Host "App is already running and ready!" -ForegroundColor Green
    exit 0
}

Write-Host "App is not running. Starting it now..." -ForegroundColor Yellow

# Get the MyWpfApp directory
$appDir = Join-Path (Get-Location) "MyWpfApp"
if (-not (Test-Path $appDir)) {
    Write-Host "Error: Could not find MyWpfApp directory at $appDir" -ForegroundColor Red
    exit 1
}

# Start the app in watch mode
Write-Host "Running: dotnet watch run (in background)" -ForegroundColor Cyan
Write-Host "Note: The app will stay running. Use Ctrl+C in the terminal to stop it later." -ForegroundColor Yellow

# Start the process in background
# Note: For AI assistants using run_in_terminal tool, make sure to set isBackground=true
$process = Start-Process -FilePath "dotnet" -ArgumentList "watch", "run" -WorkingDirectory $appDir -PassThru -WindowStyle Hidden

Write-Host "Waiting for app to start (this takes about 5-10 seconds)..." -ForegroundColor Cyan

# Wait for the server to become available
if (Wait-ForVibeServer -MaxAttempts 15 -DelaySeconds 1) {
    Write-Host "Success! App is running and ready on http://localhost:5010" -ForegroundColor Green
    Write-Host "You can now use the screenshot, tree, and restart skills." -ForegroundColor Green
    exit 0
}
else {
    Write-Host "Warning: App started but VibeServer is not responding after 15 seconds." -ForegroundColor Yellow
    Write-Host "The app may still be starting. Try waiting a bit longer." -ForegroundColor Yellow
    Write-Host "Process ID: $($process.Id)" -ForegroundColor Gray
    exit 1
}

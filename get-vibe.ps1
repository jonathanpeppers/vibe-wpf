# PowerShell script to test the screenshot server
# Usage: .\get-vibe.ps1 [ui|tree|restart]
# Default: ui

param(
    [ValidateSet("ui", "tree", "restart")]
    [string]$Mode = "ui"
)

if ($Mode -eq "ui") {
    Write-Host "Fetching screenshot from http://localhost:5010/ui/" -ForegroundColor Cyan

    try {
        # Make the HTTP request
        $response = Invoke-WebRequest -Uri "http://localhost:5010/ui/" -Method Get
        
        # Ensure screenshots directory exists
        $screenshotsDir = "screenshots"
        if (-not (Test-Path $screenshotsDir)) {
            New-Item -ItemType Directory -Path $screenshotsDir | Out-Null
        }
        
        # Save the image to a file
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $outputFile = Join-Path $screenshotsDir "screenshot_$timestamp.png"
        [System.IO.File]::WriteAllBytes($outputFile, $response.Content)
        
        Write-Host "Screenshot saved to: $outputFile" -ForegroundColor Green
        
        # Open the image
        Start-Process $outputFile
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
        Write-Host "Make sure the WPF application with VibeServer is running!" -ForegroundColor Yellow
    }
}
elseif ($Mode -eq "tree") {
    Write-Host "Fetching visual tree from http://localhost:5010/tree/" -ForegroundColor Cyan

    try {
        # Make the HTTP request
        $response = Invoke-WebRequest -Uri "http://localhost:5010/tree/" -Method Get
        
        # Display the JSON
        $json = $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 100
        Write-Host $json -ForegroundColor Green
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
        Write-Host "Make sure the WPF application with VibeServer is running!" -ForegroundColor Yellow
    }
}
elseif ($Mode -eq "restart") {
    Write-Host "Triggering app restart via dotnet watch..." -ForegroundColor Cyan
    
    try {
        # Call the restart endpoint to shutdown the app gracefully
        $response = Invoke-WebRequest -Uri "http://localhost:5010/restart/" -Method Get -TimeoutSec 2
        
        Write-Host "App shutdown triggered!" -ForegroundColor Green
        
        # Give app time to close
        Start-Sleep -Milliseconds 500
        
        # Touch a file to trigger dotnet watch rebuild and restart
        $triggerFile = "MyWpfApp\App.xaml.cs"
        if (Test-Path $triggerFile) {
            (Get-Item $triggerFile).LastWriteTime = Get-Date
            Write-Host "File change detected - dotnet watch will now restart the app." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Error: Could not connect to the running app." -ForegroundColor Red
        Write-Host "Make sure the WPF application is running with 'dotnet watch run'" -ForegroundColor Yellow
    }
}

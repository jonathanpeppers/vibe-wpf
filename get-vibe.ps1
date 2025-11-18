# PowerShell script to test the screenshot server
# Usage: .\test-screenshot.ps1 [ui|tree]
# Default: ui

param(
    [ValidateSet("ui", "tree")]
    [string]$Mode = "ui"
)

if ($Mode -eq "ui") {
    Write-Host "Fetching screenshot from http://localhost:5010/ui/" -ForegroundColor Cyan

    try {
        # Make the HTTP request
        $response = Invoke-WebRequest -Uri "http://localhost:5010/ui/" -Method Get
        
        # Save the image to a file
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $outputFile = "screenshot_$timestamp.png"
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

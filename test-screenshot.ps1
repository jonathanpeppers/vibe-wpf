# PowerShell script to test the screenshot server

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

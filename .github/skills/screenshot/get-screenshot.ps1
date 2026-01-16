# Capture a screenshot of the running WPF application
# Usage: .\.github\skills\vibe-screenshot\get-screenshot.ps1

# Import shared utilities
$scriptRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
. (Join-Path $scriptRoot "common.ps1")

Write-Host "Fetching screenshot from http://localhost:5010/ui/" -ForegroundColor Cyan

try {
    # Make the HTTP request to the UI endpoint
    $response = Invoke-VibeEndpoint -Endpoint "ui"
    
    # Get the screenshots directory
    $screenshotsDir = Get-VibeScreenshotsDirectory
    
    # Save the image to a timestamped file
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputFile = Join-Path $screenshotsDir "screenshot_$timestamp.png"
    [System.IO.File]::WriteAllBytes($outputFile, $response.Content)
    
    Write-Host "Screenshot saved to: $outputFile" -ForegroundColor Green
    
    # Open the image for viewing
    Start-Process $outputFile
    
    # Return the path for programmatic use
    return $outputFile
}
catch {
    Write-VibeError -ErrorMessage $_.Exception.Message
    exit 1
}

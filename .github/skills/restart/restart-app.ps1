# Restart the WPF application via dotnet watch
# Usage: .\.github\skills\vibe-restart\restart-app.ps1

# Import shared utilities
$scriptRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
. (Join-Path $scriptRoot "common.ps1")

Write-Host "Triggering app restart via dotnet watch..." -ForegroundColor Cyan

try {
    # Call the restart endpoint to shutdown the app gracefully
    # Use a short timeout since the app will shut down
    $response = Invoke-VibeEndpoint -Endpoint "restart" -TimeoutSec 2
    
    Write-Host "App shutdown triggered!" -ForegroundColor Green
}
catch {
    # Connection errors are expected since the app is shutting down
    if ($_.Exception.Message -notlike "*Unable to connect*" -and 
        $_.Exception.Message -notlike "*connection was closed*" -and
        $_.Exception.Message -notlike "*operation has timed out*") {
        Write-VibeError -ErrorMessage $_.Exception.Message
        exit 1
    }
    Write-Host "App shutdown triggered!" -ForegroundColor Green
}

# Give app time to close
Start-Sleep -Milliseconds 500

# Touch a file to trigger dotnet watch rebuild and restart
$triggerFile = Join-Path (Get-Location) "MyWpfApp\App.xaml.cs"
if (Test-Path $triggerFile) {
    (Get-Item $triggerFile).LastWriteTime = Get-Date
    Write-Host "File change detected - dotnet watch will now restart the app." -ForegroundColor Green
    Write-Host "Waiting for app to restart..." -ForegroundColor Yellow
    
    # Wait for the app to restart and become available
    Start-Sleep -Seconds 2
    if (Wait-ForVibeServer -MaxAttempts 8 -DelaySeconds 1) {
        Write-Host "App restarted successfully and is ready!" -ForegroundColor Green
    }
    else {
        Write-Host "Warning: App may still be restarting. Wait a few more seconds." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Warning: Could not find $triggerFile to trigger rebuild." -ForegroundColor Yellow
    Write-Host "The app should still restart if dotnet watch detected the shutdown." -ForegroundColor Yellow
}

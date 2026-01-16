# Shared utilities for Vibe WPF skills
# This file is imported by the individual skill scripts

$script:VibeServerBaseUrl = "http://localhost:5010"

function Test-VibeServerConnection {
    <#
    .SYNOPSIS
    Tests if the Vibe server is running and accessible.
    
    .DESCRIPTION
    Attempts to connect to the Vibe server to verify the WPF application is running.
    
    .OUTPUTS
    Boolean indicating whether the server is accessible.
    #>
    try {
        $null = Invoke-WebRequest -Uri "$script:VibeServerBaseUrl/tree/" -Method Get -TimeoutSec 2
        return $true
    }
    catch {
        return $false
    }
}

function Write-VibeError {
    <#
    .SYNOPSIS
    Writes a standardized error message for Vibe connection failures.
    
    .PARAMETER ErrorMessage
    The specific error message to display.
    #>
    param(
        [string]$ErrorMessage
    )
    
    Write-Host "Error: $ErrorMessage" -ForegroundColor Red
    Write-Host "Make sure the WPF application with VibeServer is running!" -ForegroundColor Yellow
    Write-Host "Start it with: cd MyWpfApp && dotnet watch run" -ForegroundColor Yellow
}

function Get-VibeScreenshotsDirectory {
    <#
    .SYNOPSIS
    Gets the screenshots directory path, creating it if needed.
    
    .OUTPUTS
    The path to the screenshots directory.
    #>
    $screenshotsDir = Join-Path (Get-Location) "screenshots"
    if (-not (Test-Path $screenshotsDir)) {
        New-Item -ItemType Directory -Path $screenshotsDir | Out-Null
    }
    return $screenshotsDir
}

function Invoke-VibeEndpoint {
    <#
    .SYNOPSIS
    Makes an HTTP request to a Vibe server endpoint.
    
    .PARAMETER Endpoint
    The endpoint path (e.g., "ui", "tree", "restart").
    
    .PARAMETER TimeoutSec
    Request timeout in seconds. Default is 10.
    
    .OUTPUTS
    The web response object.
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Endpoint,
        
        [int]$TimeoutSec = 10
    )
    
    $uri = "$script:VibeServerBaseUrl/$Endpoint/"
    return Invoke-WebRequest -Uri $uri -Method Get -TimeoutSec $TimeoutSec
}

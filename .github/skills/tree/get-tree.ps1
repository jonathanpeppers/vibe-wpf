# Get the visual tree of the running WPF application
# Usage: .\.github\skills\vibe-tree\get-tree.ps1

# Import shared utilities
$scriptRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
. (Join-Path $scriptRoot "common.ps1")

Write-Host "Fetching visual tree from http://localhost:5010/tree/" -ForegroundColor Cyan

try {
    # Make the HTTP request to the tree endpoint
    $response = Invoke-VibeEndpoint -Endpoint "tree"
    
    # Parse and re-format the JSON for pretty display
    $json = $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 100
    
    Write-Host $json -ForegroundColor Green
    
    # Return the parsed JSON object for programmatic use
    return ($response.Content | ConvertFrom-Json)
}
catch {
    Write-VibeError -ErrorMessage $_.Exception.Message
    exit 1
}

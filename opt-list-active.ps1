Write-Host "======================" -ForegroundColor Green
Write-Host "   opt-list-active    " -ForegroundColor Green
Write-Host "======================" -ForegroundColor Green

$storagePath = Join-Path $PSScriptRoot 'opt-storage/paths.txt'
if (Test-Path $storagePath) {
    # Read all tool paths and names into a hashtable for quick lookup
    $toolMap = @{}
    Get-Content $storagePath | ForEach-Object {
        if ($_ -match '^\s*([^,]+)\s*,\s*(.+)$') {
            $name = $matches[1].Trim()
            $path = $matches[2].Trim().ToLowerInvariant().TrimEnd('\','/')
            $toolMap[$path] = @{ Name = $name; RawPath = $matches[2].Trim() }
        }
    }

    $envPaths = ($env:PATH -split ';') | ForEach-Object { $_.Trim().ToLowerInvariant().TrimEnd('\','/') }
    $printed = @{}
    $found = $false
    $i = 1
    foreach ($envPath in $envPaths) {
        if ($toolMap.ContainsKey($envPath) -and -not $printed.ContainsKey($envPath)) {
            $found = $true
            $tool = $toolMap[$envPath]
            Write-Host "$($i)> " -ForegroundColor Green -NoNewline
            Write-Host "$($tool.Name)" -ForegroundColor Cyan -NoNewline
            Write-Host " : " -NoNewline
            Write-Host $tool.RawPath -ForegroundColor Yellow
            $printed[$envPath] = $true
            $i++
        }
    }
    if (-not $found) {
        Write-Host "No active tools found."
    }
} else {
    Write-Host "No tools found."
}
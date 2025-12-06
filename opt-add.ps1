param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ScriptName,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Path
)

try {
    # Determine script directory
    $ScriptPath = $MyInvocation.MyCommand.Path
    if ([string]::IsNullOrEmpty($ScriptPath)) {
        $ScriptDirectory = Get-Location
    } else {
        $ScriptDirectory = Split-Path -Parent $ScriptPath
    }

    $PathsFile = Join-Path -Path $ScriptDirectory -ChildPath "paths.txt"

    # Normalize script name
    $ScriptName = $ScriptName.Trim()
    if ($ScriptName.EndsWith(".ps1", [System.StringComparison]::InvariantCultureIgnoreCase)) {
        $ScriptName = $ScriptName.Substring(0, $ScriptName.Length - 4)
    }

    # Normalize and resolve path
    $Path = $Path.Trim()
    if (-not ([System.IO.Path]::IsPathRooted($Path))) {
        # Resolve relative path to absolute based on current location
        $ResolvedPath = Resolve-Path -Path $Path -ErrorAction Stop
        $Path = $ResolvedPath.Path
    } else {
        # Ensure proper canonical path
        $Path = [System.IO.Path]::GetFullPath($Path)
    }

    $newEntry = "$ScriptName, $Path"

    # Read existing file safely, normalize lines
    $lines = @()
    if (Test-Path $PathsFile) {
        $lines = Get-Content $PathsFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    }

    # Check for existing entry (case-insensitive)
    $exists = $lines | Where-Object { ($_ -split ',',2)[0].Trim() -ieq $ScriptName }

    if ($exists) {
        Write-Host "Entry for '$ScriptName' already exists." -ForegroundColor Yellow
        exit 0
    }

    # Append new entry in-memory
    $lines += $newEntry

    # Sort by ScriptName (case-insensitive)
    $lines = $lines | Sort-Object { ($_ -split ',',2)[0].Trim().ToLower() }

    # Write back everything with exactly one line per entry
    $lines | Set-Content -Path $PathsFile -Encoding utf8

    Write-Host "Added entry:" -ForegroundColor Green
    Write-Host "  $newEntry" -ForegroundColor Green
    
    $GenerateScript = Join-Path -Path $ScriptDirectory -ChildPath "opt-generate.ps1"
    if (Test-Path $GenerateScript) {
        Write-Host "Running opt-generate.ps1 to update toggle scripts..." -ForegroundColor Cyan
        & $GenerateScript
    } else {
        Write-Host "opt-generate.ps1 not found. Skipping toggle script generation." -ForegroundColor Yellow
    }
    # Write-Host "Run opt-generate.ps1 to create toggle scripts." -ForegroundColor Cyan

} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
